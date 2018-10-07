//
//  CentralSyncProgressView.m
//  EiController
//
//  Created by Genrih Korenujenko on 23.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "CentralSyncProgressView.h"

#import "EiController-Swift.h"

@interface CentralSyncProgressView ()
{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *subtitleLabel;
    __weak IBOutlet UILabel *percentLabel;
    __weak IBOutlet UIView *progressBackgroudView;
    __weak IBOutlet UIImageView *progressImageView;
    __weak IBOutlet UIButton *closeButton;
    IBOutlet NSLayoutConstraint *progressWidthConstraint;
    
    id<CentralSyncProgressViewActionInterface> actionInterface;
}

-(void)setActionInterface:(id<CentralSyncProgressViewActionInterface>)actionInterface;

@end

@implementation CentralSyncProgressView

#pragma mark - Public Init Methods
+(instancetype)progressWithActionInterface:(id<CentralSyncProgressViewActionInterface>)interface
                                     model:(CentralSyncProgressViewModel*)model
{
    CentralSyncProgressView *result = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    if (result)
    {
        [result setActionInterface:interface];
        [result load:model];
    }
    return result;
}

#pragma mark - Override Methods
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.superview != nil)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [[self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor] setActive:YES];
        [[self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor] setActive:YES];
        [[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor] setActive:YES];
        [[self.heightAnchor constraintEqualToConstant:67] setActive:YES];
    }
}

#pragma mark - Public Methods
-(void)load:(CentralSyncProgressViewModel*)viewMode
{
    BOOL isSuccessful = [viewMode isSuccessful];
    titleLabel.text = viewMode.title;
    [closeButton changeEnable:viewMode.isCompleted];
    percentLabel.hidden = !isSuccessful;
    progressBackgroudView.hidden = !isSuccessful;
    if (isSuccessful)
    {
        titleLabel.textColor = [UIColor whiteColor];
        subtitleLabel.text = viewMode.subtitle;
        percentLabel.text = [NSString stringWithFormat:@"%.0f%%", viewMode.percent];
        [self drawProgress:viewMode.percent];
        progressImageView.image = [viewMode getProgressImage];
    }
    else
    {
        titleLabel.textColor = [UIColor colorWithRed:0.965 green:0.549 blue:0.588 alpha:1];
        subtitleLabel.text = viewMode.error;
    }
}

-(void)drawProgress:(CGFloat)percent
{
    CGFloat allWidth = CGRectGetWidth(progressBackgroudView.frame);
    CGFloat width = percent * (allWidth / 100.0);
    
    if (width > 0 && width <= allWidth)
    {
        [self setNeedsLayout];
        progressWidthConstraint.constant = width;
        [UIView animateWithDuration:0.2 animations:^
        {
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark - Action Methods
-(IBAction)close
{
    [self removeFromSuperview];
    [actionInterface closeCentralSyncProgressView];
    actionInterface = nil;
}

#pragma mark - Private Methods
-(void)setActionInterface:(id<CentralSyncProgressViewActionInterface>)interface
{
    actionInterface = interface;
}

@end
