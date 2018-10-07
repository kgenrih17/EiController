//
//  UIView+Corners.h
//  ASEnterprise
//
//  Created by Genrih Korenujenko on 06.10.17.
//  Copyright © 2017 Evogence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Corners)

-(void)maskCorners:(NSArray<NSNumber*>*)corners toDepth:(CGFloat)depth;
-(void)maskCorners:(NSArray<NSNumber*>*)corners toDepth:(CGFloat)depth borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth;

@end
