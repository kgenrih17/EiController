//
//  AboutView.m
//  EiController
//
//  Created by Genrih Korenujenko on 26.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "AboutView.h"

@interface AboutView ()

@property (nonatomic, readwrite, weak) IBOutlet UILabel *companyLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *urlLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *versionLabel;

@end

@implementation AboutView

#pragma mark - Public Init Methods
+(instancetype)aboutEvogenceWithVersion:(NSString*)version
{
    return [self aboutWithCompany:@"Copyright (c) 2009 - 2017 Evogence" url:@"http://www.evogence.com" version:version];
}

+(instancetype)aboutWithCompany:(NSString*)company url:(NSString*)url version:(NSString*)version
{
    AboutView *aboutView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    aboutView.companyLabel.text = company;
    aboutView.urlLabel.attributedText = [self convertToAttributedURL:url];
    aboutView.versionLabel.attributedText = [self convertToAttributedVersion:version];
    return aboutView;
}

#pragma mark - Private Methods
+(NSAttributedString*)convertToAttributedURL:(NSString*)string
{
    UIFont *font = [UIFont systemFontOfSize:14.0];
    UIColor *color = [UIColor colorWithRed:0.306 green:0.576 blue:0.8 alpha:1];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute setAttributes:@{NSForegroundColorAttributeName:color,
                               NSFontAttributeName:font,
                               NSUnderlineStyleAttributeName:@(1)}
                       range:NSMakeRange(0, string.length)];
    return attribute;
}

+(NSAttributedString*)convertToAttributedVersion:(NSString*)string
{
    NSString *version = @"Version: ";
    NSString *fullString = [NSString stringWithFormat:@"%@ %@", version, string];
    UIFont *font = [UIFont systemFontOfSize:14.0];
    UIColor *versionColor = [UIColor colorWithRed:0.486 green:0.506 blue:0.549 alpha:1];
    UIColor *stringColor = [UIColor blackColor];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:fullString
                                                                                 attributes:@{NSFontAttributeName:font}];
    [attribute setAttributes:@{NSForegroundColorAttributeName:versionColor,
                               NSFontAttributeName:font}
                       range:[fullString rangeOfString:version]];
    [attribute addAttribute:NSForegroundColorAttributeName
                      value:stringColor
                      range:[fullString rangeOfString:string]];
    return attribute;
}

#pragma mark - Action Methods
-(IBAction)close
{
    [self removeFromSuperview];
}

@end
