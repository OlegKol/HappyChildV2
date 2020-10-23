//
//  TAddCamBaseViewController.h
//  IPEYE
//
//  Created by Roman Solodyashkin on 19.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TBaseViewController.h"
#import <IPEYEDahua/IPEYEDahua.h>
#import "UIButton+OSExt.h"
#import "UIColor+OSExt.h"
#import "UIViewController+OSExt.h"
#import "UIImage+OSExt.h"
#import "NSObject+OSExt.h"
#import "IPDHelper.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TAddCamRightButtonType) {
    TAddCamRightButtonNone,
    TAddCamRightButtonTriDot,
    TAddCamRightButtonLink,
};

typedef NS_OPTIONS(NSUInteger, TAddCamRightMenuMask) {
    TAddCamRightMenuNone            = 0,
    TAddCamRightMenuToBegin         = 1 << 0,
    TAddCamRightMenuWiFiToEth       = 1 << 1,
    TAddCamRightMenuEthToWiFi       = 1 << 2,
};

@interface TAddCamBaseViewController : TBaseViewController
@property (atomic, assign) BOOL run;
@property (atomic, strong) TDahuaCamBlank *blank;
- (void)pushCloudController;
- (void)ignoreFinishScreenBlankAddedWithDevcode:(NSString*)devcode;
#pragma mark-
- (TAddCamRightButtonType)barRightButtonType;
- (TAddCamRightMenuMask)barRightButtonMenuMask;
- (void)rightBarButtonTap:(nullable id)sender;
- (void)longSleepPringSec:(int32_t)sec text:(const char*)text;
@end

NS_ASSUME_NONNULL_END
