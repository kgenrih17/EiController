//
//  UIView+Field.h
//  Testproject
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIView (Field)

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable BOOL clipsToBoundsAddition;

@end
