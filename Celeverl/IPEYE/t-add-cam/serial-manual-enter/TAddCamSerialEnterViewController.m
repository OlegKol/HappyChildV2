//
//  TAddCamSerialEnterViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 18.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamSerialEnterViewController.h"
#import "TTextFieldContainer.h"
#import "UITextField+Tricolor.h"
#import "UIButton+OSExt.h"

@interface TAddCamSerialEnterViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UILabel *serialDigitInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *serialLabel;
@property (nonatomic, weak) IBOutlet TTextFieldContainer *serialContainer;
@property (nonatomic, weak) IBOutlet UILabel *securityKeyLabel;
@property (nonatomic, weak) IBOutlet TTextFieldContainer *securityKeyContainer;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@end

//#error add fields for ssid/pswd

@implementation TAddCamSerialEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.serialDigitInfoLabel.text = LSTR(@"add-cam-enter-serial-zero-is-digit");
    self.serialLabel.text = LSTR(@"add-cam-enter-serial");
    self.securityKeyLabel.text = LSTR(@"add-cam-enter-security-key");
    [self.serialContainer.textField tricolorUpdatePlaceholder:LSTR(@"seria-placeholder")];
    [self.securityKeyContainer.textField tricolorUpdatePlaceholder:@"Код безопасности"];
    [self.saveButton setTitle:LSTR(@"save") forState:UIControlStateNormal];
    self.serialContainer.textField.text = self.blank.serial;
    self.securityKeyContainer.textField.text = self.blank.safetyCode;
    [self.saveButton tricolorBlue];
#if DEBUG
    // TODO: чтобы руками не сканить в дебаге
    self.serialContainer.textField.text = @"5G043D4PAJ361D8";
    self.securityKeyContainer.textField.text = @"L2A262CB";
#endif
}

- (IBAction)serialTap:(id)sender{
    [self.delegate serialNumberDidEnter:self
                                 number:[self.serialContainer.textField.text uppercaseString]
                            securityKey:[self.securityKeyContainer.textField.text uppercaseString]];
}

- (IBAction)singleTap:(id)sender{
    [self.view endEditing:YES];
}

@end
