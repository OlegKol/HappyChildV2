//
//  TAddCamPreviewViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 19.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamPreviewViewController.h"
#import "TAddCamEthBeginViewController.h"
#import "TAddCamGreenLampViewController.h"
#import "UIButton+OSExt.h"
#import "TAddCamCloudViewController.h"
#import "TAddCamInstallerSettingsViewController.h"

@interface TAddCamPreviewViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *camImageView;
@property (nonatomic, weak) IBOutlet UILabel *modelInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *modelValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *serialInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *serialValueLabel;
@property (nonatomic, weak) IBOutlet UIButton *wifiConnectButton;
@property (nonatomic, weak) IBOutlet UIButton *ethernetConnectButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wifiToEthConstraint;
@property (nonatomic, strong) TDahuaCamConnection *camConnection;
@end

@implementation TAddCamPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelInfoLabel.text = LSTR(@"device-model");
    self.serialInfoLabel.text = LSTR(@"seria-placeholder");
    [self.wifiConnectButton setTitle:LSTR(@"wifi-connect") forState:UIControlStateNormal];
    [self.ethernetConnectButton setTitle:LSTR(@"eth-connect") forState:UIControlStateNormal];
    [self.wifiConnectButton tricolorBlue];
    [self.ethernetConnectButton tricolorBlue];
    self.camImageView.image = [self.blank isBullet] ? [UIImage imageNamed:@"cmodel-bullet"] : [UIImage imageNamed:@"add-cam-default"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.modelValueLabel.text = self.blank.model;
    if (!self.modelValueLabel.text){
        self.modelValueLabel.text = LSTR(@"rec-slot-unknown-device");
    }
    self.serialValueLabel.text = self.blank.serial;
    if (!self.blank.modelHasEthernetPort){
        self.wifiToEthConstraint.priority = UILayoutPriorityDefaultLow;
        self.ethernetConnectButton.hidden = YES;
    }
    else{
        self.wifiToEthConstraint.priority = UILayoutPriorityDefaultHigh+1;
        self.ethernetConnectButton.hidden = NO;
    }
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
}

- (IBAction)imageSingleTap:(id)sender{
#if TADD_CAM_FW_UPDATE_ON
    TAddCamInstallerSettingsViewController *vc = (id)[TAddCamInstallerSettingsViewController initWithMainBundle];
    vc.blank = self.blank;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        vc.preferredContentSize = CGSizeMake(480, 720);
    }
    [self presentViewController:vc animated:YES completion:nil];
#endif
}

- (TAddCamRightButtonType)barRightButtonType{
    return TAddCamRightButtonTriDot;
}

- (TAddCamRightMenuMask)barRightButtonMenuMask{
    return TAddCamRightMenuToBegin;
}

- (IBAction)wifiButtonTap:(id)sender{
    if (self.blank.modelHasEthernetPort){
        metrica_report_event(@"AddCam.Start.Outdoor.Wi-Fi");
    }
    else{
        metrica_report_event(@"AddCam.Start.Home");
    }
    TAddCamGreenLampViewController *vc = (id)[TAddCamGreenLampViewController initWithMainBundle];
    self.blank.connectiionType = TDahuaCamBlankConnectionTypeWiFi;
    vc.blank = self.blank;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)ethButtonTap:(id)sender{
    metrica_report_event(@"AddCam.Start.Outdoor.Ethrernet");
    TAddCamEthBeginViewController *vc = (id)[TAddCamEthBeginViewController initWithMainBundle];
    self.blank.connectiionType = TDahuaCamBlankConnectionTypeEthernet;
    vc.blank = self.blank;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
