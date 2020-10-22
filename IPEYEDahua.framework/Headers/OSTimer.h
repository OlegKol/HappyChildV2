//
//  OSTimer.h
//  OStream
//
//  Created by Roman Solodyashkin on 1/19/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSTimer : NSObject
+ (instancetype)timerWithInterval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue handler:(dispatch_block_t)block;
- (instancetype)initWithInterval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue handler:(dispatch_block_t)block;
- (void)start;
- (void)stop;
- (void)pause;
@end
