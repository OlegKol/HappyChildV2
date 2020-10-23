//
//  TPassCodeViewController.m
//  Триколор
//
//  Created by Roman Solodyashkin on 13.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TPassCodeViewController.h"
#import "OSCodeInputView.h"
#import "UIButton+OSExt.h"

typedef NS_ENUM(NSUInteger, TPassCreateStepMode) {
    TPassCreateStepModeEnter,
    TPassCreateStepModeVerify,
};

@interface TPassCodeViewController () <UITextFieldDelegate, OSCodeInputViewDelegate, CAAnimationDelegate>
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet OSCodeInputView *codeView;
@property (nonatomic, weak) IBOutlet UIButton *skipButton;
@property (nonatomic, weak) IBOutlet UIButton *resetButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *codeViewCenterXConstraint;
@property (nonatomic, strong) NSString *createdCode;
@property (nonatomic, assign) TPassCreateStepMode createMode;
@end

@implementation TPassCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.codeView.codeLength = 4;
    switch (self.mode) {
        case TPassCodeViewControllerModeCreate:
            self.createMode = TPassCreateStepModeEnter;
            [self.skipButton setTitle:LSTR(@"next") forState:UIControlStateNormal];
            [self.resetButton setTitle:LSTR(@"reset") forState:UIControlStateNormal];
            break;
        case TPassCodeViewControllerModeEnter:
            self.label.text = LSTR(@"enter-security-code");
            self.skipButton.hidden = YES;
            [self.resetButton setTitle:LSTR(@"cancel") forState:UIControlStateNormal];
            break;
    }
    [self.skipButton tricolorBlue];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.codeView becomeFirstResponder];
#ifdef AUTO_ENTER_PASSCODE_VALUE
    [self.delegate TPassCodeDone:self withCode:AUTO_ENTER_PASSCODE_VALUE];
#endif
}

#pragma mark- code create
- (void)setCreateMode:(TPassCreateStepMode)createMode{
    _createMode = createMode;
    switch (createMode) {
        case TPassCreateStepModeEnter:
            self.label.text = LSTR(@"create-security-code");
            break;
        case TPassCreateStepModeVerify:
            self.label.text = LSTR(@"create-security-code-confirm");
            break;
    }
}

#pragma mark- code enter
- (void)codeChanged:(NSString*)code{
    
}

- (void)codeCompleted:(NSString*)code
{
//    switch (self.mode) {
//        case TPassCodeViewControllerModeCreate:
//            if (!self.createdCode){
//                self.createdCode = code;
//                self.codeView.code = nil;
//                self.createMode = TPassCreateStepModeVerify;
//            }
//            else{
//                if ([self.createdCode isEqualToString:code]){
//                    [self.delegate TPassCodeDone:self withCode:code];
//                }
//                else{
//                    [AppDelegate showAlert:LSTR(@"passwords-not-match")];
//                }
//            }
//            break;
//        case TPassCodeViewControllerModeEnter:
//            if ([TCredentials.passCode isEqualToString:code]){
//                [self.delegate TPassCodeDone:self withCode:code];
//            }
//            else{
//                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//                [self shakeView:self.codeView];
//            }
//            break;
//    }
}

- (void)shakeView:(UIView*)view{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeTranslation( 5.0f, 0.0f, 0.0f)]];
    anim.autoreverses = YES;
    anim.repeatCount = 2.0f;
    anim.duration = 0.07f;
    anim.delegate = self;
    [view.layer addAnimation:anim forKey:nil];
}

- (void)animationDidStart:(CAAnimation *)anim{
    self.codeView.errorFlag = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.codeView.errorFlag = NO;
    self.codeView.code = nil;
}

- (IBAction)createReset:(id)sender{
    if (self.mode == TPassCodeViewControllerModeCreate){
        self.createdCode = nil;
        self.codeView.code = nil;
        self.createMode = TPassCreateStepModeEnter;
    }
    else{
        if ([self.delegate respondsToSelector:@selector(TPassCodeEnterCancelled:)]){
            [self.delegate TPassCodeEnterCancelled:self];
        }
    }
}

- (IBAction)skipTap:(id)sender{
    if ([self.delegate respondsToSelector:@selector(TPassCodeCreateSkipped:)]){
        [self.delegate TPassCodeCreateSkipped:self];
    }
}

@end
