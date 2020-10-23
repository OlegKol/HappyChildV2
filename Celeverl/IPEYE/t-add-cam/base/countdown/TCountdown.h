//
//  TCountdown.h
//  IPEYE
//
//  Created by Roman Solodyashkin on 21.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TCountdown;

@protocol TCountdownDelegate <NSObject>
@required
- (void)countdownTimeIsOut:(TCountdown*)countdown;
@end

IB_DESIGNABLE
@interface TCountdown : UIView
@property (nonatomic, strong) IBInspectable UIColor *lineColor;
@property (nonatomic, strong) IBInspectable UIColor *lineBackgroundColor;
@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, assign) double totalTime;
@property (nonatomic, weak) IBOutlet id <TCountdownDelegate> delegate;
- (void)start;
- (void)stop;
- (BOOL)isStarted;
@end

NS_ASSUME_NONNULL_END
