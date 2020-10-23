//
//  TBaseViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 31.10.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TBaseViewController.h"
#import "UIViewController+OSExt.h"
#import "NSObject+OSExt.h"

NSString *LSTR(NSString*key)
{
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = [[NSBundle mainBundle] localizedInfoDictionary];
    });
    
    NSString *str = [dic objectForKey:key];
    if (!str)
        str = key;
    return str;
}

void metrica_report_event(NSString *str){
#if SERVICE_YANDEX_METRICA_ENABLED
    @try{
        [YMMYandexMetrica reportEvent:str onFailure:^(NSError * _Nonnull error) {
            NSLog(@"failed to report metrica event '%@' error:%@", str, error);
        }];
    }@catch(NSException*e){
        LOG_EX_C(e);
    }
#endif
}

//static void *TBaseViewControllerKVOCtx = &TBaseViewControllerKVOCtx;

@interface TBaseViewController ()
@property (nonatomic, assign) BOOL onScreen;
//@property (nonatomic, strong) UIView *activityBackground;
@end

@implementation TBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.activity){
//        if (@available(iOS 13, *)){
//            self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
//        }
//        else{
//            self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//        }
//        self.activity.color = UIColor.color88;
//        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
//        v.backgroundColor = UIColor.whiteColor;
//        [self.activity.superview insertSubview:v belowSubview:self.activity];
//        v.translatesAutoresizingMaskIntoConstraints = NO;
//        [v.centerXAnchor constraintEqualToAnchor:self.activity.centerXAnchor constant:-1].active = YES;
//        [v.centerYAnchor constraintEqualToAnchor:self.activity.centerYAnchor constant:-1].active = YES;
//        [v.widthAnchor constraintEqualToAnchor:self.activity.widthAnchor constant:10].active = YES;
//        [v.heightAnchor constraintEqualToAnchor:self.activity.heightAnchor constant:10].active = YES;
//        //v.layer.cornerRadius = v.frame.size.height * 0.5f;
//        v.layer.borderColor = self.activity.color.CGColor;
//        //v.layer.borderWidth = 1;
//        v.layer.masksToBounds = YES;
//        v.layer.needsDisplayOnBoundsChange = YES;
//        v.alpha = 0;
//        v.userInteractionEnabled = NO;
//        self.activityBackground = v;
//        [self.activity addObserver:self forKeyPath:@"hidden" options:KVO_NEW_OLD_INITIAL context:TBaseViewControllerKVOCtx];
    }
}

//- (void)dealloc{
//    [self.activity safeRemoveObserver:self forKeyPath:@"hidden"];
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if (context == TBaseViewControllerKVOCtx){
//        [self updateActivityBackground];
//    }
//    else{
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

//- (void)updateActivityBackground{
//    if (!self.activity || !self.activityBackground){
//        self.activityBackground.alpha = 0;
//        self.activityBackground.layer.borderWidth = 0;
//        self.activityBackground.layer.cornerRadius = 0;
//    }
//    else{
//        self.activityBackground.alpha = !self.activity.isAnimating?0:1;
//        self.activityBackground.layer.borderWidth = 1;
//        self.activityBackground.layer.cornerRadius = (self.activity.frame.size.height + 10) * 0.5f;
//    }
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.onScreen = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    self.onScreen = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self updateActivityBackground];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)createBackButton{
    return YES;
}

- (UINavigationItem*)navigationItem{
    UINavigationItem *item = [super navigationItem];
    if (item.leftBarButtonItem.tag != 1000 && [self createBackButton]){
        UIBarButtonItem *barItem = [UIViewController backArrowFor:self sel:@selector(triBaseBackTap:)];
        barItem.tag = 1000;
        item.leftBarButtonItem = barItem;
    }
    return item;
}

- (void)triBaseBackTap:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- keyboard
- (void)keyboardWillChange:(NSNotification *)note{
    [self updateKeyboard:note up:YES];
}

- (void)keyboardWillHide:(NSNotification *)note{
    [self updateKeyboard:note up:NO];
}

- (NSLayoutConstraint*)findBottomConstraint{
    __block NSLayoutConstraint *res = nil;
    [self.view.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.firstItem == self.view && obj.secondAttribute == NSLayoutAttributeBottom && [obj.secondItem isKindOfClass:UILayoutGuide.class]){
            res = obj;
            *stop = YES;
        }
    }];
    return res;
}

- (void)updateKeyboard:(NSNotification*)note up:(BOOL)up
{
    if (self.isBeingDismissed)
        return;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad && self.splitViewController)
        return;
    
    CGRect kfe;
    NSTimeInterval animationDuration;
    NSDictionary *userInfo = note.userInfo;
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&kfe];
    NSLayoutConstraint *bc = [self findBottomConstraint];
    CGFloat value = up?kfe.size.height:0;
    if (bc.constant != value){
        bc.constant = value;
        [self keyboardUpdateConstraints:kfe up:up];
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:animationDuration animations:^{
            [self keyboardUpdate:kfe up:up];
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            [self keyboardUpdateCompleted:up];
        }];
    }
}

- (void)keyboardUpdateConstraints:(CGRect)rect up:(BOOL)up{
    
}

- (void)keyboardUpdate:(CGRect)rect up:(BOOL)up{
    
}

- (void)keyboardUpdateCompleted:(BOOL)up{
    
}

@end
