//
//  UIView+Field.m
//  Testproject
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import "UIView+Field.h"

@implementation UIView (Field)

@dynamic borderColor,borderWidth, cornerRadius, clipsToBoundsAddition;

-(void)setBorderColor:(UIColor *)borderColor
{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    [self.layer setCornerRadius:cornerRadius];
}

-(void)setClipsToBoundsAddition:(BOOL)clipsToBoundsAddition
{
    [self setClipsToBounds:clipsToBoundsAddition];
}

@end
