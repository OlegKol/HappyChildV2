//
//  TAddCamWiFiEnterViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 20.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamWiFiEnterViewController.h"
#import "TAddCamWiFi5GUnsupViewController.h"
#import "TAddCamWiFiRouterViewController.h"
#import "TAddCamSpeedTesttViewController.h"
#import "TTextFieldContainer.h"
#import "UITextField+Tricolor.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>

@interface TAddCamWiFiEnterViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *wifiImageView;
@property (nonatomic, weak) IBOutlet UILabel *userInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *ssidLabel;
@property (nonatomic, weak) IBOutlet TTextFieldContainer *ssidContainer;
@property (nonatomic, weak) IBOutlet TTextFieldContainer *passwordContainer;
@property (nonatomic, strong) UIButton *passwordShowButton;
@property (nonatomic, weak) IBOutlet UIButton *savePasswordButton;
@property (nonatomic, weak) IBOutlet UILabel *savePasswordLabel;
@property (nonatomic, weak) IBOutlet UILabel *unsupportedLabel;
@property (nonatomic, weak) IBOutlet UIButton *unsupportedButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet UIButton *speedTestButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageToTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageToUserLabelConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *speedTestToBottomConstraint;
@property (nonatomic, strong) NEHotspotHelper *hotspotHelper;
@property (nonatomic, strong) Reachability *wifiReachability;
@property (nonatomic, strong) NSTimer *wifiSSIDReadTimer;
@end

@implementation TAddCamWiFiEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    self.userInfoLabel.text = LSTR(@"enter-wifi-ssid-pass");
    self.ssidLabel.text = LSTR(@"wifi-network-placeholder");
    [self.passwordContainer.textField tricolorUpdatePlaceholder:LSTR(@"wifi-password-placeholder")];
    self.savePasswordLabel.text = LSTR(@"wifi-save-password");
    self.unsupportedLabel.text = LSTR(@"wifi-5g-unsupported");
    [self.nextButton setTitle:LSTR(@"next") forState:UIControlStateNormal];
    [self.speedTestButton setTitle:LSTR(@"wifi-speed-test") forState:UIControlStateNormal];
    
    // @"eye-hide"
    self.passwordShowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.passwordShowButton setImage:[UIImage imageNamed:@"images/eye-closed"] forState:UIControlStateNormal];
    [self.passwordShowButton setImage:[UIImage imageNamed:@"images/eye-opened"] forState:UIControlStateSelected];
    [self.passwordShowButton addTarget:self action:@selector(passwordShowTap:) forControlEvents:UIControlEventTouchUpInside];
    self.passwordContainer.textField.rightView = self.passwordShowButton;
    self.passwordContainer.textField.rightViewMode = UITextFieldViewModeAlways;
    [self.nextButton tricolorBlue];
    [self.speedTestButton tricolorGray];
    self.nextButton.enabled = NO;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(grantsOflocationForWiFiChanged:) name:OSAuthGrantsChangedNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appDidActivate:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(wifiReachabilityDidChange:) name:kReachabilityChangedNotification object:self.wifiReachability];
}

- (void)dealloc{
    TimerInvalidateNil(self.wifiSSIDReadTimer);
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.wifiReachability startNotifier];
    TimerInvalidateNil(self.wifiSSIDReadTimer);
    self.wifiSSIDReadTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(ssidTimerTick:) userInfo:nil repeats:YES];
    [NSRunLoop.currentRunLoop addTimer:self.wifiSSIDReadTimer forMode:NSRunLoopCommonModes];
    if (@available(iOS 13.0, *)){
        [OSAuthGranter.granter isLocationServiceEnableForApp:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.wifiReachability stopNotifier];
    TimerInvalidateNil(self.wifiSSIDReadTimer);
}

- (void)appDidActivate:(NSNotification*)note{
    if (@available(iOS 13.0, *)){
        if (self.onScreen){
            [OSAuthGranter.granter isLocationServiceEnableForApp:YES];
        }
    }
}

- (void)ssidTimerTick:(NSTimer*)timer{
    [self updateSSID];
}

- (void)wifiReachabilityDidChange:(NSNotification*)note{
    [self updateSSID];
}

- (void)grantsOflocationForWiFiChanged:(NSNotification*)note{
    [self updateSSID];
}

- (void)updateSSID{
    NSString *ssid = NetAddr.localWiFiSSID;
    if (!ssid || ![self.blank.wifiSSID isEqualToString:ssid]){
        WiFiLog(@"WiFi-SSID changed from:'%@' to:'%@'", self.blank.wifiSSID, ssid);
    }
    if (!self.ssidContainer.textField.isFirstResponder &&
        !self.passwordContainer.textField.isFirstResponder){
        if ([self.wifiReachability isReachable]){
            if (!self.blank.wifiSSID){
                self.blank.wifiSSID = ssid;
            }
            self.ssidContainer.textField.text = self.blank.wifiSSID;
        }else{
            self.blank.wifiSSID = nil;
            self.ssidContainer.textField.text = nil;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//#if DEBUG
//    if (!self.blank){
//        self.blank = TDahuaCamBlank.new;
//        [self.blank fillParamsWithQRCode:[TDahuaCamBlank parseQR:@"{SN:5G043D4PAJ361D8,DT:IPC-G22P,SC:L2A262CB,NC:015}"]];
//    }
//#endif
    [self updateSSID];
    self.passwordContainer.textField.text = self.blank.wifiSecurityKey;
    [self passwordDidChange:nil];
}

- (void)keyboardUpdate:(CGRect)rect up:(BOOL)up{
    if (up){
        self.imageToTopConstraint.constant = 12;
        self.imageToUserLabelConstraint.constant = 12;
        self.speedTestToBottomConstraint.priority = UILayoutPriorityDefaultLow;
    }
    else{
        self.imageToTopConstraint.constant = 39;
        self.imageToUserLabelConstraint.constant = 39;
        self.speedTestToBottomConstraint.priority = 999;
    }
    CGFloat alpha = up?0:1;
    self.speedTestButton.alpha = alpha;
}

- (void)keyboardUpdateCompleted:(BOOL)up{
    self.speedTestButton.userInteractionEnabled = !up;
}

- (void)passwordShowTap:(id)sender{
    self.passwordShowButton.selected = !self.passwordShowButton.selected;
    self.passwordContainer.textField.secureTextEntry = !self.passwordShowButton.selected;
}

- (IBAction)savePasswordTap:(id)sender{
    self.savePasswordButton.selected = !self.savePasswordButton.selected;
}

- (IBAction)unsuppordedWiFiTap:(id)sender{
//    TAddCamWiFi5GUnsupViewController *vc = (id)[TAddCamWiFi5GUnsupViewController initWithMainBundle];
//    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)ssidContainerTap:(id)sender{
    [self.ssidContainer.textField becomeFirstResponder];
}

- (IBAction)nextTap:(id)sender{
    metrica_report_event(@"AddCam.Wi-Fi.Router.Auth.Complete");
    if (self.savePasswordButton.selected){
        // TODO: сохранить wifi ssid & password
//        TCredentials.wifiSSID = self.ssidContainer.textField.text;
//        TCredentials.wifiPassword = self.passwordContainer.textField.text;
    }
    TAddCamWiFiRouterViewController *vc = (id)[TAddCamWiFiRouterViewController initWithMainBundle];
    vc.blank = self.blank;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)testSpeedTap:(id)sender{
    TAddCamSpeedTesttViewController *vc = (id)[TAddCamSpeedTesttViewController initWithMainBundle];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)singleTap:(id)sender{
    [self.view endEditing:YES];
}

#pragma mark- text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.ssidContainer.textField){
        NSString *ssid = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *fixed = [TDahuaCamBlank fixWiFiSSID:ssid];
        if (![ssid isEqualToString:fixed]){
            textField.text = fixed;
            return NO;
        }
        return ssid.length <= TWIFI_SSID_MAX;
    }
    else if (textField == self.passwordContainer.textField){
        NSString *pass = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return pass.length <= TWIFI_SECURITY_KEY_MAX;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.ssidContainer.textField){
        [self.passwordContainer becomeFirstResponder];
    }
    else if (textField == self.passwordContainer.textField){
        [self nextTap:nil];
    }
    return YES;
}

- (IBAction)ssidDidChange:(id)sender{
    self.blank.wifiSSID = self.ssidContainer.textField.text;
}

- (IBAction)passwordDidChange:(id)sender{
    self.nextButton.enabled = [TDahuaCamBlank isWiFiSecurityKeyValid:self.passwordContainer.textField.text];
    self.blank.wifiSecurityKey = self.passwordContainer.textField.text;
}

#pragma mark-
- (TAddCamRightButtonType)barRightButtonType{
    return TAddCamRightButtonTriDot;
}

- (TAddCamRightMenuMask)barRightButtonMenuMask{
    return TAddCamRightMenuToBegin | TAddCamRightMenuWiFiToEth;
}

@end
