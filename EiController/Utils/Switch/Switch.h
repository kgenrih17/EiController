//
//  Switch.h
//  SwitchProject
//
//  Created by Genrih Korenujenko on 24.05.18.
//  Copyright © 2018 Koreniuzhenko Henrikh. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface Switch : UIControl

@property (nonatomic, readwrite, strong) UIView *thumbView;
@property (nonatomic, readwrite, strong) UILabel *leftLabel;
@property (nonatomic, readwrite, strong) UILabel *rightLabel;
@property (nonatomic, readwrite, strong) UIImageView *leftImageView;
@property (nonatomic, readwrite, strong) UIImageView *rightImageView;
@property (nonatomic, readwrite, strong) UIView *lineView;
///
@property (nonatomic, readwrite, strong) IBInspectable NSString *titleOn;
@property (nonatomic, readwrite, strong) IBInspectable UIColor *titleOnColor;
@property (nonatomic, readwrite, strong) IBInspectable NSString *titleOff;
@property (nonatomic, readwrite, strong) IBInspectable UIColor *titleOffColor;
///
@property (nonatomic, readwrite, strong) IBInspectable UIImage *leftOnImage;
@property (nonatomic, readwrite, strong) IBInspectable UIImage *leftOffImage;
@property (nonatomic, readwrite, strong) IBInspectable UIImage *rightOnImage;
@property (nonatomic, readwrite, strong) IBInspectable UIImage *rightOffImage;
///
@property (nonatomic, readwrite, strong) IBInspectable UIColor *onThumbColor;
@property (nonatomic, readwrite, strong) IBInspectable UIColor *offThumbColor;
@property (nonatomic, readwrite, strong) IBInspectable UIColor *onBackgroundColor;
@property (nonatomic, readwrite, strong) IBInspectable UIColor *offBackgroundColor;
@property (nonatomic, readwrite, strong) IBInspectable UIColor *lineColor;

@property (nonatomic, readwrite) IBInspectable BOOL isEnable;
@property (nonatomic, readwrite) IBInspectable BOOL isOn;

-(void)layoutThumb;
-(void)refresh;
-(void)setup;

@end
