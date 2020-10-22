//
//  DotActivityIndicatorParms.m
//  MONActivityIndicatorViewDemo
//
//  Created by EhabAlsharkawy on 1/22/16.
//  Copyright © 2016 Moaner. All rights reserved.
//

#import "DotActivityIndicatorParms.h"

@implementation DotActivityIndicatorParms

-(instancetype)initWithDefaultData
{
    self = [super init];
    
    if (self)
    {
        [self validateData];
    }
    return self;
}

-(void)setIsDataValidationEnabled:(BOOL)isDataValidationEnabled
{
    _isDataValidationEnabled = isDataValidationEnabled;
    
    [self validateData];
}

- (void)validateData
{
    self.activityViewWidth = (self.activityViewWidth == 0) ? 70 : self.activityViewWidth;
    
    self.activityViewHeight = (self.activityViewHeight == 0) ? 70 : self.activityViewHeight;
    
    self.numberOfCircles = (self.numberOfCircles == 0) ? 3 : self.numberOfCircles;

    self.circleWidth = (self.activityViewWidth / self.numberOfCircles);
    
    self.internalSpacing = (self.internalSpacing == 0) ? 5 : self.internalSpacing;
    
    self.animationDelay = ( self.animationDelay == 0) ? 0.3 : self.animationDelay;
    
    self.animationDuration = (self.animationDuration == 0) ? 0.8 : self.animationDuration;
    
    self.animationFromValue = (self.animationFromValue == 0) ? 0.2 : self.animationFromValue;
    
    self.animationToValue = (self.animationToValue == 0) ? 1.0 : self.animationToValue;

//    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
//    if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"userInfo"]) {
//        self.defaultColor = ( self.defaultColor == nil ) ? [UIColor colorWithRed:182.0/255.0f green:38.0/255.0f blue:37.0/255.0f alpha:1.0]  : self.defaultColor;
//    } else {
//        self.defaultColor = ( self.defaultColor == nil ) ? [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1.0]  : self.defaultColor;
//    }
    self.defaultColor = ( self.defaultColor == nil ) ? [UIColor colorWithRed:255.0/255.0f green:202.0/255.0f blue:25.0/255.0f alpha:1.0]  : self.defaultColor;
}

@end
