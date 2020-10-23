//
//  UIViewController+OSExt.h
//  OStream
//
//  Created by Roman Solodyashkin on 1/20/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIViewController (OSExt)
+ (UIViewController*)initWithMainBundle;
+ (UIViewController*)topMostController;
+ (AVCaptureVideoOrientation)videoOriFromInterfaceOri:(UIInterfaceOrientation)dori;
+ (AVCaptureVideoOrientation)videoOriFromDeviceOri:(UIDeviceOrientation)deviceOrientation;
+ (UIDeviceOrientation)deviceOriFromInterfaceOri:(UIInterfaceOrientation)fromInterfaceOri;
+ (UIInterfaceOrientation)interfaceOriFromDeviceOri:(UIDeviceOrientation)fromDeviceOri;
- (void)setTabBarItemImageNamed:(NSString*)name;

+ (UIBarButtonItem*)backArrowFor:(id)target sel:(SEL)sel;
+ (UITabBarItem*)tabItemWithTitle:(NSString*)title imageName:(NSString*)imageName;
@end
