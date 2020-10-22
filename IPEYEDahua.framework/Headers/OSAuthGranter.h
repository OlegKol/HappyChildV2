//
//  OSAuthGranter.h
//  OStream
//
//  Created by Roman Solodyashkin on 1/20/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// posts if forced
FOUNDATION_EXTERN NSString *const OSAuthGrantsChangedNotification;
FOUNDATION_EXTERN NSString *const OSUserLocationChangedNotification;
FOUNDATION_EXTERN NSString *const OSUserHeadingChangedNotification;

@interface OSAuthGranter : NSObject
+ (instancetype)granter;
- (BOOL)hasGrantsToStartVideoRecording;
- (BOOL)isCamEnabledForApp:(BOOL)force;
- (BOOL)isMicEnabledForApp:(BOOL)force;
- (BOOL)isPhotosEnableForApp:(BOOL)force;
- (BOOL)isLocationServiceEnableForApp:(BOOL)force;

- (void)stopMonitoringLocation;
- (void)startMonitoringLocation;

@property (nonatomic, strong, readonly) CLLocation *lastLocation;
@property (nonatomic, readonly) CLLocationDirection lastHeading;
@end
