//
//  PopupView.m
//  EiController
//
//  Created by admin on 2/15/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import "PopupView.h"

@interface PopupView ()
{
    BOOL isShowed;
    UIView *parentView;
    PopupViewHideCompl completion;
    IBOutlet UIImageView *transparentBg;
    IBOutlet UIDatePicker *aDatePicker;
    IBOutlet NSLayoutConstraint *datePickerUpConstraint;
}
@end

@implementation PopupView

-(void)viewDidLoad
{
    [super viewDidLoad];
    aDatePicker.locale = [NSLocale currentLocale];
    aDatePicker.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
}

-(BOOL)isShow
{
    return isShowed;
}

-(void)setParentView:(UIView *)_parentView
{
    parentView = _parentView;
}

-(void)show:(NSDate*)date
{
    if (!isShowed)
    {
        isShowed = YES;
        [aDatePicker setDate:date];
        transparentBg.alpha = 0.0f;
        [self.navigation showView:self.view];
        [self.view setNeedsLayout];
        datePickerUpConstraint.active = NO;
        [UIView animateWithDuration:0.3 animations:^
        {
            [self.view layoutIfNeeded];
            transparentBg.alpha = 0.6f;
        }];
    }
}

-(void)closeCompletion:(PopupViewHideCompl)_completion
{
    completion = _completion;
}

-(IBAction)hide
{
    if (isShowed)
    {
        isShowed = NO;
        [self.view setNeedsLayout];
        datePickerUpConstraint.active = YES;
        [UIView animateWithDuration:0.3 animations:^
        {
            [self.view layoutIfNeeded];
            transparentBg.alpha = 0.3f;
        }
        completion:^(BOOL finished)
        {
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
        }];
    }
}

-(IBAction)done
{
    if (completion)
        completion(aDatePicker.date);
    [self hide];
}

@end
