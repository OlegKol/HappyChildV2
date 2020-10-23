//
//  TAddWiFiRouterViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 20.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamWiFiRouterViewController.h"
#import "TAddCamCloudViewController.h"
#import <NetworkExtension/NetworkExtension.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TCountdown.h"

static void *TAddCamWiFiRouterViewControllerFwDownloadProgress = &TAddCamWiFiRouterViewControllerFwDownloadProgress;

const NSInteger TD_RETRY = 20;
const int64_t TD_RETRY_DELAY_SEC = 1;
const uint64_t WAIT_AFTER_WIFI_CHANGE_TIME_USEC = USEC_PER_SEC * 10;
const NSInteger TWIFI_COUNTDOWN_BASE_WAIT_TIME = 120;
NSString *const TD_MONITOR_REPEAT_COUNT = @"TD_MONITOR_REPEAT_COUNT";
NSString *const TD_MONITOR_SSID = @"TD_MONITOR_SSID";
NSString *const TD_MONITOR_CALLBACK = @"TD_MONITOR_CALLBACK";

typedef NS_ENUM(NSUInteger, TDahuaWiFiStage) {
    TDahuaWiFiStageFetchFirmwareInfo,
    TDahuaWiFiStageFetchFirmwareData,
    TDahuaWiFiStageBegin,
    TDahuaWiFiStageDeviceConnectsToCamWiFI,
    TDahuaWiFiStageDeviceConnectsToUserWiFi,
    TDahuaWiFiStageCamDeviceInitialization,
    TDahuaWiFiStageCamWiFiLogin,
    TDahuaWiFiStageCamWiFiCheckFirmware,
    TDahuaWiFiStageCamWiFiInstallFirmware,
    TDahuaWiFiStageDeviceConnectsToCamWiFIAfterFWUpdateReboot,
    TDahuaWiFiStageCamWiFiNTP,
    TDahuaWiFiStageCamWiFiToAccessPoint,
    TDahuaWiFiStageFindCamInNetwork,
    TDahuaWiFiStageDeviceSoundToCamMicrophone,
};

// user enter ssid/pass of wi-fi network that cam will be connected to
// 1. phone connects to cam.wifi
// 2. cam connects to user wi-fi
// 3. phone connects to user wi-fi
// 4. UPnP controller automatically find cam connected to same network and push CloudViewController

@interface TAddCamWiFiRouterViewController ()<TCountdownDelegate, TDahuaAudioConfigDelegate, AVAudioPlayerDelegate, TDahuaCamBlankWiFiDelegate, TDahuaCamBlankFirmwareDelegate>{
    dispatch_block_t wifiBlock;
}
@property (nonatomic, assign) TDahuaWiFiStage stage;
@property (nonatomic, weak) IBOutlet TCountdown *countdown;
@property (nonatomic, weak) IBOutlet UILabel *waitLabel;
@property (nonatomic, weak) IBOutlet UILabel *stageLabel;
@property (nonatomic, strong) TDahuaAudioConfig *audioConfig;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) dispatch_queue_t dispatchWiFiQueue;
@property (nonatomic, strong) dispatch_queue_t dispatchWiFiUserQueue;
@property (nonatomic, strong) NSOperationQueue *wifiUserOperations;
@property (nonatomic, strong) NSOperationQueue *wifiSysOperations;

@property (nonatomic, strong) NSTimer *wifiMonitorTimer;
@property (nonatomic, strong) NSString *retryError;
@property (nonatomic, strong) NSURLSessionDownloadTask *fwDownloadTask;
@property (nonatomic, strong) NSProgress *fwDownloadTaskProgress;
@end

@implementation TAddCamWiFiRouterViewController
@synthesize stage = _stage;

- (void)dealloc{
    [_fwDownloadTaskProgress safeRemoveObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        self.dispatchWiFiQueue = dispatch_queue_create("com.tricolor.dahua.wifi.manager", DISPATCH_QUEUE_SERIAL);
        self.dispatchWiFiUserQueue = dispatch_queue_create("com.tricolor.dahua.wifi.manager.user.interactive", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.waitLabel.text = LSTR(@"cam-to-router-wait");
#if TADD_CAM_FW_UPDATE_ON
    self.stage = TDahuaWiFiStageFetchFirmwareInfo;
#else
    self.stage = TDahuaWiFiStageBegin;
#endif
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    if (!parent){
        self.run = NO;
        [self.wifiSysOperations cancelAllOperations];
        [self.wifiUserOperations cancelAllOperations];
        self.wifiSysOperations = nil;
        self.wifiUserOperations = nil;
        OSServerCancelTask(self.fwDownloadTask);
    }
    else{
        self.run = YES;
        if (!self.wifiSysOperations){
            self.wifiSysOperations = [NSOperationQueue new];
            self.wifiSysOperations.underlyingQueue = self.dispatchWiFiQueue;
        }
        if (!self.wifiUserOperations){
            self.wifiUserOperations = [NSOperationQueue new];
            self.wifiUserOperations.underlyingQueue = self.dispatchWiFiUserQueue;
        }
    }
}

- (void)setBlank:(TDahuaCamBlank *)blank{
    [super setBlank:blank];
    if (blank){
        self.audioConfig = [TDahuaAudioConfig configWithDahuaCamBlank:blank delegate:self];
        blank.wifiDelegate = self;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.stage ==
#if TADD_CAM_FW_UPDATE_ON
            TDahuaWiFiStageFetchFirmwareInfo
#else
            TDahuaWiFiStageBegin
#endif
        ){
        if (self.configViaSoundKuku){
            self.countdown.totalTime = TWIFI_COUNTDOWN_BASE_WAIT_TIME;
            [self.countdown start];
            [self soundTap:nil];
        }
        else{
            self.countdown.totalTime = TWIFI_COUNTDOWN_BASE_WAIT_TIME;
            [self.countdown start];
#if TADD_CAM_FW_UPDATE_ON
            [self stageFetchFirmwareInfo];
#else
            [self stageBegin];
#endif
        }
    }
}

#pragma mark- progress
- (void)countdownTimeIsOut:(TCountdown*)countdown{
    [self.countdown start];
}

#pragma mark- blank wifi delegate
- (void)blankNeedWiFiReconnect:(TDahuaCamBlank*)blank{
    // phone disconnected from cam.wifi while cam search wifi.network with user.ssid
    // ask to connect device to camera again, or it connects aumatically
    // if cam.wifi is configured eth2-ssid is unavailable to connect to it
    if (self.run && !blank.wifiConfigured){
        __weak TAddCamWiFiRouterViewController *wself = self;
        [self connectToWiFiWithSSID:self.blank.camWifiSSID
                           password:self.blank.camWifiSecurityKey
                          isCamSSID:YES
                         retryCount:3
                                 cb:^(NSString *error, BOOL rfail) {
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
            if (error){
                WiFiLog(@"wifi blank reconnect failed, settings prompt will begin err:'%@'", error);
                if (!rfail){
                    [sself wiFiSettingsPromt:sself.blank.camWifiSSID
                                   isCamSSID:YES
                                        okcb:^(){
                        
                    }];
                }
            }
            else{
                
            }
        }];
    }
}

- (void)blankWiFiConfigured:(TDahuaCamBlank*)blank{
    // to stop ask for device->cam reconnect blankNeedWiFiReconnect
    if (blank.wifiDelegate == self){
        blank.wifiDelegate = nil;
    }
}

#pragma mark- retry error
- (void)setRetryError:(NSString *)retryError{
    _retryError = retryError;
    if (self.run && retryError){
        __weak TAddCamWiFiRouterViewController *wself = self;
        dispatch_block_t block = ^(){
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
            if (sself.onScreen){
                [IPDHelper showRetryAlert:retryError withCancel:^{
                    __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                    [sself.navigationController popToRootViewControllerAnimated:YES];
                } andOK:^{
                    __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                    [sself retryLastStage];
                }];
            }
        };
        DISPATCH_BLOCK_MAIN_ASYNC_IF_NEEDED(block);
    }
}

- (void)retryLastStage{
    switch (self.stage) {
        case TDahuaWiFiStageFetchFirmwareInfo:
            [self stageFetchFirmwareInfo];
            break;
        case TDahuaWiFiStageFetchFirmwareData:
            [self stageFetchFirmwareData];
            break;
        case TDahuaWiFiStageBegin:
            [self stageBegin];
            break;
        case TDahuaWiFiStageDeviceConnectsToCamWiFI:
            [self stageDeviceConnectToCamWiFi];
            break;
        case TDahuaWiFiStageDeviceConnectsToUserWiFi:
            [self stageDeviceConnectToUserWiFi:wifiBlock];
            break;
        case TDahuaWiFiStageCamDeviceInitialization:
            [self stageCamDeviceInitialization];
            break;
        case TDahuaWiFiStageCamWiFiLogin:
            [self stageCamWiFiLogin];
            break;
        case TDahuaWiFiStageCamWiFiCheckFirmware:
            [self stageCheckFirmware];
            break;
        case TDahuaWiFiStageCamWiFiInstallFirmware:
            [self stageInstallFirmware];
            break;
        case TDahuaWiFiStageDeviceConnectsToCamWiFIAfterFWUpdateReboot:
            [self stageConnectToCamAfterFWUpdateReboot];
            break;
        case TDahuaWiFiStageCamWiFiNTP:
            [self stageCamWiFiNTPConfig];
            break;
        case TDahuaWiFiStageFindCamInNetwork:
            [self stageMonitorCamInLocalNetwork];
            break;
        case TDahuaWiFiStageDeviceSoundToCamMicrophone:
            [self soundTap:nil];
            break;
        default:
            break;
    }
}

- (BOOL)searchCamInLocalNet{
    //
    // at first ckeck if cam already connected to user.wifi and to cloud
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(TDahuaCamConnectionCamFound:) name:TDahuaCamConnectionCamFoundNotification object:nil];
    BOOL searchnow = [TDahuaCamConnection isSearchDevices];
    if (!searchnow){
        [TDahuaCamConnection.instance startSearchDevices];
        usleep(USEC_PER_SEC * 1);
    }
    BOOL res = NO;
    NSInteger rc = 10;
    do {
        const char *gateway = gatewayIP();
        // device and cam connected to same point
        // they can be connected as p2p, but if cam connected to router his "eth2-ssid" unavaiable
        if (gateway && self.blank.localIPGateway){
            // blank and cam connected to same network?
            if (0 == strcmp(gateway, self.blank.localIPGateway.UTF8String)){
                res = self.blank.macAddress && self.blank.localIP;
            }
        }
        if (!res){
            usleep(USEC_PER_SEC * 0.25);
        }
    } while (!res && --rc);
    if (!searchnow){
        [TDahuaCamConnection.instance stopSearchDevices:NO];
    }
    return res;
}

#pragma mark- f0. server firmware info
- (void)stageFetchFirmwareInfo{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    self.stage = TDahuaWiFiStageFetchFirmwareInfo;
    [self.wifiSysOperations cancelAllOperations];
    [self stageFetchFirmwareInfoInternal:2];
}

- (void)stageFetchFirmwareInfoInternal:(NSInteger)retryCount{
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        // TODO: обновление прошивки включено в либе
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://API_DOMAIN/firmware"]];
        [sself.blank fetchServiceFirmwareInfos:request cb:^(NSDictionary<NSNumber *,TFirmwareInfo *> * _Nonnull infos, NSError * _Nonnull error) {
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
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
                        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                        [sself stageBegin];
                    });
                }
                else{
                    [self.wifiSysOperations addOperationWithBlock:^{
                        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
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
    self.stage = TDahuaWiFiStageFetchFirmwareData;
    [self.wifiSysOperations cancelAllOperations];
    [self stageFetchFirmwareDataInternal:2];
}

- (void)stageFetchFirmwareDataInternal:(NSInteger)retryCount{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        TFirmwareInfo *info = sself.blank.firmwareInfoForCurrentCam;
        if (info){
            WiFiLog(@"%s[%d] info:%@", __FUNCTION__, __LINE__, info);
            sself.fwDownloadTask =
            [info fetch:^(TFirmwareInfo * _Nonnull info, NSError * _Nonnull error) {
                __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
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
                        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                        [sself stageBegin];
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
    if (context == TAddCamWiFiRouterViewControllerFwDownloadProgress){
        if (self.stage == TDahuaWiFiStageFetchFirmwareData){
            // show progress for downloading .bin file
            __weak TAddCamWiFiRouterViewController *wself = self;
            dispatch_block_t block = ^(){
                __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
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
    [fwDownloadTaskProgress addObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted)) options:KVO_NEW_OLD_INITIAL context:TAddCamWiFiRouterViewControllerFwDownloadProgress];
}

#pragma mark- f2. check firmware
- (void)stageCheckFirmware{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    self.stage = TDahuaWiFiStageCamWiFiCheckFirmware;
    [self.wifiSysOperations cancelAllOperations];
    [self stageCheckFirmwareInternal:5];
}

- (void)stageCheckFirmwareInternal:(NSInteger)retryCount{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        NSDate *date = nil;
        NSString *version = nil;
        if ([sself.blank camFirmwareVersion:&date version:&version]){
            TFirmwareInfo *info = sself.blank.firmwareInfoForCurrentCam;
            WiFiLog(@"%s[%d]\rsvr:{%@,%@}\rcam:{%@,%@}",__FUNCTION__,__LINE__,info.buildDate,info.version,date,version);
            if (TDahuaCamBlank.forceFirmwareUpdate){
                date = [NSDate dateWithTimeIntervalSince1970:0];
            }
            switch([info.buildDate compare:date]){
                case NSOrderedSame:{
                    WiFiLog(@"%s[%d] firmware is actual", __FUNCTION__, __LINE__);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                        sself.countdown.totalTime = TWIFI_COUNTDOWN_BASE_WAIT_TIME;
                    });
                    [sself stageCamWiFiNTPConfig];
                }break;
                case NSOrderedAscending:{
                    WiFiLog(@"%s[%d] firmware is newer than on the server, perform a downgrade", __FUNCTION__, __LINE__);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                        sself.countdown.totalTime = TWIFI_COUNTDOWN_BASE_WAIT_TIME + DAHUA_CAM_REBOOT_TIME_SEC;
                    });
                    [sself stageInstallFirmware];
                }break;
                case NSOrderedDescending:{
                    WiFiLog(@"%s[%d] firmware is deprecated", __FUNCTION__, __LINE__);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                        sself.countdown.totalTime = TWIFI_COUNTDOWN_BASE_WAIT_TIME + DAHUA_CAM_REBOOT_TIME_SEC;
                    });
                    [sself stageInstallFirmware];
                }break;
            }
        }
        else if (retryCount > 0){
            usleep(USEC_PER_SEC * 0.5);
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
    self.stage = TDahuaWiFiStageCamWiFiInstallFirmware;
    [self.wifiSysOperations cancelAllOperations];
    self.blank.firmwareDelegate = self;
    self.blank.firmwareInstallRetryCount = 3;
    [self stageInstallFirmwareInternal:self.blank.firmwareInstallRetryCount];
}

- (void)stageInstallFirmwareInternal:(NSInteger)retryCount{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        [sself.blank installFirmware];
    }];
}

- (void)blankFirmware:(TDahuaCamBlank*)blank uploadProgressChanged:(CGFloat)progress{
    if (!self.run){
        return;
    }
    if (self.stage == TDahuaWiFiStageCamWiFiInstallFirmware){
        // show progress for downloading .bin file
        __weak TAddCamWiFiRouterViewController *wself = self;
        dispatch_block_t block = ^(){
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
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
    if (self.stage == TDahuaWiFiStageCamWiFiInstallFirmware){
        // show progress for downloading .bin file
        __weak TAddCamWiFiRouterViewController *wself = self;
        dispatch_block_t block = ^(){
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
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
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
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
    self.blank.firmwareUpdated = YES;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        dispatch_block_t block = ^(){
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
            sself.stageLabel.text = LSTR(@"wifi-stage-wait-after-fw-update-reboot");
        };
        DISPATCH_BLOCK_MAIN_ASYNC_IF_NEEDED(block);
        [sself longSleepPringSec:DAHUA_CAM_REBOOT_TIME_SEC text:"wait reboot after fw update"];
        [sself stageConnectToCamAfterFWUpdateReboot];
    }];
}

- (void)stageConnectToCamAfterFWUpdateReboot{
    if (!self.run){
        return;
    }
    self.stage = TDahuaWiFiStageDeviceConnectsToCamWiFIAfterFWUpdateReboot;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        [TDahuaCamConnection.instance stopSearchDevices:NO];
        [sself connectToWiFiWithSSID:sself.blank.camWifiSSID
                            password:sself.blank.camWifiSecurityKey
                           isCamSSID:YES
                          retryCount:TD_RETRY
                                  cb:^(NSString *error, BOOL rfail) {
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
            if (error){
                WiFiLog(@"wifi connect failed settings prompt will begin err:'%@'", error);
                if (rfail){
                    sself.retryError = error;
                }
                else{
                    [sself wiFiSettingsPromt:sself.blank.camWifiSSID
                                   isCamSSID:YES
                                        okcb:^(){
                        [sself stageConnectToCamAfterFWUpdateReboot];
                    }];
                }
            }
            else{
                [sself.wifiSysOperations addOperationWithBlock:^{
                    __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                    usleep(WAIT_AFTER_WIFI_CHANGE_TIME_USEC);
                    [sself restartSearch];
                    [sself stageCamWiFiNTPConfig];
                }];
            }
        }];
    }];
}

#pragma mark- 0. begin
- (void)stageBegin{
    if (!self.run){
        return;
    }
    self.blank.firmwareUpdated = NO;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    if ([NetAddr.localWiFiSSID isEqualToString:self.blank.wifiSSID]){
        self.stage = TDahuaWiFiStageBegin;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(TDahuaCamConnectionCamFound:) name:TDahuaCamConnectionCamFoundNotification object:nil];
        [self.wifiSysOperations addOperationWithBlock:^{
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
            [sself restartSearch];
            BOOL res = [sself searchCamInLocalNet];
            // sself.blank.camConnection.delegate = nil;
            //
            // cam found in device subnetwork
            if (res){
                // TODO: search cam in cloud
                // перебрать список сууществующих камер и вернуть найденный по серийнику
                NSString *devcodeInCloud = nil; //[sself.blank devcodeFromSerial];
                if (devcodeInCloud){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                        [sself ignoreFinishScreenBlankAddedWithDevcode:devcodeInCloud];
                    });
                }
                else{
                    usleep(USEC_PER_SEC * 0.25);
                    [sself stageDeviceConnectToCamWiFi];
//                    BOOL res;
//                    NSInteger rc;
//                    rc = 5;
//                    do {
//                        res = [sself.blank configNTPToTimeZone:NSTimeZone.localTimeZone];
//                        if (!res){
//                            usleep(USEC_PER_SEC * 0.5);
//                        }
//                    } while (sself.run && !res && --rc > 0);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
//                        [sself pushCloudController];
//                    });
                }
            }
            else{
                usleep(USEC_PER_SEC * 0.25);
                [sself stageDeviceConnectToCamWiFi];
            }
        }];
    }
    else{
        WiFiLog(@"%s[%d] will connect to user wifi:%@", __FUNCTION__, __LINE__, self.blank.wifiSSID);
        [self stageDeviceConnectToUserWiFi:^{
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
            [sself.wifiSysOperations cancelAllOperations];
            [sself.wifiSysOperations addOperationWithBlock:^{
                __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                usleep(WAIT_AFTER_WIFI_CHANGE_TIME_USEC);
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                    [sself stageBegin];
                });
            }];
        }];
    }
}

#pragma mark 1. connect to cam wifi
- (void)stageDeviceConnectToCamWiFi{
    if (!self.run){
        return;
    }
    self.stage = TDahuaWiFiStageDeviceConnectsToCamWiFI;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [TDahuaCamConnection.instance stopSearchDevices:NO];
    [self connectToWiFiWithSSID:self.blank.camWifiSSID
                       password:self.blank.camWifiSecurityKey
                      isCamSSID:YES
                     retryCount:TD_RETRY
                             cb:^(NSString *error, BOOL rfail) {
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        if (error){
            WiFiLog(@"wifi connect failed settings prompt will begin err:'%@'", error);
            if (rfail){
                sself.retryError = error;
            }
            else{
                [sself wiFiSettingsPromt:sself.blank.camWifiSSID
                               isCamSSID:YES
                                    okcb:^(){
                    [sself stageDeviceConnectToCamWiFi];
                }];
            }
        }
        else{
            [self.wifiSysOperations addOperationWithBlock:^{
                __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                usleep(WAIT_AFTER_WIFI_CHANGE_TIME_USEC);
                [sself restartSearch];
                [sself stageCamDeviceInitialization];
            }];
        }
    }];
}

#pragma mark 2. cam initialization
- (void)stageCamDeviceInitialization{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    self.stage = TDahuaWiFiStageCamDeviceInitialization;
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations cancelAllOperations];
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        usleep(USEC_PER_SEC * 3);
        [sself stageCamDeviceInitializationInternal:3];
    }];
}

- (void)restartSearch{
    WiFiLog(@"%s[%d] search will restart...", __FUNCTION__, __LINE__);
    [TDahuaCamConnection.instance stopSearchDevices:YES];
    usleep(USEC_PER_SEC * 0.25);
    [TDahuaCamConnection.instance startSearchDevices];
    usleep(USEC_PER_SEC * 0.25);
}

- (void)stageCamDeviceInitializationInternal:(NSInteger)retryCount{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        BOOL res = NO;
        NSInteger rc, rc2;
        
        if (!sself.blank.macAddress){
            WiFiLog(@"%s[%d] cam mac address not detected...lasterr:%d", __FUNCTION__, __LINE__, DAHUA_ERR_LAST);
            [sself restartSearch];
            //
            // need wait some time while TDahuaCamConnection detects cam device and copy mac.address to blank
            // without mac address initialization fails
            //
            rc = 30;
            while (sself.run && !sself.blank.macAddress && --rc) {
                usleep(USEC_PER_SEC * 1.0);
                NSString *wifissid = NetAddr.localWiFiSSID;
#if !TARGET_IPHONE_SIMULATOR
                WiFiLog(@"%s[%d] cam search..., current ssid:%@, last err:%d", __FUNCTION__, __LINE__, wifissid, DAHUA_ERR_LAST);
#endif
                if ((rc % 5) == 0 && ![sself.blank askToConnectDeviceToCamWiFiIfNeed]){
                    WiFiLog(@"%s[%d] cam search can't be completed, device not connected to camera wifi", __FUNCTION__, __LINE__);
                    //
                    // askToConnectDeviceToCamWiFiIfNeed async call for connect to cam.wifi stageDeviceConnectToCamWiFi
                    return;
                }
            }
        }
        if (sself.blank.macAddress){
            rc2 = 3;
            WiFiLog(@"%s[%d] MAC:%@ detected", __FUNCTION__, __LINE__, sself.blank.macAddress);
            while(sself.run && !(res = [sself.blank initializeCameraDevice]) && rc2--){
                rc = 5;
                while (sself.run && (![sself.blank askToConnectDeviceToCamWiFiIfNeed]) && --rc) {
                    usleep(USEC_PER_SEC * 0.5);
                }
                usleep(USEC_PER_SEC * 0.2);
                rc = 5;
                while (sself.run && !sself.blank.deviceIPGatewayAsIPCam && --rc) {
                    char *gw = gatewayIP();
                    if (gw){
                        sself.blank.deviceIPGatewayAsIPCam = [NSString stringWithUTF8String:gw];
                    }
                    else{
                        [sself.blank askToConnectDeviceToCamWiFiIfNeed];
                        usleep(USEC_PER_SEC * 0.2);
                    }
                }
                rc = 5;
                do {
                    res = [sself.blank initializeCameraDevice];
                    if (!res){
                        //
                        // when cam connected via Eth to router
                        // +iDevice connected to cam via Wi-Fi
                        // init failed sometimes forever, restart search fix init fails
                        [sself restartSearch];
                        usleep(USEC_PER_SEC * 1);
                    }
                } while (sself.run && !res && --rc);
            }
        }
        else{
            res = NO;
            WiFiLog(@"%s[%d] cam mac address not detected...", __FUNCTION__, __LINE__);
        }
        if (res){
            [TDahuaCamConnection.instance stopSearchDevices:NO];
            [sself stageCamWiFiLogin];
        }
        else if (retryCount > 0){
            [sself stageCamDeviceInitializationInternal:retryCount-1];
        }
        else{
            sself.retryError = LSTR(@"onvif-wifi-cam-init-err");
        }
    }];
}

#pragma mark 3. cam wifi login
- (void)stageCamWiFiLogin{
    if (!self.run){
        return;
    }
    self.stage = TDahuaWiFiStageCamWiFiLogin;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        // loginToCamera already with retries
        int error = [sself.blank loginToCamera:20];
        if (TDahuBlankNoError == error){
            // TODO: firmware update ON ?
#if TADD_CAM_FW_UPDATE_ON
            [sself stageCheckFirmware];
#else
            [sself stageCamWiFiNTPConfig];
#endif 
        }
        else if (error == DAHUA_ERR_UNMASK(TDahuBlankNotInitialized)){
            [sself stageCamDeviceInitializationInternal:3];
        }
        else{
            WiFiLog(@"%s[%d] code:%d ssid:%@ and pass:%@", __FUNCTION__, __LINE__, error, sself.blank.wifiSSID, sself.blank.wifiSecurityKey);
            sself.retryError = LSTR(@"onvif-wifi-cam-join-err");
        }
    }];
}

#pragma mark 4. config ntp
- (void)stageCamWiFiNTPConfig{
    if (!self.run){
        return;
    }
    self.stage = TDahuaWiFiStageCamWiFiNTP;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        BOOL res;
        NSInteger rc = TD_RETRY;
        do {
            res = [sself.blank configNTPToTimeZone:NSTimeZone.localTimeZone];
            if (!res){
                usleep(USEC_PER_SEC * 0.5);
            }
        } while (sself.run && !res && --rc > 0);
        /*
         // don't enable by default
        if (res){
            rc = 10;
            do {
                res = [sself.blank configHumanDetect];
                if (!res){
                    usleep(USEC_PER_SEC * 0.5);
                }
            } while (sself.run && !res && --rc > 0);
            if (res){
                rc = 10;
                do {
                    res = [sself.blank configMotionDetect];
                    if (!res){
                        usleep(USEC_PER_SEC * 0.5);
                    }
                } while (sself.run && !res && --rc > 0);
                if (res){
                    rc = 10;
                    do {
                        res = [sself.blank configAudioDetect];
                        if (!res){
                            usleep(USEC_PER_SEC * 0.5);
                        }
                    } while (sself.run && !res && --rc > 0);
                }
            }
        }
        */
        if (res){
            [sself stageCamWiFiToAccessPoint];
        }
        else{
            WiFiLog(@"%s[%d] code:%d ssid:%@ and pass:%@", __FUNCTION__, __LINE__, res, sself.blank.wifiSSID, sself.blank.wifiSecurityKey);
            sself.retryError = LSTR(@"onvif-wifi-cam-ntp-err");
        }
    }];
}

#pragma mark 5. change cam wifi.type
- (void)stageCamWiFiToAccessPoint{
    if (!self.run){
        return;
    }
    self.stage = TDahuaWiFiStageCamWiFiToAccessPoint;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        
        BOOL res;
        NSInteger rc = TD_RETRY;
        do {
            res = [sself.blank WlanConfig];
            // ---
            // camera config may return false, but already configured wifi to router
            // check if the device is connected to the router to which the camera should be connected
            NSString *camSSID = sself.blank.camWifiSSID;
            NSString *deviceSSID = NetAddr.localWiFiSSID;
            NSString *routerSSID = sself.blank.wifiSSID;
            if (!res && camSSID && deviceSSID && routerSSID &&
                ![deviceSSID isEqualToString:camSSID] &&
                [deviceSSID isEqualToString:routerSSID]){
                res = [sself searchCamInLocalNet];
                if (res){
                    sself.blank.wifiConfigured = YES;
                    WiFiLog(@"cam wifi config maybe failed, device connected to router go to begin...");
                }
            }
            //---
            WiFiLog(@"cam wifi config result:%d", res);
            if (!res){
                [sself restartSearch];
                usleep(USEC_PER_SEC * 0.5);
            }
        } while (sself.run && !res && --rc > 0);
        
        if (res){
            [TDahuaCamConnection.instance stopSearchDevices:NO];
            [sself stageDeviceConnectToUserWiFi:^(){
                __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                [sself stageMonitorCamInLocalNetwork];
            }];
        }
        else{
            WiFiLog(@"%s[%d] code:%d ssid:%@ and pass:%@", __FUNCTION__, __LINE__, res, sself.blank.wifiSSID, sself.blank.wifiSecurityKey);
            sself.retryError = LSTR(@"onvif-wifi-cam-join-err");
        }
    }];
}

#pragma mark 6. connect device to user wifi
- (void)stageDeviceConnectToUserWiFi:(dispatch_block_t)cb{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    self.stage = TDahuaWiFiStageDeviceConnectsToUserWiFi;
    __weak TAddCamWiFiRouterViewController *wself = self;
    wifiBlock = cb;
    [self.wifiUserOperations cancelAllOperations];
    [self.wifiUserOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        usleep(WAIT_AFTER_WIFI_CHANGE_TIME_USEC);
        if (![NetAddr.localWiFiSSID isEqualToString:sself.blank.wifiSSID]){
            [sself stageDeviceConnectToUserWiFiInternal:cb];
        }
        else if (cb){
            cb();
        }
    }];
}

- (void)stageDeviceConnectToUserWiFiInternal:(dispatch_block_t)cb{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self connectToWiFiWithSSID:self.blank.wifiSSID
                       password:self.blank.wifiSecurityKey
                      isCamSSID:NO
                     retryCount:TD_RETRY
                             cb:^(NSString *error, BOOL rfail) {
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        if (error){
            WiFiLog(@"%s[%d] failed, settings prompt will begin err:'%@'", __FUNCTION__, __LINE__, error);
            if (rfail){
                sself.retryError = error;
            }
            else{
                [sself wiFiSettingsPromt:sself.blank.camWifiSSID
                               isCamSSID:YES
                                    okcb:^(){
                    [sself stageDeviceConnectToUserWiFi:cb];
                }];
            }
        }
        else if (cb){
            [TDahuaCamConnection.instance startSearchDevices];
            [sself.wifiSysOperations addOperationWithBlock:cb];
        }
    }];
}

#pragma mark 7. UPnP monitor
- (void)stageMonitorCamInLocalNetwork{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    self.stage = TDahuaWiFiStageFindCamInNetwork;
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations cancelAllOperations];
    [self.wifiSysOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        [TDahuaCamConnection.instance startSearchDevices];
        NSInteger rc = 30;
        while (sself.run && sself.blank.wifiDelegate && --rc) {
            usleep(USEC_PER_SEC);
        }
        [TDahuaCamConnection.instance stopSearchDevices:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
            if (sself.blank.wifiDelegate){
                WiFiLog(@"%s[%d] cam not found in local network, add it to cloud anyway...", __FUNCTION__, __LINE__);
                [sself TDahuaCamConnectionCamFound:nil];
            }
        });
    }];
}

- (void)TDahuaCamConnectionCamFound:(NSNotification*)note{
    TDahuaCamBlank *b = note.object;
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    if (self.run && (!note || (b.serial && [self.blank.serial isEqualToString:b.serial]))){
        if (b){
            self.blank.macAddress = b.macAddress;
            self.blank.localIP = b.localIP;
            self.blank.localIPSubNetMask = b.localIPSubNetMask;
            self.blank.localIPGateway = b.localIPGateway;
            self.blank.macAddress = b.macAddress;
            self.blank.initSupported = b.initSupported;
            self.blank.initCompleted = b.initCompleted;
            self.blank.byPwdResetWay = b.byPwdResetWay;
        }
        if (self.blank.wifiDelegate && self.blank.wifiConfigured){
            self.blank.wifiDelegate = nil;
            [NSNotificationCenter.defaultCenter removeObserver:self name:TDahuaCamConnectionCamFoundNotification object:nil];
            [self TDahuaCamConnectionCamFoundInternal];
        }
    }
}

- (void)TDahuaCamConnectionCamFoundInternal{
    WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
    [self.wifiUserOperations cancelAllOperations];
    [self.wifiSysOperations cancelAllOperations];
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiSysOperations addOperationWithBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
            sself.wifiUserOperations = nil;
            sself.wifiSysOperations = nil;
            [sself pushCloudController];
        });
    }];
}

#pragma mark- wifi prompt
- (void)wiFiSettingsPromt:(NSString*)ssid isCamSSID:(BOOL)isCamSSID okcb:(dispatch_block_t)okcb{
    if (!self.run){
        return;
    }
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self goToWiFiSettingsPromptWithSSID:ssid
                               isCamSSID:isCamSSID
                                 message:LSTR(@"wifi-go-to-settings-prompt")
                                      cb:^(BOOL flag) {
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        if (!flag){
            if (sself.onScreen){
                [sself.navigationController popViewControllerAnimated:YES];
            }
            WiFiLog(@"onvif wifi prompt cancelled");
        }
        else{
            WiFiLog(@"begin wifi monitoring for ssid %@", ssid);
            [sself beginMonitoringWiFiSSID:ssid cb:^(BOOL flag) {
                __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                if (flag){
                    if (okcb)
                        okcb();
                }
                else{
                    WiFiLog(@"wifi monitoring: device not connected to cam with ssid '%@', current ssid is '%@'", ssid, [NetAddr localWiFiSSID]);
                    [sself wiFiSettingsPromt:ssid isCamSSID:isCamSSID okcb:okcb];
                }
            }];
        }
    }];
}

- (void)goToWiFiSettingsPromptWithSSID:(NSString*)ssid
                             isCamSSID:(BOOL)isCamSSID
                               message:(NSString*)message
                                    cb:(void (^ __nullable)(BOOL flag))cb{
    if (!self.run){
        return;
    }
    WiFiLog(@"%s[%d] ssid:%@", __FUNCTION__, __LINE__, ssid);
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiUserOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        NSString *pswd = isCamSSID ? sself.blank.camWifiSecurityKey : nil;
        NSString *msg = [NSString stringWithFormat:message, ssid];
        // append message with password to clipboard
        if (pswd){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = pswd;
            msg = [msg stringByAppendingFormat:@". %@", [NSString stringWithFormat:LSTR(@"password-in-pasteboard-format"), pswd]];
        }
        UIAlertController *ac =
        [UIAlertController alertControllerWithTitle:LSTR(@"infomsg")
                                            message:msg
                                     preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:LSTR(@"open-wifi-settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                if (cb){
                    cb(YES);
                }
                __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                [sself openWiFiSettingsAction:nil];
            }]];
        [ac addAction:[UIAlertAction actionWithTitle:LSTR(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cb){
                cb(NO);
            }
        }]];
        if (sself.run && sself.onScreen){
            [sself presentViewController:ac animated:YES completion:nil];
        }
    }];
}

#pragma mark- wifi connect
- (void)connectToWiFiWithSSID:(NSString*)ssid
                     password:(NSString*)pass
                    isCamSSID:(BOOL)isCamSSID
                   retryCount:(NSInteger)retryCount
                           cb:(void (^ __nullable)(NSString *error, BOOL rfail))cb
{
    if (!self.run){
        return;
    }
#if !TARGET_IPHONE_SIMULATOR
    __weak TAddCamWiFiRouterViewController *wself = self;
    [self.wifiUserOperations cancelAllOperations];
    [self.wifiUserOperations addOperationWithBlock:^{
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        if (!sself.run){
            return;
        }
        NEHotspotConfiguration *config = [[NEHotspotConfiguration alloc] initWithSSID:ssid passphrase:pass isWEP:NO];
        //NEHotspotConfiguration *config = [[NEHotspotConfiguration alloc] initWithSSIDPrefix:@"Camera" passphrase:pass isWEP:NO];
        
        if (isCamSSID){
            // cam.wifi disconnect while we wait request response try joinOnce = NO...
            config.joinOnce = NO;
            config.lifeTimeInDays = @3;
        }
        else{
            config.joinOnce = NO;
        }
        
        WiFiLog(@"%s[%d] wifi manager will apply config with ssid '%@' and pass '%@'", __FUNCTION__, __LINE__, ssid, pass);
        [NEHotspotConfigurationManager.sharedManager applyConfiguration:config
                                                      completionHandler:^(NSError * _Nullable error)
         {
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
            // error may be nil iOS 13 & CNCopyCurrentNetworkInfo
            NSString *localSSID = [NetAddr localWiFiSSID];
            NSString *dssid = localSSID;
            BOOL needRetry;
            if (error){
                 switch (error.code) {
                     case NEHotspotConfigurationErrorInvalidSSID:
                     case NEHotspotConfigurationErrorInvalidWPAPassphrase:
                     case NEHotspotConfigurationErrorInvalidWEPPassphrase:
                     case NEHotspotConfigurationErrorInvalidEAPSettings:
                     case NEHotspotConfigurationErrorInvalidHS20Settings:
                     case NEHotspotConfigurationErrorInvalidHS20DomainName:
                     case NEHotspotConfigurationErrorUserDenied:
                         needRetry = NO;
                         break;
                     case NEHotspotConfigurationErrorAlreadyAssociated:
                         localSSID = ssid;
                         needRetry = NO;
                         break;
                     default:
                         needRetry=YES;
                         break;
                 }
            }
            else{
                needRetry = NO;
                if (!localSSID){
                    localSSID = ssid;
                }
            }
            
            if (!sself.run){
                return;
            }
             
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (dssid && [localSSID isEqualToString:ssid]){
                    WiFiLog(@"%s[%d] wifi connected to ssid:%@", __FUNCTION__, __LINE__, dssid);
                    cb(nil, NO);
                }
                else if (needRetry && retryCount){
                    WiFiLog(@"%s[%d] check wifi config and ssid failed. will retry ssid:%@ and pass:%@ netssid:%@ code:%@", __FUNCTION__, __LINE__, ssid, pass, localSSID, @(error.code));
                    [sself connectToWiFiWithSSID:ssid password:pass isCamSSID:isCamSSID retryCount:retryCount-1 cb:cb];
                }
                else{
                    WiFiLog(@"%s[%d] error:%@ ssid:%@ and pass:%@", __FUNCTION__, __LINE__, error, ssid, pass);
                    NSMutableString *serr = [NSMutableString stringWithString:LSTR(@"onvif-wifi-cam-err")];
                    if (error){
                        [serr appendFormat:@" '%@' code:%@", error.localizedDescription, @(error.code)];
                    }
                    cb(serr, YES);
                }
            });
         }];
    }];
#endif
}

- (void)openWiFiSettingsAction:(id)sender{
    if (!self.run){
        return;
    }
    UIApplication *app = UIApplication.sharedApplication;
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([app canOpenURL:url]){
        [app openURL:url options:@{} completionHandler:^(BOOL success) {
                    
        }];
    }
}

#pragma mark- wifi monitor
- (void)beginMonitoringWiFiSSID:(NSString*)ssid cb:(void (^ __nullable)(BOOL flag))cb{
    [self stopMonitorWiFi];
    if (!self.run || !cb || !ssid){
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                cb, TD_MONITOR_CALLBACK,
                                ssid, TD_MONITOR_SSID,
                                @(TD_RETRY), TD_MONITOR_REPEAT_COUNT, nil];
    self.wifiMonitorTimer =
    [NSTimer timerWithTimeInterval:TD_RETRY_DELAY_SEC target:self selector:@selector(monitorTick:) userInfo:dic repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.wifiMonitorTimer forMode:NSRunLoopCommonModes];
}

- (void)monitorTick:(NSTimer*)timer{
    if (!timer.isValid){
        return;
    }
    NSMutableDictionary *userInfo = timer.userInfo;
    void (^handler)(BOOL flag) = [userInfo objectForKey:TD_MONITOR_CALLBACK];
    NSString *ssid = [userInfo objectForKey:TD_MONITOR_SSID];
    NSInteger rc = [[userInfo objectForKey:TD_MONITOR_REPEAT_COUNT] integerValue];
    if ([NetAddr localWiFiSSIDIsEqualToSSID:ssid]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (handler)
                handler(YES);
        });
        [self stopMonitorWiFi];
    }
    else if (!--rc){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (handler)
                handler(NO);
        });
        [self stopMonitorWiFi];
    }
    [userInfo setObject:@(rc) forKey:TD_MONITOR_REPEAT_COUNT];
}

- (void)stopMonitorWiFi{
    TimerInvalidateNil(self.wifiMonitorTimer);
}

#pragma mark- stage details
- (void)setStage:(TDahuaWiFiStage)stage{
    _stage = stage;
    NSString *k;
    switch (stage) {
        case TDahuaWiFiStageFetchFirmwareInfo:{k = @"wifi-stage-fetch-fw-info";}break;
        case TDahuaWiFiStageFetchFirmwareData:{k = @"wifi-stage-fetch-fw-data";}break;
        case TDahuaWiFiStageCamWiFiCheckFirmware:{k = @"wifi-stage-get-cam-fw-version";}break;
        case TDahuaWiFiStageCamWiFiInstallFirmware:{k = @"wifi-stage-install-fw-transfer";}break;
        case TDahuaWiFiStageDeviceConnectsToCamWiFIAfterFWUpdateReboot:{k = @"wifi-stage-conn-to-cam-wifi";}break;
        case TDahuaWiFiStageBegin:{k = @"wifi-stage-find-cam-in-net";}break;
        case TDahuaWiFiStageCamDeviceInitialization:{k = @"wifi-stage-cam-init";}break;
        case TDahuaWiFiStageDeviceConnectsToCamWiFI:{k = @"wifi-stage-conn-to-cam-wifi";}break;
        case TDahuaWiFiStageCamWiFiLogin:{k = @"wifi-stage-cam-auth";}break;
        case TDahuaWiFiStageCamWiFiNTP:{k = @"wifi-stage-configure-ntp";}break;
        case TDahuaWiFiStageCamWiFiToAccessPoint:{k = @"wifi-stage-cam-wifi-to-ap";}break;
        case TDahuaWiFiStageDeviceConnectsToUserWiFi:{k = @"wifi-stage-conn-device-to-router";}break;
        case TDahuaWiFiStageFindCamInNetwork:{k = @"wifi-stage-find-cam-in-net";}break;
        case TDahuaWiFiStageDeviceSoundToCamMicrophone:{k = @"wifi-stage-sound-to-cam";}break;
        default:{k = @"";}break;
    }
    NSString *stageStr = LSTR(k);
    __weak TAddCamWiFiRouterViewController *wself = self;
    dispatch_block_t block = ^(){
        __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
        sself.stageLabel.text = stageStr;
    };
    DISPATCH_BLOCK_MAIN_ASYNC_IF_NEEDED(block);
}

- (TDahuaWiFiStage)stage{
    return _stage;
}

#pragma mark- dahua config via sound kuku
- (IBAction)soundTap:(id)sender{
    self.stage = TDahuaWiFiStageDeviceSoundToCamMicrophone;
    [self.audioConfig createAudioFileAsync];
}

- (void)TDahuaAudioConfigComplete:(TDahuaAudioConfig*)config error:(NSError*)error{
    if (config.file){
        @try{
            MPVolumeView *volview = [MPVolumeView new];
            UISlider *volslider = nil;
            for (UIView *view in volview.subviews){
                if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                    volslider = (UISlider*)view;
                    break;
                }
            }
            [volslider setValue:1.0f animated:YES];
            [volslider sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        @catch(NSException*e){
            LOG_EX(e);
        }
        NSError *err;
        NSURL *url = [[NSURL alloc] initFileURLWithPath:config.file];
        [self.audioPlayer stop];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
        if (!self.audioPlayer){
            __weak TAddCamWiFiRouterViewController *wself = self;
            [IPDHelper showError:err withCancel:^{
                __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                [sself.navigationController popViewControllerAnimated:YES];
            } andRetry:^{
                __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
                [sself soundTap:nil];
            }];
            return;
        }
        self.audioPlayer.numberOfLoops = 45;
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
    }
    else if (error){
        __weak TAddCamWiFiRouterViewController *wself = self;
        [IPDHelper showError:error withCancel:^{
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
            [sself.navigationController popViewControllerAnimated:YES];
        } andRetry:^{
            __strong TAddCamWiFiRouterViewController *sself = wself;if (!sself) return;
            [sself soundTap:nil];
        }];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    
}

#pragma mark-
- (TAddCamRightButtonType)barRightButtonType{
    return TAddCamRightButtonTriDot;
}

- (TAddCamRightMenuMask)barRightButtonMenuMask{
    return TAddCamRightMenuToBegin | TAddCamRightMenuWiFiToEth;
}

@end
