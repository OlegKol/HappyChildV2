//
//  OSServerDataRate.h
//  2Me
//
//  Created by Roman Solodyashkin on 10/27/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IPEYEDahua/OSServerDataRateProtocol.h>

@interface OSServerDataRate : NSObject
@property (nonatomic, readonly) NSURLSessionTask *task;
@property (nonatomic, readonly) NSNumber *rate;

- (id)initWithTask:(NSURLSessionTask*)task delegate:(id<OSServerDataRateDelegate>)delegate;
- (void)startTimeoutTimerWithTime:(NSTimeInterval)afterTime;
- (void)updateWithTotalBytesSent:(int64_t)totalBytesSent;
- (void)finish:(NSError*)error;

@end
