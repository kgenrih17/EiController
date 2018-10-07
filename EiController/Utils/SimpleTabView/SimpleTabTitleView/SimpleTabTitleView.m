//
//  SimpleTabTitleView.m
//  ASEnterprise
//
//  Created by Genrih Korenujenko on 22.12.16.
//  Copyright © 2016 Evogence. All rights reserved.
//

#import "SimpleTabTitleView.h"

@implementation SimpleTabTitleView

#pragma mark - Init
-(instancetype)initWithNib
{
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil].firstObject;
    
    return self;
}

#pragma mark - Public Methods
-(void)setSelected:(BOOL)_isSelected image:(UIImage*)_image title:(NSString*)_title
{
    image = _image;
    title = _title;
    isSelected = _isSelected;
    
    [self.titleButton setImage:image forState:UIControlStateNormal];
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    
    self.titleButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self refreshGUI];
}

-(BOOL)isSelected
{
    return isSelected;
}

-(void)refreshGUI
{
    self.titleButton.selected = isSelected;
    bottomLineView.hidden = !isSelected;
    
    if (self.buttonTextSelectedColor)
        [self.titleButton setTitleColor:self.buttonTextSelectedColor forState:UIControlStateSelected];
    
    if (self.buttonTextUnselectedColor)
        [self.titleButton setTitleColor:self.buttonTextUnselectedColor forState:UIControlStateNormal];
    
    if (isSelected)
    {
        if (self.buttonBackgoundSelectedColor)
            [self.titleButton setBackgroundColor:self.buttonBackgoundSelectedColor];
        
        if (self.bottomLineSelectedColor)
            [bottomLineView setBackgroundColor:self.bottomLineSelectedColor];
    }
    else
    {
        if (self.buttonBackgoundUnselectedColor)
            [self.titleButton setBackgroundColor:self.buttonBackgoundUnselectedColor];
        
        if (self.bottomLineUnselectedColor)
            [bottomLineView setBackgroundColor:self.bottomLineUnselectedColor];
    }
}

@end
