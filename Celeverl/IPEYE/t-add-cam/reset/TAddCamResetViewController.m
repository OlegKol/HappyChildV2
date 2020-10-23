//
//  TAddCamResetViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 27.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamResetViewController.h"

@interface TAddCamResetViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *resetLabel;
@property (nonatomic, weak) IBOutlet UILabel *helpLabel;
@property (nonatomic, weak) IBOutlet UIButton *helpButton;
@end

@implementation TAddCamResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resetLabel.text = LSTR(@"cam-reset");
    self.helpLabel.text = LSTR(@"cam-reset-need-help");
    self.view.backgroundColor = UIColor.whiteColor;
    self.imageView.image = [self.blank isBullet] ? [UIImage imageNamed:@"bullet-reset"] : [UIImage imageNamed:@"cam-reset"];
}

- (IBAction)helpTap:(id)sender{
    // TODO: открыть веб-урл где описан сброс камеры CamResetURLString
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CamResetURLString] options:@{} completionHandler:nil];
}

@end
