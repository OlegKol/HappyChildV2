//
//  TAddCamBeginViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 19.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamBeginViewController.h"
#import "TAddCamScanQRViewController.h"
#import "UIButton+OSExt.h"
#import "UIViewController+OSExt.h"
//#import "ServerConnection.h"

@interface TAddCamBeginViewController ()
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@end

@implementation TAddCamBeginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.blank = TDahuaCamBlank.new;
    NSOperatingSystemVersion osv = NSProcessInfo.processInfo.operatingSystemVersion;
    NSString *osInfo = [NSString stringWithFormat:@"iOS %zd.%zd.%zd", osv.majorVersion, osv.minorVersion, osv.patchVersion];
    
    NSDictionary *dic = NSBundle.mainBundle.infoDictionary;
    NSString *appInfo = [NSString stringWithFormat:@"%@ %@.%@",
                         [NSString stringWithUTF8String:getprogname()],
                         dic[@"CFBundleShortVersionString"],
                         dic[(NSString*)kCFBundleVersionKey]];
    
    WiFiLog(@"Make blank:%@ app:%@ sys:%@",
            self.blank,
            appInfo,
            osInfo);
    self.infoLabel.text = LSTR(@"add-cam-begin-info");
    [self.nextButton setTitle:LSTR(@"next") forState:UIControlStateNormal];
    [self.nextButton tricolorBlue];
}

- (void)dealloc{
    [TDahuaCamConnection cleanupSDK];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WiFiLog(@"Begin...");
}

- (IBAction)nextTap:(id)sender{
    metrica_report_event(@"AddCam.PowerCheck.Complete");
    TAddCamScanQRViewController *vc = (id)[TAddCamScanQRViewController initWithMainBundle];
    vc.blank = self.blank;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
