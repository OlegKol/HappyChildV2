//
//  OSCodeInputView.h
//  Oparator
//
//  Created by Roman Solodyashkin on 2/18/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OSCodeInputViewDelegate <NSObject>
@required
- (void)codeChanged:(NSString*)code;
- (void)codeCompleted:(NSString*)code;
@end

@interface OSCodeInputView : UIView <UIKeyInput>
@property (nullable, readwrite, strong) UIView *inputAccessoryView;
@property (nonatomic, weak) IBOutlet id <OSCodeInputViewDelegate> delegate;
@property (nonatomic, strong, nullable) NSString *code;
@property (nonatomic, assign) NSInteger codeLength;
@property (nonatomic, assign) BOOL errorFlag;
@end

NS_ASSUME_NONNULL_END
