//
//  UIImage+OSExt.h
//  OStream
//
//  Created by Roman Solodyashkin on 1/22/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN double radians(double degrees);

@interface UIImage (OSExt)

- (UIImage*)blurredImage;
- (UIImage*)rotateToAngle:(double)angle;
- (UIImage*)fillSourceAtopWithColor:(UIColor*)color;
+ (UIImage*)patternImageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage*)patternImageWithColor:(UIColor*)color;
- (NSString*)toBase64String;
- (UIImage*)avatarRoundedImage;
- (UIImage*)imageWithCornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;
- (BOOL)writeToFile:(NSString*)file;

+ (UIImage*)backArrow;
+ (UIImage*)masterCheckOn;
+ (UIImage*)masterCheckOff;
+ (UIImage*)masterGearOnline;
+ (UIImage*)masterGearOffline;
+ (UIImage*)groupsCheckOn;
+ (UIImage*)groupsCheckOff;
+ (UIImage*)mapFlag;
+ (UIImage*)buttonNormal;
+ (UIImage*)buttonSelected;
+ (UIImage*)buttonDisabled;
+ (UIImage*)buttonLinkNormal;
+ (UIImage*)buttonLinkSelected;
+ (UIImage*)attention;
+ (UIImage*)attentionPinArrowNormal;
+ (UIImage*)attentionPinArrowSelected;
+ (UIImage*)attentionPrevArrow;
+ (UIImage*)attentionNextArrow;
+ (UIImage*)annotationImageWithCount:(NSUInteger)count;
+ (UIImage*)trashCamCell;
+ (UIImage*)editCamCell;

+ (UIImage*)filterNavBarIcon;
+ (UIImage*)filterSelectedNavBarIcon;

+ (UIImage*)onlineIndicatorCloud;
+ (UIImage*)onlineIndicatorLive;
+ (UIImage*)onlineIndicatorFilmRun;

+ (UIImage*) groupHeaderIcon;

- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
    
@end
