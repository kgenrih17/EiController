//
//  SimpleTabTitleView.h
//  ASEnterprise
//
//  Created by Genrih Korenujenko on 22.12.16.
//  Copyright © 2016 Evogence. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface SimpleTabTitleView : UIView
{
    IBOutlet UIView *bottomLineView;
    
    UIImage *image;
    NSString *title;
    BOOL isSelected;
}

@property (nonatomic, readwrite) IBOutlet UIButton *titleButton;

@property (nonatomic, readwrite) IBInspectable UIColor *buttonTextSelectedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *buttonTextUnselectedColor;

@property (nonatomic, readwrite) IBInspectable UIColor *buttonBackgoundSelectedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *buttonBackgoundUnselectedColor;

@property (nonatomic, readwrite) IBInspectable UIColor *bottomLineSelectedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *bottomLineUnselectedColor;

-(instancetype)initWithNib;

-(void)setSelected:(BOOL)_isSelected image:(UIImage*)_image title:(NSString*)_title;
-(BOOL)isSelected;

-(void)refreshGUI;

@end
