//
//  TAddCamEthBeginViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 19.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamEthBeginViewController.h"
#import "TAddCamEthConnectPhoneViewController.h"

@interface TAddCamEthBeginViewController ()
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@end

@implementation TAddCamEthBeginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoLabel.text = LSTR(@"add-cam-eth-begin-info");
    [self.nextButton setTitle:LSTR(@"next") forState:UIControlStateNormal];
    [self.nextButton tricolorBlue];
}

- (IBAction)nextTap:(id)sender{
    TAddCamEthConnectPhoneViewController *vc = (id)[TAddCamEthConnectPhoneViewController initWithMainBundle];
    vc.blank = self.blank;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
