//
//  TPassCodeViewController.h
//  Триколор
//
//  Created by Roman Solodyashkin on 13.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TBaseViewController.h"

typedef NS_ENUM(NSUInteger, TPassCodeViewControllerMode) {
    TPassCodeViewControllerModeCreate,
    TPassCodeViewControllerModeEnter,
};

@class TPassCodeViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol TPassCodeViewControllerDelegate <NSObject>
@required
- (void)TPassCodeDone:(TPassCodeViewController*)vc withCode:(NSString*)code;
@optional
- (void)TPassCodeCreateSkipped:(TPassCodeViewController*)vc;
- (void)TPassCodeEnterCancelled:(TPassCodeViewController*)vc;
@end

@interface TPassCodeViewController : TBaseViewController
@property (nonatomic, weak) id <TPassCodeViewControllerDelegate> delegate;
@property (nonatomic, assign) TPassCodeViewControllerMode mode;
@end

NS_ASSUME_NONNULL_END
