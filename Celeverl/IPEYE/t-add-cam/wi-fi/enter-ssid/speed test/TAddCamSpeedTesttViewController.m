//
//  TAddCamSpeedTesttViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 19.12.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamSpeedTesttViewController.h"

const NSInteger TEST_RETRY = 10;

@interface TAddCamSpeedTesttViewController () <OSServerDataRateDelegate, SimplePingDelegate>
@property (nonatomic, weak) IBOutlet UILabel *pingLabel;
@property (nonatomic, weak) IBOutlet UILabel *pingValueLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *pingActivity;
@property (nonatomic, weak) IBOutlet UILabel *uploadLabel;
@property (nonatomic, weak) IBOutlet UILabel *uploadValueLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *uploadActivity;
@property (nonatomic, weak) IBOutlet UILabel *downloadLabel;
@property (nonatomic, weak) IBOutlet UILabel *downloadValueLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *downloadActivity;
@property (nonatomic, weak) IBOutlet UIButton *startButton;

@property (nonatomic, strong) NSDate *pingStartDate;
@property (nonatomic, strong) NSDate *pingPacketSendDate;
@property (nonatomic, strong) SimplePing *simplePing;
@property (nonatomic, strong) NSTimer *pingStopTimer;

@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSMutableSet *pingValuesSet;
@property (nonatomic, strong) NSMutableArray *uploadValues;
@property (nonatomic, strong) NSMutableArray *downloadValues;
@property (nonatomic, assign) int uploadRetryCount;
@property (nonatomic, assign) int downloadRetryCount;
@property (nonatomic, strong) OSServerDataRateController *rateController;
@end

@implementation TAddCamSpeedTesttViewController

#pragma mark- base
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LSTR(@"speed-test");
    self.pingLabel.text = LSTR(@"speed-test-ping");
    self.uploadLabel.text = LSTR(@"speed-test-upload");
    self.downloadLabel.text = LSTR(@"speed-test-download");
    [self.startButton setTitle:LSTR(@"wifi-speed-test") forState:UIControlStateNormal];
    [self.startButton setTitle:LSTR(@"please-wait") forState:UIControlStateDisabled];
    self.rateController = [OSServerDataRateController new];
    [self resetValues];
}

- (void)dealloc{
    [self.simplePing stop];
    self.simplePing.delegate = nil;
    OSServerCancelTask(self.uploadTask);
    OSServerCancelTask(self.downloadTask);
}

- (void)resetValues{
    self.pingValueLabel.text = @"-";
    self.uploadValueLabel.text = @"-";
    self.downloadValueLabel.text = @"-";
    [UIColor tabBarItemSelectedTextColor];
    UIColor *c = [UIColor tricolorBlackTextColor];
    self.pingValueLabel.textColor = c;
    self.uploadValueLabel.textColor = c;
    self.downloadValueLabel.textColor = c;
}

- (IBAction)startTap:(id)sender{
    self.uploadValues = [NSMutableArray new];
    self.downloadValues = [NSMutableArray new];
    self.uploadRetryCount = 0;
    self.downloadRetryCount = 0;
    [self resetValues];
    if (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]){
        [IPDHelper showErrorString:LSTR(@"no-internet-msg")];
    }
    else{
        [self stage_1_StartPing];
        self.startButton.enabled = NO;
    }
}

- (void)handleStageError:(NSError*)error{
    self.startButton.enabled = YES;
    if (error.code != NSURLErrorCancelled && self.onScreen){
        __weak typeof(self) wself = self;
        [IPDHelper showErrorWithRetry:error retry:^{
            __strong typeof(wself) sself = wself;if (!sself) return;
            [sself startTap:nil];
        }];
    }
}

#pragma mark- 1.ping
- (void)stage_1_StartPing{
    [self.simplePing stop];
    // TODO: пингуйте свой домен ServiceAPIURLString @"https://api.ipeye.ru" ?
    self.simplePing = [[SimplePing alloc] initWithHostName:[NSURL URLWithString:@"https://api.ipeye.ru"].host];
    self.simplePing.delegate = self;
    self.pingValuesSet = [NSMutableSet new];
    self.pingStartDate = [NSDate date];
    
    TimerInvalidateNil(self.pingStopTimer);
    __weak typeof(self) wself = self;
    self.pingStopTimer = [NSTimer timerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        __strong typeof(wself) sself = wself;if (!sself) return;
        [sself stage_1_FinishPing:nil];
    }];
    [NSRunLoop.currentRunLoop addTimer:self.pingStopTimer forMode:NSRunLoopCommonModes];
    [self.simplePing start];
}

- (void)stage_1_FinishPing:(NSError*)error{
    TimerInvalidateNil(self.pingStopTimer);
    [self.simplePing stop];
    self.simplePing = nil;
    self.pingStartDate = nil;
    self.pingPacketSendDate = nil;
    self.pingValuesSet = nil;
    if (!error){
        [self stage_2_StartUpload];
    }
    else{
        self.pingValueLabel.textColor = UIColor.menuRedTitle;
        [self handleStageError:error];
    }
}

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address{
    [pinger sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error{
    [self stage_1_FinishPing:error];
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    self.pingPacketSendDate = [NSDate date];
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error{
    [self stage_1_FinishPing:error];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber fromAddr:(NetAddr*)fromAddr{
    NSDate *end = [NSDate date];
    NSTimeInterval latency = [end timeIntervalSinceDate:self.pingPacketSendDate] * 1000;
    [self.pingValuesSet addObject:@(latency)];
    NSNumber *avg = [self.pingValuesSet valueForKeyPath:@"@avg.self"];
    self.pingValueLabel.text = [NSString stringWithFormat:@"%.0f %@", avg.doubleValue, LSTR(@"millisec-short")];
    [pinger sendPingWithData:nil];
}

#pragma mark- 2.upload
- (void)stage_2_StartUpload{
    // TODO: Upload speed_test.php
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://DOMAIN/api/speed_test.php"]];
    self.uploadTask = [self.rateController calcUploadDataRateWithDelegate:self request:request];
}

- (void)stage_2_FinishUpload:(NSError*)error{
    self.uploadTask = nil;
    if (!error || error.code == NSURLErrorCancelled || error.code == NSURLErrorTimedOut){
        if (++self.uploadRetryCount < TEST_RETRY){
            [self stage_2_StartUpload];
        }
        else{
            [self stage_3_StartDownload];
        }
    }
    else{
        self.uploadValueLabel.textColor = UIColor.menuRedTitle;
        [self handleStageError:error];
    }
}

#pragma mark- 3.download
- (void)stage_3_StartDownload{
    // TODO: Download speed_test.php
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://DOMAIN/api/speed_test.php?download=1048576"]];
    self.downloadTask = [self.rateController calcDownloadDataRateWithDelegate:self request:request];
}

- (void)stage_3_FinishDownload:(NSError*)error{
    self.downloadTask = nil;
    if (!error || error.code == NSURLErrorCancelled || error.code == NSURLErrorTimedOut){
        if (++self.downloadRetryCount < TEST_RETRY){
            [self stage_3_StartDownload];
        }
        else{
            self.startButton.enabled = YES;
        }
    }
    else{
        self.downloadValueLabel.textColor = UIColor.menuRedTitle;
        [self handleStageError:error];
    }
}

#pragma mark- data rate
- (void)dataRateDidUpdate:(OSServerDataRate*)rate{
    
}

- (NSString*)dataRateStingFromBytesCount:(long long)bytesCount{
    static NSByteCountFormatter *fmt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmt = [[NSByteCountFormatter alloc] init];
        fmt.countStyle = NSByteCountFormatterCountStyleBinary;
        fmt.adaptive = YES;
    });
    NSString *res = [NSString stringWithFormat:@"%@/%@", [fmt stringFromByteCount:bytesCount], LSTR(@"upload-per-sec")];
    return res;
}

- (void)dataRateDidEnd:(OSServerDataRate*)rate error:(NSError*)error{
    if (rate.task == self.uploadTask){
        [self.uploadValues addObject:rate.rate];
        int64_t avg = [self avg:self.uploadValues];
        self.uploadValueLabel.text = [self dataRateStingFromBytesCount:avg];
        [self stage_2_FinishUpload:error];
    }
    else if (rate.task == self.downloadTask){
        [self.downloadValues addObject:rate.rate];
        int64_t avg = [self avg:self.downloadValues];
        self.downloadValueLabel.text = [self dataRateStingFromBytesCount:avg];
        [self stage_3_FinishDownload:error];
    }
}

- (int64_t)avg:(NSArray<NSNumber*>*)array{
    __block long double avg = 0;
    [array enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        avg += obj.doubleValue;
    }];
    avg /= array.count;
    return (int64_t)avg;
}

#pragma mark- setters
- (void)setSimplePing:(SimplePing *)simplePing{
    _simplePing = simplePing;
    if (simplePing){
        [self.pingActivity startAnimating];
    }
    else{
        [self.pingActivity stopAnimating];
    }
}

- (void)setUploadTask:(NSURLSessionUploadTask *)uploadTask{
    _uploadTask = uploadTask;
    if (uploadTask){
        [self.uploadActivity startAnimating];
    }
    else{
        [self.uploadActivity stopAnimating];
    }
}

- (void)setDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    _downloadTask = downloadTask;
    if (downloadTask){
        [self.downloadActivity startAnimating];
    }
    else{
        [self.downloadActivity stopAnimating];
    }
}

@end
