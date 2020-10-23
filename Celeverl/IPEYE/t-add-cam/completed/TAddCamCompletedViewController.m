//
//  TAddCamCompletedViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 05.12.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamCompletedViewController.h"
//#import "MasterViewController.h"
#import "UIButton+OSExt.h"
#import "TTextFieldContainer.h"
//#import "ServerConnection.h"
//#import "IPCam.h"

@interface TAddCamCompletedViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIImageView *modelImageView;
@property (nonatomic, weak) IBOutlet UILabel *deviceAddedLabel;
@property (nonatomic, weak) IBOutlet UILabel *enterNameLabel;
@property (nonatomic, weak) IBOutlet TTextFieldContainer *tcontainer;
@property (nonatomic, strong) IBOutletCollection(UIStackView) NSArray <UIStackView*> *addSettingsArray;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray <UIButton*> *buttonsArray;
@property (nonatomic, weak) IBOutlet UIButton *showMoreButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *scrollBottomConstraint;
@property (nonatomic, strong) NSURLSessionDataTask *saveTask;
@end

@implementation TAddCamCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // TODO:тут камера уже добавлена в сервис и надо обновить список камер
    //[APP.masterViewController reloadCamsAndSelectWithDevcode:nil];
    self.deviceAddedLabel.text = LSTR(@"device-added");
    self.enterNameLabel.text = LSTR(@"please-name-device");
    [self.showMoreButton setTitle:LSTR(@"show-more-names") forState:UIControlStateNormal];
    [self.showMoreButton setTitle:LSTR(@"hide-more-names") forState:UIControlStateSelected];
    [self.nextButton setTitle:LSTR(@"next") forState:UIControlStateNormal];
    [self.showMoreButton tricolorGray];
    [self.nextButton tricolorBlue];
    [self.buttonsArray enumerateObjectsWithOptions:NSEnumerationReverse
                                        usingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *lkey = [NSString stringWithFormat:@"destination-%lu", idx];
        obj.tag = idx;
        [obj tricolorCamName];
        [obj setTitle:LSTR(lkey) forState:UIControlStateNormal];
        [obj addTarget:self action:@selector(destinationTap:) forControlEvents:UIControlEventTouchUpInside];
    }];
    self.modelImageView.image = [self.blank isBullet] ? [UIImage imageNamed:@"cmodel-bullet"] : [UIImage imageNamed:@"add-cam-default"];
#if DEBUG
    self.tcontainer.textField.text = @"G-22P";
#endif
}

- (void)triBaseBackTap:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- nav.right.button
- (TAddCamRightButtonType)barRightButtonType{
    return TAddCamRightButtonTriDot;
}

- (TAddCamRightMenuMask)barRightButtonMenuMask{
    return TAddCamRightMenuToBegin;
}

//- (void)rightBarButtonTap:(nullable id)sender{
//
//}

#pragma mark- action
- (IBAction)showMoreTap:(id)sender{
    BOOL hide = self.showMoreButton.selected;
    self.showMoreButton.selected = !hide;
    [self.addSettingsArray enumerateObjectsUsingBlock:^(UIStackView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = hide;
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        CGPoint off = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom);
        [self.scrollView setContentOffset:off animated:YES];
    }];
}

- (IBAction)destinationTap:(UIButton*)sender{
    self.tcontainer.textField.text = [sender titleForState:UIControlStateNormal];
}

- (IBAction)singleTap:(id)sender{
    [self.view endEditing:YES];
}

#pragma mark- save
- (IBAction)nextTap:(id)sender{
    // TODO: отредактировать имя камеры в сервисе
    /*
    NSString *devcode = [self.blank devcodeFromSerial];
    if (devcode){
        IPCam *cam = ServerConnection.connection.camsByDevcode[devcode];
        if (cam){
            NSString *name = self.tcontainer.textField.text;
            NSTimeZone *timeZone = self.blank.timeZone;
            WiFiLog(@"will edit cam name:'%@' timeZone:'%@'", name, timeZone.name);
            [self.view endEditing:YES];
            __weak typeof(self) wself = self;
            self.saveTask =
            [cam editCamName:name
                       tarif:nil
                       sound:nil
               pushAttention:nil
                   pushState:nil
                       coord:nil
                     address:nil
                  publicFlag:nil
                    timeZone:timeZone
               pushScheduler:nil
                          cb:^(IPCam *cam, NSError *error) {
                __strong typeof(wself) sself = wself;if (!sself) return;
                if (error){
                    [AppDelegate showError:error withCancel:^{
                        __strong typeof(wself) sself = wself;if (!sself) return;
                        [sself.navigationController popToRootViewControllerAnimated:YES];
                    } andRetry:^{
                        __strong typeof(wself) sself = wself;if (!sself) return;
                        [sself nextTap:sender];
                    }];
                }
                else{
                    WiFiLog(@"cam edit complete");
                    [sself ignoreFinishScreenBlankAddedWithDevcode:cam.devCode];
                }
            }];
        }
    }
     */
}

- (void)setSaveTask:(NSURLSessionDataTask *)saveTask{
    if (_saveTask != saveTask){
        _saveTask = saveTask;
        self.nextButton.enabled = !saveTask;
        if (saveTask){
            [self.activity startAnimating];
        }
        else{
            [self.activity stopAnimating];
        }
    }
}

#pragma mark- text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return str.length <= 160;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self nextTap:nil];
    return YES;
}

#pragma mark- keyboard
- (void)keyboardUpdate:(CGRect)rect up:(BOOL)up{
    self.scrollBottomConstraint.constant = up?rect.size.height:0;
}

@end
