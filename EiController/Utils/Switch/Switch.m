//
//  Switch.m
//  SwitchProject
//
//  Created by Genrih Korenujenko on 24.05.18.
//  Copyright © 2018 Koreniuzhenko Henrikh. All rights reserved.
//

#import "Switch.h"
#import "EiController-Swift.h"

@implementation Switch

@synthesize leftImageView, rightImageView, thumbView, lineView;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self setup];
    return self;
}

-(instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self setup];
    return self;
}

-(void)didMoveToSuperview
{
    [self fillDefaultGradients];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.0;
    lineView.layer.cornerRadius = 2.0;
    [self layoutThumb];
    lineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) / 2.0 - 1.5, CGRectGetWidth(self.bounds), 3);
    [self refresh];
    [self refreshState];
}

-(void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    [self animation:NO];
}

-(void)setIsEnable:(BOOL)isEnable
{
    _isEnable = isEnable;
    [self animation:NO];
}

-(void)touch:(UITapGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateEnded && self.isEnable)
    {
        _isOn = !self.isOn;
        [self animation:YES];
    }
}

-(void)animation:(BOOL)isAnimation
{
    if (isAnimation)
    {
        [UIView animateWithDuration:0.15 animations:^
        {
            [self layoutThumb];
            [self refresh];
            [self refreshState];
        } completion:^(BOOL finished)
        {
            [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        }];
    }
    else
    {
        [self layoutThumb];
        [self refresh];
        [self refreshState];
    }
}

-(void)layoutThumb
{
    CGFloat height = CGRectGetHeight(self.bounds);
    if (self.isOn)
    {
        thumbView.frame = CGRectMake(CGRectGetWidth(self.bounds) - height, 0, height, height);
    }
    else
    {
        thumbView.frame = CGRectMake(0, 0, height, height);
    }
    CGFloat thumbIndent = 3;
    thumbView.frame = CGRectInset(thumbView.frame, thumbIndent, thumbIndent);
    leftImageView.frame = CGRectInset(CGRectMake(0, 0, height, height), thumbIndent * 3, thumbIndent * 3);
    rightImageView.frame = CGRectInset(CGRectMake(CGRectGetWidth(self.bounds) - height, 0, height, height), thumbIndent * 3, thumbIndent * 3);
}

-(void)refresh
{
    if (self.isEnable)
    {
        if (self.isOn)
        {
            leftImageView.image = self.leftOnImage;
            rightImageView.image = self.rightOnImage;
            self.leftLabel.text = self.titleOn;
            self.leftLabel.textColor = self.titleOnColor;
            self.rightLabel.text = @"";
        }
        else
        {
            leftImageView.image = self.leftOffImage;
            rightImageView.image = self.rightOffImage;
            self.leftLabel.text = @"";
            self.rightLabel.text = self.titleOff;
            self.rightLabel.textColor = self.titleOffColor;
        }
    }
    else
    {
        thumbView.backgroundColor = [UIColor clearColor];
        lineView.backgroundColor = [UIColor clearColor];
    }
}

-(void)setup
{
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat thumbIndent = 3;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1.5, CGRectGetWidth(self.bounds), 3)];
    [self addSubview:lineView];
    thumbView = [[UIView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, height, height), thumbIndent, thumbIndent)];
    thumbView.layer.masksToBounds = YES;
    [self addSubview:thumbView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch:)];
    [self addGestureRecognizer:tap];
    leftImageView = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, height, height), thumbIndent * 3, thumbIndent * 3)];
    leftImageView.backgroundColor = [UIColor clearColor];
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:leftImageView];
    rightImageView = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(CGRectGetWidth(self.bounds) - height, 0, height, height), thumbIndent * 3, thumbIndent * 3)];
    rightImageView.backgroundColor = [UIColor clearColor];
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:rightImageView];

    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(self.bounds) - height, height), thumbIndent, thumbIndent)];
    self.leftLabel.backgroundColor = [UIColor clearColor];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.leftLabel.textColor = [UIColor whiteColor];
    self.leftLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.leftLabel];

    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(height, 0, CGRectGetWidth(self.bounds) - height, height), thumbIndent, thumbIndent)];
    self.rightLabel.backgroundColor = [UIColor clearColor];
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.textColor = [UIColor whiteColor];
    self.rightLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.rightLabel];

    self.onThumbColor = [UIColor whiteColor];
    self.offThumbColor = [UIColor whiteColor];
    self.onBackgroundColor = [UIColor clearColor];
    self.offBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    self.lineColor = [UIColor clearColor];
    self.isOn = NO;
    self.isEnable = YES;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
}

@end
