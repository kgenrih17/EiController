//
//  UIView+Corners.m
//  ASEnterprise
//
//  Created by Genrih Korenujenko on 06.10.17.
//  Copyright © 2017 Evogence. All rights reserved.
//

#import "UIView+Corners.h"

@implementation UIView (Corners)


-(void)maskCorners:(NSArray<NSNumber*>*)corners toDepth:(CGFloat)depth
{
    [self maskCorners:corners toDepth:depth borderColor:nil borderWidth:0];
}

-(void)maskCorners:(NSArray<NSNumber*>*)corners toDepth:(CGFloat)depth borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth
{
    CGFloat s = 1 + 2 * depth;
    
    UIBezierPath *path = [UIBezierPath new];
    
    if ([corners containsObject:@(UIViewContentModeTopLeft)])
    {
        [path moveToPoint:CGPointMake(0, depth)];
        [path addLineToPoint:CGPointMake(depth, 0)];
    }
    else
        [path moveToPoint:CGPointMake(0, 0)];
    
    if ([corners containsObject:@(UIViewContentModeTopRight)])
    {
        [path addLineToPoint:CGPointMake(s - depth, 0)];
        [path addLineToPoint:CGPointMake(s, depth)];
    }
    else
        [path addLineToPoint:CGPointMake(s, 0)];
    
    if ([corners containsObject:@(UIViewContentModeBottomRight)])
    {
        [path addLineToPoint:CGPointMake(s, s - depth)];
        [path addLineToPoint:CGPointMake(s - depth, s)];
    }
    else
        [path addLineToPoint:CGPointMake(s, s)];
    
    if ([corners containsObject:@(UIViewContentModeBottomLeft)])
    {
        [path addLineToPoint:CGPointMake(depth, s)];
        [path addLineToPoint:CGPointMake(0, s - depth)];
    }
    else
        [path addLineToPoint:CGPointMake(0, s)];
    
    [path closePath];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    
    self.layer.mask = maskLayer;
    
    if (borderColor != nil)
    {
        CAShapeLayer *frameLayer = [CAShapeLayer layer];
        frameLayer.frame = self.bounds;
        frameLayer.path = path.CGPath;
        frameLayer.strokeColor = [UIColor redColor].CGColor;
        frameLayer.lineWidth = 2;
        frameLayer.fillColor = nil;
        
        [self.layer addSublayer:frameLayer];
    }
}

@end
