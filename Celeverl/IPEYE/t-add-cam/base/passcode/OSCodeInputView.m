//
//  OSCodeInputView.m
//  Oparator
//
//  Created by Roman Solodyashkin on 2/18/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import "OSCodeInputView.h"
#import "UIColor+OSExt.h"

NSString* const OSC_EMPTY_SYM = @"_";

@interface OSCodeInputView (){
    NSMutableArray *symbolsToDraw;
    NSDictionary *symbolsDrawAttributes;
    NSDictionary *symbolsDrawAttributesError;
}
@end

@implementation OSCodeInputView
@synthesize code = _code;
@synthesize codeLength = _codeLength;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if ( self ){
        [self setup];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setup{
    UIFont *font;
    if (@available(iOS 12, *)){
        font = [UIFont monospacedDigitSystemFontOfSize:22 weight:UIFontWeightRegular];
    }
    else{
        font = [UIFont systemFontOfSize:22];
    }
    symbolsDrawAttributes = @{NSFontAttributeName:font,
                              NSForegroundColorAttributeName:[UIColor color88],
    };
    symbolsDrawAttributesError = @{NSFontAttributeName:font,
                                   NSForegroundColorAttributeName:[UIColor colorErrorFieldText],
    };
    self.userInteractionEnabled = YES;
    self.backgroundColor = UIColor.whiteColor;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx){
        return;
    }
    CGContextSetFillColorWithColor(ctx, UIColor.clearColor.CGColor);
    CGContextFillRect(ctx, self.bounds);
    CGPoint pos = CGPointZero;
    NSDictionary *attrs = self.errorFlag ? symbolsDrawAttributesError : symbolsDrawAttributes;
    for (NSString *sym in symbolsToDraw){
        NSAttributedString *astr;
        if ([sym isEqualToString:OSC_EMPTY_SYM]){
            astr = [[NSAttributedString alloc] initWithString:sym attributes:attrs];
        }
        else{
            astr = [[NSAttributedString alloc] initWithString:@"*" attributes:attrs];
        }
        if (0 == pos.x){
            pos.x = (self.bounds.size.width - astr.size.width * (_codeLength * 2 - 1)) * 0.5;
        }
        pos.y = (self.bounds.size.height - astr.size.height) * 0.5;
        [astr drawAtPoint:pos];
        pos.x += astr.size.width * 2;
    }
}

- (void)setErrorFlag:(BOOL)errorFlag{
    _errorFlag = errorFlag;
    [self setNeedsDisplay];
}

#pragma mark- <UIKeyInput>
- (BOOL)hasText{
    return self.code.length > 0;
}

- (UITextContentType)textContentType{
    if (@available(iOS 12, *)){
        return UITextContentTypeOneTimeCode;
    }
    else{
        return nil;
    }
}

- (UIKeyboardAppearance)keyboardAppearance{
    return UIKeyboardAppearanceLight;
}

- (void)insertText:(NSString *)text{
    if (self.code.length < _codeLength){
        if (!self.code)
            self.code = @"";
        self.code = [self.code stringByAppendingString:text];
    }
}

- (void)deleteBackward{
    if (self.hasText){
        self.code = [self.code stringByReplacingCharactersInRange:NSMakeRange(self.code.length - 1, 1) withString:@""];
    }
}

- (UIKeyboardType)keyboardType{
    return UIKeyboardTypeNumberPad;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)tap:(UITapGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded){
        [self becomeFirstResponder];
    }
}

#pragma mark- props
- (void)setCode:(NSString *)code{
    if (![code isEqualToString:_code]){
        _code = code;
        for (NSInteger idx = 0; idx < _code.length; idx++){
            NSString *s = [_code substringWithRange:NSMakeRange(idx, 1)];
            symbolsToDraw[idx] = s;
        }
        for ( NSInteger idx = _code.length; idx < _codeLength; idx++ ){
            symbolsToDraw[idx] = OSC_EMPTY_SYM;
        }
        [self setNeedsDisplay];
        if (_code.length == _codeLength){
            [self.delegate codeCompleted:_code];
        }
        else{
            [self.delegate codeChanged:_code];
        }
    }
}

- (NSString*)code{
    if (!_code)
        return @"";
    return _code;
}

- (void)setCodeLength:(NSInteger)codeLength{
    if (_codeLength != codeLength){
        _codeLength = codeLength;
        symbolsToDraw = [[NSMutableArray alloc] initWithCapacity:_codeLength];
        self.code = _code;
    }
}

- (NSInteger)codeLength{
    return _codeLength;
}

@end
