//
//  TAddCloudViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 20.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamCloudViewController.h"
#import "TCountdown.h"
#import "TAddCamCompletedViewController.h"

typedef NS_ENUM(NSUInteger, TDahuaCloudStage) {
    TDahuaCloudStageFetchFirmwareInfo,
    TDahuaCloudStageFetchFirmwareData,
    TDahuaCloudStageBegin,
    TDahuaCloudStageDeviceInitialization,
    TDahuaCloudStageCamCheckFirmware,
    TDahuaCloudStageCamInstallFirmware,
    TDahuaCloudStageConfigureNTP,
    TDahuaCloudStageConnectToService,
    TDahuaCloudStageCameraSetup,
    TDahuaCloudStageCompleted
};

static void *TAddCamCloudViewControllerFwDownloadProgress = &TAddCamCloudViewControllerFwDownloadProgress;

@interface TAddCamCloudViewController ()<TCountdownDelegate, TDahuaCamBlankCloudDelegate, TDahuaCamBlankFirmwareDelegate>
@property (nonatomic, weak) IBOutlet TCountdown *countdown;
@property (nonatomic, weak) IBOutlet UILabel *waitLabel;
@property (nonatomic, weak) IBOutlet UILabel *stageLabel;

@property (nonatomic, strong) dispatch_queue_t dispatchCloudQueue;
@property (nonatomic, strong) NSOperationQueue *cloudSysOperations;
@property (nonatomic, assign) TDahuaCloudStage stage;
@property (nonatomic, strong) NSString *retryError;
@property (nonatomic, strong) NSURLSessionDownloadTask *fwDownloadTask;
@property (nonatomic, strong) NSProgress *fwDownloadTaskProgress;
@end

@implementation TAddCamCloudViewController

- (void)dealloc{
    [_fwDownloadTaskProgress safeRemoveObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        self.dispatchCloudQueue = dispatch_queue_create("com.tricolor.dahua.cloud.manager", DISPATCH_QUEUE_SERIAL);
        self.cloudSysOperations = [NSOperationQueue new];
        self.cloudSysOperations.underlyingQueue = self.dispatchCloudQueue;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.waitLabel.text = LSTR(@"cam-to-cloud-wait");
    self.stage = TDahuaCloudStageBegin;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.stage == TDahuaCloudStageBegin){
#if TADD_CAM_FW_UPDATE_ON
        //self.countdown.totalTime = DAHUA_CAM_CLOUD_BASE_TIME_SEC + (self.blank.firmwareUpdated ? DAHUA_CAM_REBOOT_TIME_SEC + DAHUA_CAM_FW_INSTALL_TIME_SEC : 0);
        self.countdown.totalTime = DAHUA_CAM_CLOUD_BASE_TIME_SEC + DAHUA_CAM_REBOOT_TIME_SEC + DAHUA_CAM_FW_INSTALL_TIME_SEC;
#else
        self.countdown.totalTime = 90;
#endif
        [self.countdown start];
        [self stageDeviceInitialization];
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    if (!parent){
        self.run = NO;
        OSServerCancelTask(self.fwDownloadTask);
    }
    else{
        self.run = YES;
    }
}

- (void)countdownTimeIsOut:(TCountdown*)countdown{
    [self.countdown start];
}

- (void)setBlank:(TDahuaCamBlank *)blank{
    [super setBlank:blank];
    blank.cloudDelegate = self;
}

#pragma mark- f0. server firmware info
- (void)stageFetchFirmwareInfo{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    self.stage = TDahuaCloudStageFetchFirmwareInfo;
    [self.cloudSysOperations cancelAllOperations];
    [self stageFetchFirmwareInfoInternal:2];
}

- (void)stageFetchFirmwareInfoInternal:(NSInteger)retryCount{
    __weak TAddCamCloudViewController *wself = self;
    [self.cloudSysOperations addOperationWithBlock:^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        // TODO: firmware update
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://API_DOMAIN/firmware"]];
        [sself.blank fetchServiceFirmwareInfos:request cb:^(NSDictionary<NSNumber *,TFirmwareInfo *> * _Nonnull infos, NSError * _Nonnull error) {
            __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
            if (error){
                WiFiLog(@"%s[%d] e:%@", __FUNCTION__, __LINE__, error);
                if (retryCount > 0){
                    [sself stageFetchFirmwareInfoInternal:retryCount-1];
                }
                else{
                    sself.retryError = LSTR(@"onvif-wifi-cam-fw-fetch-head-err");
                }
            }
            else{
                TFirmwareInfo *info = [sself.blank firmwareInfoForCurrentCam];
                if (!info){
                    WiFiLog(@"%s[%d] firmware not found", __FUNCTION__, __LINE__);
                    sself.retryError = LSTR(@"onvif-wifi-cam-fw-fetch-head-err");
                    return;
                }
                if (info.cached){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
                        [sself stageCheckFirmware];
                    });
                }
                else{
                    [self.cloudSysOperations addOperationWithBlock:^{
                        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
                        [sself stageFetchFirmwareData];
                    }];
                }
            }
        }];
    }];
}

#pragma mark- f1. server firmware fetch
- (void)stageFetchFirmwareData{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    self.stage = TDahuaCloudStageFetchFirmwareData;
    [self.cloudSysOperations cancelAllOperations];
    [self stageFetchFirmwareDataInternal:2];
}

- (void)stageFetchFirmwareDataInternal:(NSInteger)retryCount{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamCloudViewController *wself = self;
    [self.cloudSysOperations addOperationWithBlock:^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        TFirmwareInfo *info = sself.blank.firmwareInfoForCurrentCam;
        if (info){
            WiFiLog(@"%s[%d] info:%@", __FUNCTION__, __LINE__, info);
            sself.fwDownloadTask =
            [info fetch:^(TFirmwareInfo * _Nonnull info, NSError * _Nonnull error) {
                __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
                sself.fwDownloadTask = nil;
                if (error){
                    WiFiLog(@"%s[%d] e:%@", __FUNCTION__, __LINE__, error);
                    if (error.code == NSURLErrorCancelled){
                        return;
                    }
                    if (retryCount > 0){
                        [sself stageFetchFirmwareDataInternal:retryCount-1];
                    }
                    else{
                        sself.retryError = error.localizedDescription;
                    }
                }
                else{
                    NSError *fmerror;
                    NSDictionary *attrs = [NSFileManager.defaultManager attributesOfItemAtPath:info.localCacheFile.path error:&fmerror];
                    if (!attrs){
                        WiFiLog(@"%s[%d] failed to get fw attrs, e:%@", __FUNCTION__, __LINE__, fmerror);
                    }
                    else{
                        WiFiLog(@"%s[%d] fw downloaded, sz:%@ perm:%@", __FUNCTION__, __LINE__,
                                [attrs objectForKey:NSFileSize],
                                [attrs objectForKey:NSFilePosixPermissions]);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
                        [sself stageCheckFirmware];
                    });
                }
            }];
        }
        else if (retryCount > 0){
            [sself stageFetchFirmwareDataInternal:retryCount-1];
        }
        else{
            sself.retryError = LSTR(@"onvif-wifi-cam-fw-fetch-head-err");
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == TAddCamCloudViewControllerFwDownloadProgress){
        if (self.stage == TDahuaCloudStageFetchFirmwareData){
            // show progress for downloading .bin file
            __weak TAddCamCloudViewController *wself = self;
            dispatch_block_t block = ^(){
                __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
                NSString *title = [NSString stringWithFormat:@"%@ %.1f%%", LSTR(@"wifi-stage-fetch-fw-data"), sself.fwDownloadTaskProgress.fractionCompleted * 100];
                sself.stageLabel.text = title;
            };
            DISPATCH_BLOCK_MAIN_ASYNC_IF_NEEDED(block);
        }
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setFwDownloadTask:(NSURLSessionDownloadTask *)fwDownloadTask{
    _fwDownloadTask = fwDownloadTask;
    self.fwDownloadTaskProgress = fwDownloadTask.progress;
}

- (void)setFwDownloadTaskProgress:(NSProgress *)fwDownloadTaskProgress{
    [_fwDownloadTaskProgress safeRemoveObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))];
    _fwDownloadTaskProgress = fwDownloadTaskProgress;
    [fwDownloadTaskProgress addObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted)) options:KVO_NEW_OLD_INITIAL context:TAddCamCloudViewControllerFwDownloadProgress];
}

#pragma mark- f2. check firmware
- (void)stageCheckFirmware{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    self.stage = TDahuaCloudStageCamCheckFirmware;
    [self.cloudSysOperations cancelAllOperations];
    [self stageCheckFirmwareInternal:5];
}

- (void)stageCheckFirmwareInternal:(NSInteger)retryCount{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamCloudViewController *wself = self;
    [self.cloudSysOperations addOperationWithBlock:^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        NSDate *date = nil;
        NSString *version = nil;
        [sself.blank loginToCamera:1];
        if ([sself.blank camFirmwareVersion:&date version:&version]){
            TFirmwareInfo *info = sself.blank.firmwareInfoForCurrentCam;
            WiFiLog(@"%s[%d]\rsvr:{%@,%@}\rcam:{%@,%@}",__FUNCTION__,__LINE__,info.buildDate,info.version,date,version);
            if (TDahuaCamBlank.forceFirmwareUpdate){
                date = [NSDate dateWithTimeIntervalSince1970:0];
            }
            switch([info.buildDate compare:date]){
                case NSOrderedSame:{
                    WiFiLog(@"%s[%d] firmware is actual", __FUNCTION__, __LINE__);
                    [sself stageConfigureNTP];
                }break;
                case NSOrderedAscending:{
                    WiFiLog(@"%s[%d] firmware is newer than on the server, perform a downgrade", __FUNCTION__, __LINE__);
                    //[sself stageCamWiFiNTPConfig];
                    [sself stageInstallFirmware];
                }break;
                case NSOrderedDescending:{
                    WiFiLog(@"%s[%d] firmware is deprecated", __FUNCTION__, __LINE__);
                    [sself stageInstallFirmware];
                }break;
            }
        }
        else if (retryCount > 0){
            [sself stageCheckFirmwareInternal:retryCount-1];
        }
        else{
            sself.retryError = LSTR(@"onvif-wifi-cam-fw-cam-info-err");
        }
    }];
}

#pragma mark- f3. install firmware
- (void)stageInstallFirmware{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    self.stage = TDahuaCloudStageCamInstallFirmware;
    __weak TAddCamCloudViewController *wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        sself.countdown.totalTime = DAHUA_CAM_CLOUD_BASE_TIME_SEC + DAHUA_CAM_FW_INSTALL_TIME_SEC + DAHUA_CAM_REBOOT_TIME_SEC + DAHUA_CAM_REBOOT_TIME_SEC + 30;
    });
    [self.cloudSysOperations cancelAllOperations];
    self.blank.firmwareDelegate = self;
    self.blank.firmwareInstallRetryCount = 3;
    [self stageInstallFirmwareInternal:self.blank.firmwareInstallRetryCount];
}

- (void)stageInstallFirmwareInternal:(NSInteger)retryCount{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamCloudViewController *wself = self;
    [self.cloudSysOperations addOperationWithBlock:^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        [sself.blank installFirmware];
    }];
}

- (void)blankFirmware:(TDahuaCamBlank*)blank uploadProgressChanged:(CGFloat)progress{
    if (!self.run){
        return;
    }
    if (self.stage == TDahuaCloudStageCamInstallFirmware){
        // show progress for downloading .bin file
        __weak TAddCamCloudViewController *wself = self;
        dispatch_block_t block = ^(){
            __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
            NSString *title = [NSString stringWithFormat:@"%@ %.1f%%", LSTR(@"wifi-stage-install-fw-transfer"), progress];
            sself.stageLabel.text = title;
        };
        DISPATCH_BLOCK_MAIN_ASYNC_IF_NEEDED(block);
    }
}

- (void)blankFirmware:(TDahuaCamBlank*)blank installProgressChanged:(CGFloat)progress{
    if (!self.run){
        return;
    }
    if (self.stage == TDahuaCloudStageCamInstallFirmware){
        // show progress for downloading .bin file
        __weak TAddCamCloudViewController *wself = self;
        dispatch_block_t block = ^(){
            __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
            NSString *title = [NSString stringWithFormat:@"%@ %.1f%%", LSTR(@"wifi-stage-install-fw-setup"), progress];
            sself.stageLabel.text = title;
        };
        DISPATCH_BLOCK_MAIN_ASYNC_IF_NEEDED(block);
    }
}

- (void)blankFirmware:(TDahuaCamBlank*)blank updateError:(NSError*)error{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d] e:%@", __FUNCTION__, __LINE__, error);
    __weak TAddCamCloudViewController *wself = self;
    [self.cloudSysOperations addOperationWithBlock:^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        if (sself.blank.firmwareInstallRetryCount > 0){
            sself.blank.firmwareInstallRetryCount--;
            [sself stageInstallFirmwareInternal:sself.blank.firmwareInstallRetryCount];
        }
        else{
            sself.blank.firmwareDelegate = nil;
            sself.retryError = error.localizedDescription;
        }
    }];
}

- (void)blankFirmwareUpdateCompleted:(TDahuaCamBlank*)blank{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    self.blank.firmwareUpdated = YES;
    
    __weak TAddCamCloudViewController *wself = self;
    [self.cloudSysOperations addOperationWithBlock:^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
            sself.stageLabel.text = LSTR(@"wifi-stage-wait-after-fw-update-reboot");
        });
        [sself longSleepPringSec:DAHUA_CAM_REBOOT_TIME_SEC text:"wait reboot after fw update"];
        [sself stageConfigureNTP];
    }];
}

#pragma mark- 1. LAN initialization
- (void)stageDeviceInitialization{
    self.stage = TDahuaCloudStageDeviceInitialization;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    if (self.blank.connectiionType == TDahuaCamBlankConnectionTypeWiFi){
        [self connectToService];
    }
    else{
        __weak TAddCamCloudViewController *wself = self;
        [self.cloudSysOperations addOperationWithBlock:^{
            __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
            sself.blank.firmwareUpdated = NO;
            [NSNotificationCenter.defaultCenter addObserver:sself selector:@selector(TDahuaCamConnectionCamFound:) name:TDahuaCamConnectionCamFoundNotification object:nil];
            BOOL res = NO;
            NSInteger rc = 3;
            do {
                if (!sself.blank.macAddress){
                    [TDahuaCamConnection.instance stopSearchDevices:YES];
                }
                else{
                    res = [sself.blank initializeCameraDevice];
                }
                if (!res){
                    usleep(USEC_PER_SEC * 10);
                }
            } while (!res && --rc > 0);
            [NSNotificationCenter.defaultCenter removeObserver:self name:TDahuaCamConnectionCamFoundNotification object:nil];
            if (res){
#if TADD_CAM_FW_UPDATE_ON
                [sself stageFetchFirmwareInfo];
#else
                [sself stageConfigureNTP];
#endif
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *err = [NSError errorWithDomain:@"Dahua"
                                                       code:-1
                                                   userInfo:@{NSLocalizedDescriptionKey:LSTR(@"add-cam-ethernet-cam-not-found-message")}];
                    [IPDHelper showError:err withCancel:^{
                        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
                        [sself.navigationController popViewControllerAnimated:YES];
                    } andRetry:^{
                        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
                        [sself stageDeviceInitialization];
                    }];
                });
            }
        }];
    }
}

- (void)TDahuaCamConnectionCamFound:(NSNotification*)note{
    TDahuaCamBlank *b = note.object;
    WiFiLog(@"LAN %s[%d]", __FUNCTION__, __LINE__);
    if (self.run &&
        b.serial &&
        [self.blank.serial isEqualToString:b.serial]){
        self.blank.macAddress = b.macAddress;
        self.blank.localIP = b.localIP;
        self.blank.localIPSubNetMask = b.localIPSubNetMask;
        self.blank.localIPGateway = b.localIPGateway;
        self.blank.macAddress = b.macAddress;
        self.blank.initSupported = b.initSupported;
        self.blank.initCompleted = b.initCompleted;
        self.blank.byPwdResetWay = b.byPwdResetWay;
    }
}

#pragma mark- 2. ntp (LAN only)
- (void)stageConfigureNTP{
    self.stage = TDahuaCloudStageConfigureNTP;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamCloudViewController *wself = self;
    [self.cloudSysOperations addOperationWithBlock:^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        BOOL res;
        NSInteger rc = 20;
        do {
            res = [sself.blank configNTPToTimeZone:NSTimeZone.localTimeZone];
            if (!res){
                usleep(USEC_PER_SEC * 0.5);
            }
        } while (!res && --rc > 0);
        
        if (res){
            [sself connectToService];
        }
        else{
            WiFiLog(@"%s[%d] code:%d ssid:%@ and pass:%@", __FUNCTION__, __LINE__, res, sself.blank.wifiSSID, sself.blank.wifiSecurityKey);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err = [NSError errorWithDomain:@"Dahua"
                                                   code:-1
                                               userInfo:@{NSLocalizedDescriptionKey:LSTR(@"add-cam-ethernet-cam-not-found-message")}];
                [IPDHelper showError:err withCancel:^{
                    __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
                    [sself.navigationController popViewControllerAnimated:YES];
                } andRetry:^{
                    __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
                    [sself stageConfigureNTP];
                }];
            });
        }
    }];
}

#pragma mark 3. connect to cloud
- (void)connectToService{
    self.stage = TDahuaCloudStageConnectToService;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamCloudViewController *wself = self;
    [self.cloudSysOperations addOperationWithBlock:^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        // TODO: урл апи для подключения камеры
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://API_DOMAIN/add_dev_by_sn"]];
        [sself.blank connectToCloudWithSerial:request retryCount:20];
    }];
}

- (void)blankWillStartAddingToCloud:(TDahuaCamBlank*)blank{
    __weak TAddCamCloudViewController *wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        if (!sself.countdown.isStarted){
            [sself.countdown start];
        }
    });
}

- (void)blankAddedToCloud:(TDahuaCamBlank*)blank{
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    [self completed];
}

- (void)blank:(TDahuaCamBlank*)blank addToCloudError:(NSError*)error{
    WiFiLog(@"%s[%d] error:%@", __FUNCTION__, __LINE__, error);
    __weak TAddCamCloudViewController *wself = self;
    [IPDHelper showError:error withCancel:^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        [sself.navigationController popToRootViewControllerAnimated:YES];
    } andRetry:^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        [sself connectToService];
    }];
}

#pragma mark 4. completed
- (void)completed{
    self.stage = TDahuaCloudStageCameraSetup;
    __weak TAddCamCloudViewController *wself = self;
    
    [self.cloudSysOperations addOperationWithBlock:^{
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        int sleep_time = DAHUA_CAM_REBOOT_TIME_SEC;
        if (sself.blank.firmwareUpdated){
            if (sself.blank.connectiionType == TDahuaCamBlankConnectionTypeWiFi){
                sleep_time += DAHUA_CAM_REBOOT_TIME_SEC + 10;
            }
            else{
                sleep_time += DAHUA_CAM_REBOOT_TIME_SEC;
            }
        }
        [self longSleepPringSec:sleep_time text:"wait while cam is waking up"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [sself completedInternal];
        });
    }];
}

- (void)completedInternal{
    metrica_report_event(@"AddCam.Cloud.Connect.Complete");
    self.stage = TDahuaCloudStageCompleted;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    [self.cloudSysOperations cancelAllOperations];
    TAddCamCompletedViewController *vc = (id)[TAddCamCompletedViewController initWithMainBundle];
    vc.blank = self.blank;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- stage details
- (void)setStage:(TDahuaCloudStage)stage{
    _stage = stage;
    NSString *k;
    switch (stage) {
        case TDahuaCloudStageFetchFirmwareInfo:{k = @"wifi-stage-fetch-fw-info";}break;
        case TDahuaCloudStageFetchFirmwareData:{k = @"wifi-stage-fetch-fw-data";}break;
        case TDahuaCloudStageCamCheckFirmware:{k = @"wifi-stage-get-cam-fw-version";}break;
        case TDahuaCloudStageCamInstallFirmware:{k = @"wifi-stage-install-fw-transfer";}break;
        case TDahuaCloudStageBegin:{k = @"";}break;
        case TDahuaCloudStageDeviceInitialization:{k = @"wifi-stage-fetch-cam-params";}break;
        case TDahuaCloudStageConfigureNTP:{k = @"wifi-stage-configure-ntp";}break;
        case TDahuaCloudStageConnectToService:{k = @"wifi-stage-add-cam-to-service";}break;
        case TDahuaCloudStageCompleted:{k = @"wifi-stage-completed";}break;
        case TDahuaCloudStageCameraSetup:{k = @"wifi-stage-camera-setup";}break;
        default: {k = @"";}break;
    }
    NSString *stageStr = LSTR(k);
    __weak TAddCamCloudViewController *wself = self;
    dispatch_block_t block = ^(){
        __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
        sself.stageLabel.text = stageStr;
    };
    DISPATCH_BLOCK_MAIN_ASYNC_IF_NEEDED(block);
}

#pragma mark- retry error
- (void)setRetryError:(NSString *)retryError{
    _retryError = retryError;
    if (self.run && retryError){
        __weak TAddCamCloudViewController *wself = self;
        dispatch_block_t block = ^(){
            __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
            if (sself.onScreen){
                [IPDHelper showRetryAlert:retryError withCancel:^{
                    __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
                    [sself.navigationController popToRootViewControllerAnimated:YES];
                } andOK:^{
                    __strong TAddCamCloudViewController *sself = wself;if (!sself) return;
                    [sself retryLastStage];
                }];
            }
        };
        DISPATCH_BLOCK_MAIN_ASYNC_IF_NEEDED(block);
    }
}

- (void)retryLastStage{
    switch (self.stage) {
        case TDahuaCloudStageFetchFirmwareInfo:
            [self stageFetchFirmwareInfo];
            break;
        case TDahuaCloudStageFetchFirmwareData:
            [self stageFetchFirmwareData];
            break;
        case TDahuaCloudStageBegin:
            break;
        case TDahuaCloudStageDeviceInitialization:
            [self stageDeviceInitialization];
            break;
        case TDahuaCloudStageCamCheckFirmware:
            [self stageCheckFirmware];
            break;
        case TDahuaCloudStageCamInstallFirmware:
            [self stageInstallFirmware];
            break;
        case TDahuaCloudStageConfigureNTP:
            [self stageConfigureNTP];
            break;
        case TDahuaCloudStageConnectToService:
            [self connectToService];
            break;
        case TDahuaCloudStageCameraSetup:
            [self completed];
            break;
        case TDahuaCloudStageCompleted:
            break;
        default:
            break;
    }
}

#pragma mark-
- (TAddCamRightButtonType)barRightButtonType{
    return TAddCamRightButtonTriDot;
}

- (TAddCamRightMenuMask)barRightButtonMenuMask{
    return TAddCamRightMenuToBegin;
}

@end
