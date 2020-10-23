//
//  NSObject+OSExt.h
//  2Me
//
//  Created by Roman Solodyashkin on 6/29/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (OSExt)
- (void)safeRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
@end
