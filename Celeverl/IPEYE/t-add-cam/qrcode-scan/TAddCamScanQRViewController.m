//
//  TAddCamScanQRViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 18.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamScanQRViewController.h"
#import "TAddCamSerialEnterViewController.h"
#import "TAddCamPreviewViewController.h"
#import "TAddCamResetViewController.h"
//#import "ServerConnection.h"

#define TSCAN_TORCH_AUTO 0

static void *TAddCamScanQRViewControllerTorchModeCtx = &TAddCamScanQRViewControllerTorchModeCtx;
static void *TAddCamScanQRViewControllerHasTorchCtx = &TAddCamScanQRViewControllerHasTorchCtx;

@interface TAddCamScanQRViewController () <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, TAddCamSerialEnterViewControllerDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *metaOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

#if TSCAN_TORCH_AUTO
@property (nonatomic, strong) AVCaptureVideoDataOutput *dataOutput;
@property (nonatomic, assign) Float32 lastBrightness;
#endif

@property (nonatomic, assign) BOOL isTourchOn;
@property (nonatomic, strong) dispatch_semaphore_t sema;
@property (nonatomic, assign) NSTimeInterval touchChangeTime;

@property (nonatomic, strong) NSURLSessionDataTask *validateTask;

@property (nonatomic, weak) IBOutlet UIView *scannerView;
@property (nonatomic, weak) IBOutlet UIImageView *scannerQRImageView;
@property (nonatomic, weak) IBOutlet UILabel *scannerLabel;
@property (nonatomic, weak) IBOutlet UIButton *manualEnterButton;
@property (nonatomic, weak) IBOutlet UIButton *flashButton;

@end

@implementation TAddCamScanQRViewController

#pragma mark- base
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sema = dispatch_semaphore_create(1);
    self.scannerLabel.text = LSTR(@"add-cam-qr-title");
    [self.manualEnterButton setTitle:LSTR(@"add-cam-serial-manually") forState:UIControlStateNormal];
    [self.manualEnterButton tricolorBlue];
    
    if (@available(iOS 13, *)){
        [self.flashButton setImage:[UIImage systemImageNamed:@"lightbulb.slash"] forState:UIControlStateNormal];
        [self.flashButton setImage:[UIImage systemImageNamed:@"lightbulb.fill"] forState:UIControlStateSelected];
    }
    else{
        [self.flashButton setImage:[UIImage imageNamed:@"cam-flash"] forState:UIControlStateNormal];
        [self.flashButton setImage:[[UIImage imageNamed:@"cam-flash"] fillSourceAtopWithColor:UIColor.mainYellow] forState:UIControlStateNormal];
    }
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(grantsChanged:) name:OSAuthGrantsChangedNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appDidActivate:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//#if DEBUG
//    [self.blank fillParamsWithQRCode:[TDahuaCamBlank parseQR:@"{SN:5G043D4PAJ361D8,DT:IPC-G22P,SC:L2A262CB,NC:015}"]];
//    [self pushNextStep];
//    return;
//#endif
    [self trySetupScanner];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == TAddCamScanQRViewControllerTorchModeCtx){
        __weak typeof(self) wself = self;
        DISPATCH_BLOCK_MAIN_ASYNC_IF_NEEDED(^(){
            __strong typeof(wself) sself = wself;if (!sself) return;
            sself.flashButton.selected = sself.captureDevice.torchMode != AVCaptureTorchModeOff;
        });
    }
    else if (context == TAddCamScanQRViewControllerHasTorchCtx){
        __weak typeof(self) wself = self;
        DISPATCH_BLOCK_MAIN_ASYNC_IF_NEEDED(^(){
            __strong typeof(wself) sself = wself;if (!sself) return;
            sself.flashButton.enabled = self.captureDevice.hasTorch;
        });
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopScanning];
}

- (void)grantsChanged:(NSNotification*)note{
    [self trySetupScanner];
}

- (void)appDidActivate:(NSNotification*)note{
    [self trySetupScanner];
}

- (void)appWillResignActive:(NSNotification*)note{
    [self stopScanning];
}

- (void)dealloc{
    [_captureDevice safeRemoveObserver:self forKeyPath:@"torchMode"];
    [_captureDevice safeRemoveObserver:self forKeyPath:@"hasTorch"];
}

#pragma mark-
- (IBAction)flashTap:(id)sender{
    self.isTourchOn = !self.flashButton.selected;
}

- (void)stopScanning{
    [self.captureSession stopRunning];
    self.touchChangeTime = 0;
    self.isTourchOn = NO;
}

- (void)setIsTourchOn:(BOOL)isTourchOn{
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
#if TSCAN_TORCH_AUTO
    if (time(NULL) - self.touchChangeTime > 1){
        if (self.captureDevice.hasTorch){
            NSError *error;
            if ([self.captureDevice lockForConfiguration:&error]){
                self.touchChangeTime = time(NULL);
                [self.captureDevice setTorchMode:isTourchOn?AVCaptureTorchModeOn:AVCaptureTorchModeOff];
                if (isTourchOn){
                    [self.captureDevice setTorchModeOnWithLevel:0.1f error:&error];
                }
                [self.captureDevice unlockForConfiguration];
            }
        }
    }
#else
    NSError *error;
    if ([self.captureDevice hasTorch] && [self.captureDevice lockForConfiguration:&error]){
        [self.captureDevice setTorchMode:isTourchOn?AVCaptureTorchModeOn:AVCaptureTorchModeOff];
        if (isTourchOn){
            [self.captureDevice setTorchModeOnWithLevel:0.1f error:&error];
        }
        [self.captureDevice unlockForConfiguration];
    }
#endif
    dispatch_semaphore_signal(self.sema);
}

- (BOOL)isTourchOn{
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    BOOL res = self.captureDevice.hasTorch && self.captureDevice.torchMode != AVCaptureTorchModeOff;
    dispatch_semaphore_signal(self.sema);
    return res;
}

- (void)setCaptureDevice:(AVCaptureDevice *)captureDevice{
    if (_captureDevice != captureDevice){
        [_captureDevice safeRemoveObserver:self forKeyPath:@"torchMode"];
        [_captureDevice safeRemoveObserver:self forKeyPath:@"hasTorch"];
        _captureDevice = captureDevice;
        [captureDevice addObserver:self forKeyPath:@"torchMode" options:KVO_NEW_OLD_INITIAL context:TAddCamScanQRViewControllerTorchModeCtx];
        [captureDevice addObserver:self forKeyPath:@"hasTorch" options:KVO_NEW_OLD_INITIAL context:TAddCamScanQRViewControllerHasTorchCtx];
    }
}

- (void)trySetupScanner{
    if (!self.onScreen){
        return;
    }
    NSError *error;
    if ([OSAuthGranter.granter isCamEnabledForApp:YES] && !self.captureSession){
        self.captureSession = AVCaptureSession.new;
        //AVMediaTypeMetadata
        self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
        if (!self.captureDeviceInput){
            [IPDHelper showErrorString:error.localizedDescription];
            self.captureSession = nil;
            self.captureDevice = nil;
            return;
        }
        if ([self.captureSession canAddInput:self.captureDeviceInput]){
            [self.captureSession addInput:self.captureDeviceInput];
        }

        self.metaOutput = AVCaptureMetadataOutput.new;
        
        if ([self.captureSession canAddOutput:self.metaOutput]){
            [self.captureSession addOutput:self.metaOutput];
            self.metaOutput.metadataObjectTypes = self.metaOutput.availableMetadataObjectTypes;
            [self.metaOutput setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        }
#if TSCAN_TORCH_AUTO
        self.dataOutput = AVCaptureVideoDataOutput.new;
        [self.dataOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        if ([self.captureSession canAddOutput:self.dataOutput]){
            [self.captureSession addOutput:self.dataOutput];
        }
#endif
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        self.previewLayer.frame = self.scannerView.bounds;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.scannerView.layer addSublayer:self.previewLayer];
    }
    if ([self.captureDevice lockForConfiguration:&error])
    {
        if ([self.captureDevice isLowLightBoostSupported]){
            self.captureDevice.automaticallyEnablesLowLightBoostWhenAvailable = YES;
        }
        if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
            [self.captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        AVCaptureDeviceFormat *fmt = self.captureDevice.activeFormat;
        // 1.93 for 6s by default
        float zf = fmt.videoZoomFactorUpscaleThreshold;
        self.captureDevice.videoZoomFactor = MIN(fmt.videoMaxZoomFactor, MAX(zf, 4));
        [self.captureDevice unlockForConfiguration];
    }
    [self.captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
#if TSCAN_TORCH_AUTO
    CFDictionaryRef metadic = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CFDictionaryRef exifdic = CFDictionaryGetValue(metadic, kCGImagePropertyExifDictionary);
    CFNumberRef brightness = CFDictionaryGetValue(exifdic, kCGImagePropertyExifBrightnessValue);
    Float32 res = 0;
    CFNumberGetValue(brightness, kCFNumberFloat32Type, &res);
    CFRelease(metadic);
    self.lastBrightness = res;
    self.isTourchOn = res < 5.0;
#endif
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    __block AVMetadataMachineReadableCodeObject *qr = nil;
    [metadataObjects enumerateObjectsUsingBlock:^(__kindof AVMetadataObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:AVMetadataMachineReadableCodeObject.class]){
            qr = obj;
            *stop = YES;
        }
    }];
    // to show rect, but we validate qr.code.data and go next right now and not needed to show meta rect on layer over qr.code
    // AVMetadataObject *metaobj = [self.previewLayer transformedMetadataObjectForMetadataObject:qr];
    NSString *qrval = qr.stringValue;
    if (qrval){
        NSDictionary *qrdic = [TDahuaCamBlank parseQR:qrval];
        if ([self.blank fillParamsWithQRCode:qrdic]){
            metrica_report_event(@"AddCam.ScanQR");
            WiFiLog(@"QR-scanned: %@", qrdic);
            [self stopScanning];
            __weak typeof(self) wself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(wself) sself = wself;if (!sself) return;
                [sself pushNextStep];
            });
        }
    }
}

- (void)pushNextStep{
    [self stopScanning];
    if (self.validateTask || !self.blank.serial || !self.blank.safetyCode){
        return;
    }
    __weak typeof(self) wself = self;
    // TODO: валидация камеры по параметрам
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://API_DOMAIN/check_cam"]];
    req.HTTPMethod = @"POST";
    req.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"serial":self.blank.serial,
                                                             @"skey":self.blank.safetyCode}
                                                   options:0
                                                     error:NULL];
    //NSMutableURLRequest *req = [ServerConnection apiPostRequestWithApiKey:@"check_cam" query:@{@"serial":@"5M000A7PAJ2118A"}];
    // when user connected to cam wifi, that not have internet connection, timeout with 60 sec is too long time to wait
    req.timeoutInterval = 10;
    self.validateTask =
    [NSURLSession.sharedSession dataTaskWithRequest:req
                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(wself) sself = wself;if (!sself) return;
        sself.validateTask = nil;
        if (error.code == NSURLErrorCancelled){
            return;
        }
        [IPDHelper handleJSONReponseData:data response:response error:error successcb:^(id  _Nonnull json) {
            __strong typeof(wself) sself = wself;if (!sself) return;
            NSInteger code = [json[@"code"] integerValue];
            switch (code) {
                case 200:{
                    sself.blank.model = json[@"model"];
                    sself.blank.modelHasEthernetPort = [json[@"modelHasEthernetPort"] boolValue];
                    [sself pushAddCtrl];
                }break;
                case 201:{
                    UIAlertController *vc = [UIAlertController alertControllerWithTitle:json[@"message"] message:LSTR(@"cam-change-wifi-connection-about") preferredStyle:UIAlertControllerStyleAlert];
                    [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"continue") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        __strong typeof(wself) sself = wself;if (!sself) return;
                        sself.blank.model = json[@"model"];
                        sself.blank.modelHasEthernetPort = [json[@"modelHasEthernetPort"] boolValue];
                        [sself pushAddCtrl];
                    }]];
                    [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"reset") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        __strong typeof(wself) sself = wself;if (!sself) return;
                        [sself pushResetCtrl];
                    }]];
                    [[UIViewController topMostController] presentViewController:vc animated:YES completion:nil];
                }break;
                default:{
                    [IPDHelper showAlert:json[@"message"] withCancelAndRetry:^{
                       __strong typeof(wself) sself = wself;if (!sself) return;
                        [sself pushNextStep];
                    }];
                }break;
            }
        } errorcb:^(NSError * _Nonnull e) {
            [IPDHelper showErrorWithRetry:e retry:^{
                __strong typeof(wself) sself = wself;if (!sself) return;
                [sself pushNextStep];
            }];
        }];
    }];
    [self.validateTask resume];
}

- (void)pushResetCtrl{
    UIViewController *vc = UIViewController.topMostController;
    if (vc == self || vc == self.splitViewController){
        TAddCamResetViewController *vc = (id)[TAddCamResetViewController initWithMainBundle];
        vc.blank = self.blank;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pushAddCtrl{
    UIViewController *vc = UIViewController.topMostController;
    if (vc == self || vc == self.splitViewController){
        TAddCamPreviewViewController *vc = (id)[TAddCamPreviewViewController initWithMainBundle];
        vc.blank = self.blank;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- munual enter
- (IBAction)manualEnterTap:(id)sender{
    metrica_report_event(@"AddCam.ScanQR.Manual");
    TAddCamSerialEnterViewController *vc = (id)[TAddCamSerialEnterViewController initWithMainBundle];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)serialNumberDidEnter:(TAddCamSerialEnterViewController*)vc number:(NSString*)number securityKey:(NSString*)securityKey{
    self.blank.serial = number;
    self.blank.safetyCode = securityKey;
    self.blank.camWifiSecurityKey = securityKey;
    [self.navigationController popViewControllerAnimated:NO];
    [self pushNextStep];
}

@end
