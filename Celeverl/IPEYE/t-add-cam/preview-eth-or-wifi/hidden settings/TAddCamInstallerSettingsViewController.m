//
//  TAddCamInstallerSettingsViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 14.07.2020.
//  Copyright © 2020 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamInstallerSettingsViewController.h"

@interface TAddCamInstallerSettingsViewController ()
@property(nonatomic, weak) IBOutlet UISwitch *fwInstallSwitch;
@property(nonatomic, weak) IBOutlet UISwitch *fwDownloadSwitch;
@property(nonatomic, weak) IBOutlet UISwitch *fwDowngradeSwitch;
@end

@implementation TAddCamInstallerSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fwInstallSwitch.on = TDahuaCamBlank.forceFirmwareUpdate;
    self.fwDownloadSwitch.on = TDahuaCamBlank.forceFirmwareDownload;
    self.fwDowngradeSwitch.on = TDahuaCamBlank.forceFirmwareDowngrade;
}

- (IBAction)fwInstallTap:(id)sender{
    TDahuaCamBlank.forceFirmwareUpdate = self.fwInstallSwitch.on;
}

- (IBAction)fwDownloadTap:(id)sender{
    TDahuaCamBlank.forceFirmwareDownload = self.fwDownloadSwitch.on;
}

- (IBAction)fwDowngradeTap:(id)sender{
    TDahuaCamBlank.forceFirmwareDowngrade = self.fwDowngradeSwitch.on;
}

@end
