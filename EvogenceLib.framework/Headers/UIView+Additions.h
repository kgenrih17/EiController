//
//  UIView+Additions.h
//

#import <Foundation/Foundation.h>

IB_DESIGNABLE

@interface UIView (Additions)

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable BOOL clipsToBoundsAddition;

@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGSize shadowOffset;

-(void)setYPos:(CGFloat)_y;
-(void)setXPos:(CGFloat)_x;
-(void)setWidth:(CGFloat)_width;
-(void)setHeight:(CGFloat)_height;

/* UIRectCorner:
 TL - Top Left     || 0 - NO      | 4 - BL           | 8 - BR            | 12 - BL + BR
 TR - Top Right    || 1 - TL      | 5 - BL + TL      | 9 - BR + TL       | 13 - BL + BR + TL
 BL - Bottom Left  || 2 - TR      | 6 - BL + TR      | 10 - BR + TR      | 14 - BL + BR + TR
 BR - Bottom Right || 3 - TL + TR | 7 - BL + TL + TR | 11 - BR + TL + TR | 15 - ALL
*/
-(void)setRounding:(UIRectCorner)rounding andRoundingRadius:(CGFloat)_radius;

@end
