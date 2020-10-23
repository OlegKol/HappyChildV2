//
//  TBaseViewController.h
//  IPEYE
//
//  Created by Roman Solodyashkin on 31.10.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IPCam;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *LSTR(NSString*key);
UIKIT_EXTERN void metrica_report_event(NSString *str);
#define OSServerCancelTask(X) if ( nil != (X) ) { [(X) cancel]; (X) = nil; }
#define TimerInvalidateNil(X) if ( nil != (X) ) { [(X) invalidate]; (X) = nil; }
#define DISPATCH_BLOCK_MAIN_SYNC_IF_NEEDED(X) if (NSThread.isMainThread){(X)();}else{dispatch_sync(dispatch_get_main_queue(), X);}
#define DISPATCH_BLOCK_MAIN_ASYNC_IF_NEEDED(X) if (NSThread.isMainThread){(X)();}else{dispatch_async(dispatch_get_main_queue(), X);}

#define KVO_NEW_OLD_INITIAL (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial)
#define KVO_NEW (NSKeyValueObservingOptionNew)

#define LOG_EX(E) NSLog(@"%@ %s %d %@", self.class, __FUNCTION__, __LINE__, (E))
#define LOG_EX_C(E) NSLog(@"%s %d %@", __FUNCTION__, __LINE__, (E))b

@interface TBaseViewController : UIViewController
@property (nonatomic, assign, readonly) BOOL onScreen;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IPCam *cam;

#pragma mark- keyboard
- (void)keyboardWillChange:(NSNotification *)note;
- (void)keyboardWillHide:(NSNotification *)note;
- (void)updateKeyboard:(NSNotification*)note up:(BOOL)up;
- (void)keyboardUpdate:(CGRect)rect up:(BOOL)up;
- (void)triBaseBackTap:(id _Nullable)sender;
- (BOOL)createBackButton;
@end

NS_ASSUME_NONNULL_END
