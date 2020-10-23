//
//  TTextFieldContainer.m
//  Триколор
//
//  Created by Roman Solodyashkin on 13.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TTextFieldContainer.h"
#import "OSCodeInputView.h"
#import "UIColor+OSExt.h"

@interface TTextFieldContainer ()
@property (nonatomic, strong) NSString *originFieldValue;
@property (nonatomic, assign, readonly) BOOL originFieldIsSecure;
@end

@implementation TTextFieldContainer
- (void)awakeFromNib{
    [super awakeFromNib];
    self.textField.backgroundColor = UIColor.clearColor;
    self.iconImageView.image = [self.iconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _originFieldIsSecure = self.textField.isSecureTextEntry;
    [self updateErrorState];
}

- (void)setErrorDescription:(NSString *)errorDescription{
    if (_errorDescription != errorDescription){
        _errorDescription = errorDescription;
        if (errorDescription){
            self.originFieldValue = self.textField.text;
            self.textField.text = errorDescription;
            self.textField.secureTextEntry = NO;
            self.errorFlag = YES;
            self.textField.leftView.hidden = YES;
        }
        else{
            self.textField.secureTextEntry = self.originFieldIsSecure;
            self.textField.text = self.originFieldValue;
            self.originFieldValue = nil;
            self.errorFlag = NO;
            self.textField.leftView.hidden = NO;
        }
    }
}

- (void)setErrorFlag:(BOOL)errorFlag{
    _errorFlag = errorFlag;
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong typeof(wself) sself = wself;if (!sself) return;
        [sself updateErrorState];
        sself.codeInputView.errorFlag = errorFlag;
    }];
}

- (void)updateErrorState{
    if (self.errorFlag){
        self.textField.textColor = UIColor.colorErrorFieldText;
        self.label.textColor = UIColor.colorErrorFieldText;
        self.backgroundColor = UIColor.colorErrorFieldBackgound;
        self.topSeparator.backgroundColor = UIColor.colorErrorFieldBorder;
        self.bottomSeparator.backgroundColor = UIColor.colorErrorFieldBorder;
        self.iconImageView.tintColor = UIColor.colorErrorFieldText;
    }
    else{
        self.textField.textColor = UIColor.color88;
        self.label.textColor = UIColor.color88;
        self.backgroundColor = UIColor.whiteColor;
        self.topSeparator.backgroundColor = UIColor.colorFieldBorder;
        self.bottomSeparator.backgroundColor = UIColor.colorFieldBorder;
        self.iconImageView.tintColor = UIColor.colorFieldImageTint;
    }
    if ([self.textField.leftView isKindOfClass:UITextField.class]){
        UITextField *left = (id)self.textField.leftView;
        left.textColor = self.textField.textColor;
        left.backgroundColor = self.textField.backgroundColor;
    }
}

@end
