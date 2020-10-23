//
//  TTextFieldContainer.h
//  Триколор
//
//  Created by Roman Solodyashkin on 13.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCodeInputView;

NS_ASSUME_NONNULL_BEGIN

@interface TTextFieldContainer : UIView
@property (nonatomic, weak) IBOutlet UIView *topSeparator;
@property (nonatomic, weak) IBOutlet UIView *bottomSeparator;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet OSCodeInputView *codeInputView;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, assign) BOOL errorFlag;
@property (nonatomic, strong, nullable) NSString *errorDescription;
@end

NS_ASSUME_NONNULL_END
