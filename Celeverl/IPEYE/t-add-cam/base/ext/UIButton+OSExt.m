//
//  UIButton+OSExt.m
//  Oparator
//
//  Created by Roman Solodyashkin on 2/29/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import "UIButton+OSExt.h"
#import "UIImage+OSExt.h"
#import "UIColor+OSExt.h"

@implementation UIButton (OSExt)

+ (void)alignButtonsToMaxTitle:(NSArray*)buttons titleOffset:(CGFloat)titleOffset
{
    if ( 0 == buttons.count )
        return;
    
    CGFloat maxw = 0;
    for ( UIButton *btn in buttons )
    {
        maxw = fmaxf(btn.titleLabel.attributedText.size.width, maxw);
    }
    
    maxw += titleOffset + titleOffset;
    CGFloat w = CGRectGetWidth([buttons.firstObject superview].frame);
    maxw = fminf(w - 40, maxw);
    
    for ( UIButton *btn in buttons )
    {
        CGRect r = btn.frame;
        r.size.width = maxw;
        r.origin.x = (w - maxw) * 0.5f;
        btn.frame = r;
    }
}

- (void)adjustFontSizeToFit
{
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

- (UIEdgeInsets)tricolorImageCapInsets{
    return UIEdgeInsetsMake(0, 16, 0, 16);
}

- (void)tricolorBlue{
    [self setBackgroundImage:[[UIImage imageNamed:@"blue-button"] resizableImageWithCapInsets:self.tricolorImageCapInsets] forState:UIControlStateNormal];
    [self setBackgroundImage:[[UIImage imageNamed:@"disabled-button"] resizableImageWithCapInsets:self.tricolorImageCapInsets] forState:UIControlStateDisabled];
    [self tricolorFontAndColor];
}

- (void)tricolorGray{
    [self setBackgroundImage:[[UIImage imageNamed:@"gray-button"] resizableImageWithCapInsets:self.tricolorImageCapInsets] forState:UIControlStateNormal];
    [self tricolorFont];
    [self setTitleColor:UIColor.tabBarItemTextColor forState:UIControlStateNormal];
}

- (void)tricolorClear{
    [self setBackgroundImage:[[UIImage imageNamed:@"demo-button"] resizableImageWithCapInsets:self.tricolorImageCapInsets] forState:UIControlStateNormal];
    [self tricolorFontAndColor];
}

- (void)tricolorCamName{
    [self setBackgroundImage:[[UIImage imageNamed:@"cam-name-btn"] resizableImageWithCapInsets:self.tricolorImageCapInsets] forState:UIControlStateNormal];
    [self tricolorFont];
    [self setTitleColor:UIColor.color111_127_133 forState:UIControlStateNormal];
}

- (void)tricolorFont{
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
}

- (void)tricolorFontAndColor{
    [self tricolorFont];
    [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self setTitleColor:UIColor.colorFieldImageTint forState:UIControlStateDisabled];
}

@end
