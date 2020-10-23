//
//  UIColor+OSExt.m
//  2Me
//
//  Created by Roman Solodyashkin on 6/15/16.
//  Copyright © 2016 IoStream. All rights reserved.
//

#import "UIColor+OSExt.h"

@implementation UIColor (OSExt)
- (instancetype)pastelColor
{
    UIColor *res;
    CGFloat h, s, b, a;
    if ( YES == [self getHue:&h saturation:&s brightness:&b alpha:&a] )
    {
        res = [UIColor colorWithHue:h
                         saturation:s
                         brightness:MIN(b * 1.3, 1.0)
                              alpha:a];
    }
    else
    {
        res = self;
    }
    return res;
}

+ (UIColor*)color25
{
    return [UIColor colorWithRed:25/255.f green:26/255.f blue:27/255.f alpha:1];
}

+ (UIColor*)color45
{
    return [UIColor colorWithRed:45/255.f green:46/255.f blue:47/255.f alpha:1];
}

+ (UIColor*)colorText54
{
    return [UIColor colorWithRed:54/255.f green:54/255.f blue:54/255.f alpha:1];
}

+ (UIColor*)color66
{
    return [UIColor colorWithRed:66/255.f green:66/255.f blue:66/255.f alpha:1];
}

+ (UIColor*)color76
{
    return [UIColor colorWithRed:76/255.f green:77/255.f blue:78/255.f alpha:1];
}

+ (UIColor*)color88{
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65f];
}

+ (UIColor*)colorErrorFieldText{
    return [UIColor colorWithRed:1 green:110/255.f blue:106/255.f alpha:1];
}

+ (UIColor*)colorErrorFieldBackgound{
    return [UIColor colorWithRed:1 green:234/255.f blue:231/255.f alpha:1];
}

+ (UIColor*)colorErrorFieldBorder{
    return [UIColor colorWithRed:239/255.f green:193/255.f blue:188/255.f alpha:1];
}

+ (UIColor*)colorFieldBorder{
    return [UIColor colorWithRed:219/255.f green:223/255.f blue:225/255.f alpha:1];
}

+ (UIColor*)colorFieldImageTint{
    return [UIColor colorWithRed:219/255.f green:224/255.f blue:226/255.f alpha:1];
}

+ (UIColor*)color96{
    return [UIColor colorWithRed:96/255.f green:96/255.f blue:96/255.f alpha:1];
}

+ (UIColor*)color99
{
    return [UIColor colorWithRed:99/255.f green:99/255.f blue:99/255.f alpha:1];
}

+ (UIColor*)color150
{
    return [UIColor colorWithRed:150/255.f green:150/255.f blue:150/255.f alpha:1];
}

+ (UIColor*)color189
{
    return [UIColor colorWithRed:189/255.f green:189/255.f blue:189/255.f alpha:1];
}

+ (UIColor*)color219_224_226{
    return [UIColor colorWithRed:219/255.f green:224/255.f blue:226/255.f alpha:1];
}

+ (UIColor*)color247_251_252{
    return [UIColor colorWithRed:247/255.f green:251/255.f blue:252/255.f alpha:1];
}

+ (UIColor*)color255_176_0{
    return [UIColor colorWithRed:255/255.f green:176/255.f blue:0/255.f alpha:1];
}

+ (UIColor*)color111_127_133{
    return [UIColor colorWithRed:111/255.f green:127/255.f blue:133/255.f alpha:1];
}

+ (UIColor*)cellSeparatorColor
{
    return [UIColor colorWithRed:69/255. green:70/255. blue:71/255. alpha:1];
}

+ (UIColor*)controlBlueColor
{
    return [UIColor colorWithRed:0 green:122/255. blue:1 alpha:1];
}

#pragma mark- nav
+ (UIColor*)navBarTextColor
{
    return [UIColor lightGrayColor];
}

#pragma mark- tab
+ (UIColor*)tabBarItemTextColor
{
    return [UIColor colorWithRed:111/255.f green:127/255.f blue:133/255.f alpha:1];
}

+ (UIColor*)tabBarItemSelectedTextColor
{
    return [UIColor colorWithRed:0 green:177/255.f blue:1 alpha:1];
}

+ (UIColor*)tricolorBlackTextColor{
    return [UIColor.blackColor colorWithAlphaComponent:0.65f];
}

+ (UIColor*)tabBarItemImageColor
{
    return [UIColor tabBarItemTextColor];
}

+ (UIColor*)tabBarItemSelectedImageColor
{
    return [UIColor tabBarItemSelectedTextColor];
}

+ (UIColor*)mainYellow{
    return [UIColor colorWithRed:1 green:176/255.f blue:0 alpha:1];
}

#pragma mark- table
+ (UIColor*)tableBackgroundColor
{
    return [UIColor colorWithRed:247/255.f green:251/255.f blue:252/255.f alpha:1];
}

+ (UIColor*)tableCellTextBackgroundColor
{
    return [UIColor color25];
}

+ (UIColor*)tableCellTextColor
{
    return [UIColor whiteColor];
}

+ (UIColor*)tableCellDescriptionTextColor
{
    return [UIColor lightGrayColor];
}

+ (UIColor*)tableCellSelectedDescriptionTextColor
{
    return [UIColor darkGrayColor];
}

#pragma mark- menu
+ (UIColor*)menuTextColor
{
    return [UIColor whiteColor];
}

+ (UIColor*)menuSelectedTextColor
{
    return [UIColor tricolorBlackTextColor];
}

+ (UIColor*)menuBackgroundColor
{
    return [UIColor color45];
}

+ (UIColor*)menuSelectedBackgroundColor
{
    return [UIColor color247_251_252];
}

#pragma mark- calendar
+ (UIColor*)calendarTopBackgroundColor
{
    return [UIColor color247_251_252];
}

+ (UIColor*)calendarCellsBackgroundColor
{
    return [UIColor whiteColor];
}

+ (UIColor*)calendarCellsSeparatorColor
{
    return [UIColor whiteColor];
}

+ (UIColor*)calendarWeakDaysTextColor
{
    return [UIColor clearColor];
}

+ (UIColor*)calendarCurrentDayBackgroundColor
{
    return [UIColor mainBlue];
}

+ (UIColor*)calendarCurrentMonthTextColor
{
    return [UIColor tricolorBlackTextColor];
}

+ (UIColor*)calendarCurrentDayTextColor
{
    return [UIColor whiteColor];
}

+ (UIColor*)calendarOtherMonthTextColor
{
    return [UIColor lightGrayColor];
}

+ (UIColor*)calendarDotWathedColor
{
    return [UIColor color111_127_133];
}

+ (UIColor*)calendarDotUnwathedColor
{
    return [UIColor color111_127_133];
}

+ (UIColor*)calendarButtonBackgroundColor
{
    return [UIColor color99];
}

+ (UIColor*)calendarButtonDayTextColor
{
    return [UIColor lightGrayColor];
}

#pragma mark- buttons
+ (UIColor*)mainBlue
{
    //return [UIColor colorWithRed:1/255. green:155/255. blue:1 alpha:1];
    return [UIColor colorWithRed:0 green:176/255. blue:1 alpha:1];
}

+ (UIColor*)mainButtonColor
{
    return [UIColor color45];
}

+ (UIColor*)menuRedTitle{
    return [UIColor colorWithRed:1 green:25/255.f blue:30/255.f alpha:1];
}

+ (UIColor*)ptzButtonBackgroundColor
{
    return [UIColor colorWithRed:236/255. green:236/255. blue:236/255. alpha:1];
}

+ (UIColor*)ptzButtonSelectedBackgroundColor
{
    return [UIColor controlBlueColor];
}

+ (UIColor*)ptzButtonInnerColor
{
    return [UIColor colorWithRed:69/255. green:70/255. blue:71/255. alpha:1];
}

+ (UIColor*)ptzButtonSelectedInnerColor
{
    return [UIColor whiteColor];
}

#pragma mark- timeline
+ (UIColor*)timelineBackgroundColor
{
    return [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1];
}

+ (UIColor*)timelineBackgroundLinesColor
{
    return [[UIColor color111_127_133] colorWithAlphaComponent:0.1f];
}

+ (UIColor*)timelineCursorColor
{
    return [UIColor color76];
}

+ (UIColor*)timelineAttentionColor
{
    return [UIColor colorWithRed:230/255.f green:60/255.f blue:0 alpha:1];
}

+ (UIColor*)timelineMarksColor
{
    return [UIColor color111_127_133];
}

+ (UIColor*)timelineMarksBackgroundColor
{
    return [UIColor color45];
}

+ (UIColor*)timelineArchiveSectorColor
{
    return [UIColor mainYellow];
}

+ (UIColor*)timelineDayJumpTopBackgroundColor
{
    return [UIColor color219_224_226];
}

+ (UIColor*)timelineDayJumpBottomBackgroundColor
{
    return [UIColor color219_224_226];
}

+ (UIColor*)timelineDayJumpActiveBackgroundColor
{
    return [UIColor mainBlue];
}

+ (UIColor*)timelineDayJumpTextColor
{
    return [UIColor whiteColor];
}

@end
