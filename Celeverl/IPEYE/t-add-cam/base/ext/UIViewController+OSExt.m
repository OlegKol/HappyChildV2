//
//  UIViewController+OSExt.m
//  OStream
//
//  Created by Roman Solodyashkin on 1/20/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import "UIViewController+OSExt.h"
#import "UIImage+OSExt.h"

@implementation UIViewController (OSExt)

+ (UIViewController*)initWithMainBundle
{
    UIViewController *vc = [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    return vc;
}

+ (UIWindow*)windowWithNormalLevel
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *topWindow in windows)
    {
        if (topWindow.windowLevel == UIWindowLevelNormal)
            return topWindow;
    }
    return [UIApplication sharedApplication].keyWindow;
}

+ (UIViewController*)topMostController
{
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        topWindow = [UIViewController windowWithNormalLevel];
    }
    
    UIViewController *topController = topWindow.rootViewController;
    if(topController == nil)
    {
        topWindow = [UIApplication sharedApplication].delegate.window;
        if (topWindow.windowLevel != UIWindowLevelNormal)
        {
            topWindow = [UIViewController windowWithNormalLevel];
        }
        topController = topWindow.rootViewController;
    }
    
    while(topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    
    if([topController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController*)topController;
        topController = [nav.viewControllers lastObject];
        
        while(topController.presentedViewController)
        {
            topController = topController.presentedViewController;
        }
    }
    
    return topController;
}

+ (AVCaptureVideoOrientation)videoOriFromInterfaceOri:(UIInterfaceOrientation)dori
{
    AVCaptureVideoOrientation vori;
    switch (dori)
    {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationLandscapeLeft:       vori = AVCaptureVideoOrientationLandscapeLeft;      break;
        case UIInterfaceOrientationLandscapeRight:      vori = AVCaptureVideoOrientationLandscapeRight;     break;
        case UIInterfaceOrientationPortrait:            vori = AVCaptureVideoOrientationPortrait;           break;
        case UIInterfaceOrientationPortraitUpsideDown:  vori = AVCaptureVideoOrientationPortraitUpsideDown; break;
    }
    return vori;
}

+ (AVCaptureVideoOrientation)videoOriFromDeviceOri:(UIDeviceOrientation)deviceOrientation
{
    // https://developer.apple.com/library/archive/qa/qa1744/_index.html
    AVCaptureVideoOrientation ori;
    switch (deviceOrientation) {
        case UIDeviceOrientationUnknown:{ori=AVCaptureVideoOrientationPortrait;} break;
        case UIDeviceOrientationPortrait:{ori=AVCaptureVideoOrientationPortrait;} break;
        case UIDeviceOrientationPortraitUpsideDown:{ori=AVCaptureVideoOrientationPortraitUpsideDown;} break;
        case UIDeviceOrientationLandscapeLeft:{ori=AVCaptureVideoOrientationLandscapeRight;} break;
        case UIDeviceOrientationLandscapeRight:{ori=AVCaptureVideoOrientationLandscapeLeft;} break;
        case UIDeviceOrientationFaceUp:{ori=AVCaptureVideoOrientationPortrait;} break;
        case UIDeviceOrientationFaceDown:{ori=AVCaptureVideoOrientationPortraitUpsideDown;} break;
        default:{ori=AVCaptureVideoOrientationPortrait;} break;
    }
    return ori;
}

+ (UIDeviceOrientation)deviceOriFromInterfaceOri:(UIInterfaceOrientation)fromInterfaceOri
{
    UIDeviceOrientation ori;
    switch (fromInterfaceOri)
    {
        case UIInterfaceOrientationUnknown:             ori = UIDeviceOrientationUnknown;               break;
        case UIInterfaceOrientationPortrait:            ori = UIDeviceOrientationPortrait;              break;
        case UIInterfaceOrientationPortraitUpsideDown:  ori = UIDeviceOrientationPortraitUpsideDown;    break;
        case UIInterfaceOrientationLandscapeLeft:       ori = UIDeviceOrientationLandscapeLeft;         break;
        case UIInterfaceOrientationLandscapeRight:      ori = UIDeviceOrientationLandscapeRight;        break;
    }
    return ori;
}

+ (UIInterfaceOrientation)interfaceOriFromDeviceOri:(UIDeviceOrientation)fromDeviceOri
{
    UIInterfaceOrientation ori;
    switch (fromDeviceOri)
    {
        case UIDeviceOrientationUnknown:             ori = UIInterfaceOrientationUnknown;               break;
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationPortrait:            ori = UIInterfaceOrientationPortrait;              break;
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationPortraitUpsideDown:  ori = UIInterfaceOrientationPortraitUpsideDown;    break;
        case UIDeviceOrientationLandscapeLeft:       ori = UIInterfaceOrientationLandscapeLeft;         break;
        case UIDeviceOrientationLandscapeRight:      ori = UIInterfaceOrientationLandscapeRight;        break;
    }
    return ori;
}

- (void)setTabBarItemImageNamed:(NSString*)name
{    
    UIImage *image = [UIImage imageNamed:name];
//    CGFloat scale = UIScreen.mainScreen.scale;
//    CGFloat side = 30 * (scale > 1 ? 2 : 1);
//    image = [UIImage imageWithImage:image scaledToMaxWidth:side maxHeight:side];
//    image = [UIImage imageWithCGImage:[image CGImage]
//                                scale:8 - scale
//                          orientation:UIImageOrientationUp];
    self.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.tabBarItem.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIBarButtonItem*)backArrowFor:(id)target sel:(SEL)sel
{
    UIBarButtonItem *backButton =
    [UIBarButtonItem.alloc initWithImage:[UIImage imageNamed:@"back-arrow"]
                                     style:UIBarButtonItemStylePlain
                                    target:target
                                    action:sel];
    backButton.tintColor = UIColor.whiteColor;
    // image already have -10 left
    //backButton.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    return backButton;
}

+ (UITabBarItem*)tabItemWithTitle:(NSString*)title imageName:(NSString*)imageName
{
    UIImage *origin = [UIImage imageNamed:imageName];
    //origin = [origin fillSourceAtopWithColor:[UIColor tabBarItemImageColor]];
    origin = [origin imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selected = [UIImage imageNamed:imageName];
    selected = [selected fillSourceAtopWithColor:[UIColor redColor]];
    selected = [selected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabitem = [[UITabBarItem alloc] initWithTitle:title image:origin selectedImage:selected];
    
    UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
    // ex:iPhone 6s
    if (mainWindow.safeAreaInsets.bottom == 0) {
        tabitem.titlePositionAdjustment = UIOffsetMake(0, -16);
        tabitem.imageInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
    }
    // iPhone 11/11pro/11max = 34
    else{
        tabitem.titlePositionAdjustment = UIOffsetMake(0, 12);
        tabitem.imageInsets = UIEdgeInsetsMake(10, 0, -10, 0);
        tabitem.landscapeImagePhoneInsets = tabitem.imageInsets;
    }
    return tabitem;
}

@end
