//
//  NSObject+OSExt.m
//  2Me
//
//  Created by Roman Solodyashkin on 6/29/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import "NSObject+OSExt.h"

@implementation NSObject (OSExt)
- (void)safeRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    @try
    {
        [self removeObserver:observer forKeyPath:keyPath];
    }
    @catch(NSException *e)
    {
        NSLog(@"%@", e);
    }
}
@end
