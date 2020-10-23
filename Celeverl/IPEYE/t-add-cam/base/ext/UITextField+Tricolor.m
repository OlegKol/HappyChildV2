//
//  UITextField+Tricolor.m
//  Триколор
//
//  Created by Roman Solodyashkin on 25.10.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "UITextField+Tricolor.h"

@implementation UITextField (Tricolor)
- (void)tricolorUpdatePlaceholder:(NSString*)placeholder
{
    self.textColor = [UIColor colorWithWhite:0.341f alpha:1];
    NSAttributedString *astr =
    [[NSAttributedString alloc] initWithString:placeholder
                                    attributes:@{NSFontAttributeName:self.font,
                                                 NSForegroundColorAttributeName:[UIColor colorWithWhite:0.784f alpha:1]
                                    }];
    self.attributedPlaceholder = astr;
}
@end
