//
//  UIImage+OSExt.m
//  OStream
//
//  Created by Roman Solodyashkin on 1/22/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import "UIImage+OSExt.h"
#import "UIColor+OSExt.h"
//#import "FFBadgedBarButtonItem.h"

double radians(double degrees)
{
    return degrees * M_PI/180;
}

@implementation UIImage (OSExt)

- (UIImage*)blurredImage{
    static CIContext *cictx;
    static CIFilter *blur;
    static CIFilter *clamp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cictx = [CIContext contextWithOptions:nil];
        blur = [CIFilter filterWithName:@"CIGaussianBlur"];
        [blur setValue:@10 forKey:kCIInputRadiusKey];
        
        clamp = [CIFilter filterWithName:@"CIAffineClamp"];
        [clamp setDefaults];
    });
    CIImage *ciinput = [CIImage imageWithCGImage:self.CGImage];
    [clamp setValue:ciinput forKey:kCIInputImageKey];
    [blur setValue:clamp.outputImage forKey:kCIInputImageKey];
    CGImageRef cgimg = [cictx createCGImage:blur.outputImage fromRect:ciinput.extent];
    if (cgimg){
        UIImage *res = [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);
        return res;
    }
    return nil;
}

- (UIImage*)rotateToAngle:(double)angle
{
    UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize midsz = CGSizeMake(self.size.width * 0.5f, self.size.height * 0.5);
    CGContextTranslateCTM(context, midsz.width, midsz.height);
    CGContextRotateCTM(context, radians(angle));
    CGContextTranslateCTM(context, -midsz.width, -midsz.height);
    [self drawAtPoint:CGPointMake(0, 0)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)fillSourceAtopWithColor:(UIColor*)color
{
    CGRect r = (CGRect){CGPointZero, self.size};
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 3);
    CGContextRef imgctx = UIGraphicsGetCurrentContext();
    if (!imgctx)
        return nil;
    [self drawInRect:r];
    CGContextSetBlendMode(imgctx, kCGBlendModeSourceAtop);
    CGContextSetFillColorWithColor(imgctx, color.CGColor);
    CGContextFillRect(imgctx, r);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)patternImageWithColor:(UIColor *)color
{
    return [UIImage patternImageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage*)patternImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGColorRef c = color.CGColor;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorSpace(ctx, CGColorGetColorSpace(c));
    CGContextSetFillColorWithColor(ctx, c);
    CGContextFillRect(ctx, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (NSString*)toBase64String
{
    NSData *imgData = UIImageJPEGRepresentation(self, 0.75f);
    NSString *imgString = [imgData base64EncodedStringWithOptions:kNilOptions];
    return imgString;
}

- (UIImage*)avatarRoundedImage
{
    UIImage *image;
    if ( !CGSizeEqualToSize(self.size, CGSizeMake(128, 128)) )
        image = [self resizedImage:CGSizeMake(128, 128) interpolationQuality:kCGInterpolationHigh];
    else
        image = self;
    image = [image roundedImage];
    return image;
}

- (UIImage*)roundedImage
{
    UIImage *res = [self imageWithCornerRadius:self.size.height * 0.5f];
    return res;
}

- (UIImage*)imageWithCornerRadius:(CGFloat)cornerRadius
{
    CGRect rect = (CGRect){CGPointZero, self.size};
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    
    UIImage *res;
    if ( NO == path.isEmpty )
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
        [path addClip];
        [self drawInRect:rect];
        res = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        res = nil;
    }
    return res;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height
{
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}

- (BOOL)writeToFile:(NSString*)file
{
    NSData *data = UIImagePNGRepresentation(self);
    BOOL res = [data writeToFile:file atomically:YES];
    if (!res){
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        res = [data writeToFile:file atomically:NO];
    }
    return res;
}

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long)contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    if ( nil == imageRef )
        return nil;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                kCGImageAlphaPremultipliedLast);//CGImageGetBitmapInfo(imageRef)
    if ( NULL == bitmap )
        return nil;
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

// Returns true if the image has an alpha layer
- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(self.CGImage),
                                                0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [self newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

#pragma mark -
#pragma mark Private helper methods

// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the new size
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8, // 8-bit grayscale
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
    
    // Get an image of the context
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // Clean up
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef;
}

+ (UIImage*)backArrow
{
    return [UIImage imageNamed:@"nav-back"];
}

+ (UIImage*)attention
{
    return [UIImage imageNamed:@"images/attention"];
}

+ (UIImage*)attentionPinArrowNormal
{
    return [[UIImage imageNamed:@"images/att-pin"] fillSourceAtopWithColor:[UIColor tableCellTextColor]];
}

+ (UIImage*)attentionPinArrowSelected
{
    return [[UIImage imageNamed:@"images/att-pin"] fillSourceAtopWithColor:[UIColor colorText54]];
}

+ (UIImage*)attentionPrevArrow
{
    return [[UIImage imageNamed:@"images/att-arrow"] fillSourceAtopWithColor:[UIColor tableCellTextColor]];
}

+ (UIImage*)attentionNextArrow
{
    UIImage *img = [UIImage imageNamed:@"images/att-arrow"];
    img = [img fillSourceAtopWithColor:UIColor.tableCellTextColor];
    if (@available(iOS 10.0, *))
        img = [img imageWithHorizontallyFlippedOrientation];
    else
        img = [img rotateToAngle:180];
    return img;
}

+ (UIImage*)annotationImageWithCount:(NSUInteger)count
{
    NSString *str = nil;//[FFBadgedBarButtonItem suffixNumber:@(count)];
    CGSize sz = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]}];
    CGFloat scale = UIScreen.mainScreen.scale;
    sz.width = (sz.width + 4) * scale;
    sz.height = (sz.height + 4) * scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             sz.width + 4,
                                             sz.height + 4,
                                             8, // 8-bit grayscale
                                             0,
                                             colorSpace,
                                             kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    
    
    CGContextSetRGBFillColor(ctx, 0.25, 0.26, 0.27, 1);
    CGContextFillEllipseInRect(ctx, (CGRect){CGPointZero, sz});
    
    CGContextTranslateCTM(ctx, 0, 0);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextSelectFont(ctx, "HelveticaNeue-Light", 15, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextShowTextAtPoint(ctx, 0, 0, str.UTF8String, str.length);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    return img;
}

+ (UIImage*)mapFlag
{
    UIImage *img = [[UIImage imageNamed:@"images/map_flag"] fillSourceAtopWithColor:[UIColor lightGrayColor]];
    img = [img resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(12, 12) interpolationQuality:kCGInterpolationHigh];
    return img;
}

+ (UIImage*)buttonNormal
{
    return [[UIImage imageNamed:@"images/btn-blue"] fillSourceAtopWithColor:[UIColor mainButtonColor]];
}

+ (UIImage*)buttonSelected
{
    return [[UIImage imageNamed:@"images/btn-blue"] fillSourceAtopWithColor:[UIColor menuSelectedBackgroundColor]];
}

+ (UIImage*)buttonDisabled
{
    return [[UIImage imageNamed:@"images/btn-blue"] fillSourceAtopWithColor:[UIColor lightGrayColor]];
}

+ (UIImage*)buttonLinkNormal
{
    return [[UIImage imageNamed:@"images/link"] fillSourceAtopWithColor:[UIColor lightGrayColor]];
}

+ (UIImage*)buttonLinkSelected
{
    return [[UIImage imageNamed:@"images/link"] fillSourceAtopWithColor:[UIColor whiteColor]];
}

+ (UIImage*)masterCheckOn
{
    return [[UIImage imageNamed:@"images/check-round-on"] fillSourceAtopWithColor:[UIColor whiteColor]];
}

+ (UIImage*)masterCheckOff
{
    return [[UIImage imageNamed:@"images/check-round-off"] fillSourceAtopWithColor:[UIColor whiteColor]];
}

+ (UIImage*)masterGearOnline{
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [[UIImage imageNamed:@"settings-gear"] fillSourceAtopWithColor:[UIColor color111_127_133]];
    });
    return img;
}

+ (UIImage*)masterGearOffline{
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [[UIImage imageNamed:@"settings-gear"] fillSourceAtopWithColor:[UIColor whiteColor]];
    });
    return img;
}

+ (UIImage*)groupsCheckOn
{
    return [UIImage imageWithImage:[UIImage masterCheckOn] scaledToMaxWidth:64 maxHeight:64];
}

+ (UIImage*)groupsCheckOff
{
    return [UIImage imageWithImage:[UIImage masterCheckOff] scaledToMaxWidth:64 maxHeight:64];
}

+ (UIImage*)trashCamCell
{
    return [[UIImage imageNamed:@"images/profile-rec-trash"] fillSourceAtopWithColor:[UIColor tableCellTextColor]];
}

+ (UIImage*)editCamCell
{
    return [[UIImage imageNamed:@"images/profile-rec-edit"] fillSourceAtopWithColor:[UIColor tableCellTextColor]];
}

+ (UIImage*)filterNavBarIcon
{
    return [UIImage imageNamed:@"images/filter"];
}

+ (UIImage*)filterSelectedNavBarIcon
{
    return [UIImage imageNamed:@"images/filter-selected"];
}

+ (UIImage*)onlineIndicatorCloud
{
    return [[UIImage imageNamed:@"images/cloud"] fillSourceAtopWithColor:[UIColor lightGrayColor]];
}

+ (UIImage*)onlineIndicatorLive
{
    return [[UIImage imageNamed:@"images/live"] fillSourceAtopWithColor:[UIColor lightGrayColor]];
}

+ (UIImage*)onlineIndicatorFilmRun
{
    return [[UIImage imageNamed:@"images/film-run"] fillSourceAtopWithColor:[UIColor lightGrayColor]];
}

+ (UIImage*)groupHeaderIcon
{
    UIImage *img;
    img = [UIImage imageFromSystemBarButton:UIBarButtonSystemItemOrganize];
    img = [img fillSourceAtopWithColor:[UIColor whiteColor]];
    return img;
}

+ (UIImage *)imageFromSystemBarButton:(UIBarButtonSystemItem)systemItem {
    UIBarButtonItem* tempItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:nil action:nil];
    
    // Add to toolbar and render it
    UIToolbar *bar = [[UIToolbar alloc] init];
    [bar setItems:@[tempItem] animated:NO];
    [bar snapshotViewAfterScreenUpdates:YES];
    
    // Get image from real UIButton
    UIView *itemView = [(id)tempItem view];
    for (UIView* view in itemView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            return [(UIButton*)view imageForState:UIControlStateNormal];
        }
    }
    
    return nil;
}

@end
