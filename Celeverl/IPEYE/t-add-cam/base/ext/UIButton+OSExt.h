//
//  UIButton+OSExt.h
//  Oparator
//
//  Created by Roman Solodyashkin on 2/29/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (OSExt)
+ (void)alignButtonsToMaxTitle:(NSArray*)buttons titleOffset:(CGFloat)titleOffset;
- (void)adjustFontSizeToFit;
- (void)tricolorBlue;
- (void)tricolorGray;
- (void)tricolorClear;
- (void)tricolorCamName;
@end
