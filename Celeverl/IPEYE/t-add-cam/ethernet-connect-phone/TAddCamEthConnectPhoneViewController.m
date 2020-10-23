//
//  TAddCamEthConnectPhoneViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 18.05.2020.
//  Copyright © 2020 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamEthConnectPhoneViewController.h"
#import "TAddCamGreenLampViewController.h"

@interface TAddCamEthConnectPhoneViewController ()
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, weak) IBOutlet UILabel *aboutLabel;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@end

@implementation TAddCamEthConnectPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoLabel.text = LSTR(@"add-cam-eth-phone-wifi-connect-info");
    self.aboutLabel.text = LSTR(@"add-cam-eth-phone-wifi-connect-about");
    [self.nextButton setTitle:LSTR(@"next") forState:UIControlStateNormal];
    [self.nextButton tricolorBlue];
}

- (IBAction)nextTap:(id)sender{
    TAddCamGreenLampViewController *vc = (id)[TAddCamGreenLampViewController initWithMainBundle];
    vc.blank = self.blank;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
