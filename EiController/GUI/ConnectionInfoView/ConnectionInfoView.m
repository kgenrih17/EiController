//
//  ConnectionInfoView.m
//  EiController
//
//  Created by Genrih Korenujenko on 27.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ConnectionInfoView.h"

@interface ConnectionInfoView ()
{
    IBOutlet NSLayoutConstraint *addressWidthConstraint;
}

@property (nonatomic, readwrite, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *addressLabel;

@end

@implementation ConnectionInfoView

#pragma mark - Public Init Methods
+(instancetype)connectionInfo;
{
    ConnectionInfoView *result = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                             owner:self
                                                           options:nil].firstObject;
    return result;
}

#pragma mark - Public Methods
-(void)setAddress:(NSString*)address icon:(UIImage*)icon
{
    self.addressLabel.text = [NSString stringWithFormat:@"[Ei] Central: %@", address];
    self.iconImageView.image = icon;
    [self refreshConstraints];
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
        [[self.heightAnchor constraintEqualToConstant:20] setActive:YES];
    }
}

#pragma mark - Private Methods
-(void)refreshConstraints
{
    CGFloat indent = 16;
    CGFloat maxAddressWidth = CGRectGetWidth(self.superview.frame) - CGRectGetWidth(self.iconImageView.frame) - indent;
    CGRect rect = CGRectMake(indent / 2.0, CGRectGetMinY(self.addressLabel.frame), NSIntegerMax, CGRectGetHeight(self.addressLabel.frame));
    CGFloat textWidth = [self.addressLabel textRectForBounds:rect limitedToNumberOfLines:1].size.width;
    
    if (textWidth > maxAddressWidth)
    {
        addressWidthConstraint.constant = maxAddressWidth;
        addressWidthConstraint.active = YES;
    }
    else
        addressWidthConstraint.active = NO;
}

@end
