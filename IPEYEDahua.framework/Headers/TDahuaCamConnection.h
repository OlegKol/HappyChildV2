//
//  TDahuaCamConnection.h
//  IPEYE
//
//  Created by Roman Solodyashkin on 22.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const TDahuaCamConnectionCamFoundNotification;
FOUNDATION_EXTERN NSString *const TDahuaCamConnectionReconnectedNotification;
FOUNDATION_EXTERN NSString *const TDahuaCamConnectionDisconnectedNotification;

@interface TDahuaCamConnection : NSObject
+ (instancetype)instance;
- (BOOL)stopSearchDevices:(BOOL)reconnect;
- (BOOL)startSearchDevices;
- (BOOL)initConnection;
+ (BOOL)isSearchDevices;
+ (void)cleanupSDK;
@end

NS_ASSUME_NONNULL_END
