//
//  TAddCamSerialEnterViewController.h
//  IPEYE
//
//  Created by Roman Solodyashkin on 18.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamBaseViewController.h"

@class TAddCamSerialEnterViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol TAddCamSerialEnterViewControllerDelegate <NSObject>
@required
- (void)serialNumberDidEnter:(TAddCamSerialEnterViewController*)vc number:(NSString*)number securityKey:(NSString*)securityKey;
@end

@interface TAddCamSerialEnterViewController : TAddCamBaseViewController
@property (nonatomic, weak) id <TAddCamSerialEnterViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
