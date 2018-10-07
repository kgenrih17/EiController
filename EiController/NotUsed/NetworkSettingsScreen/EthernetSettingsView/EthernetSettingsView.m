//
//  EthernetSettingsView.m
//  EiController
//
//  Created by admin on 8/17/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import "EthernetSettingsView.h"

@implementation EthernetSettingsView

#pragma mark - Init
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.frame = frame;
        ipdhcpSwt.transform = CGAffineTransformMakeScale(0.70, 0.65);
    }
    
    return self;
}

#pragma mark - Override Methods
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (ipSettingsView == nil)
    {
        ipSettingsView = [IPSettingsView build:self];
        [staticSettingsView addSubview:ipSettingsView];
    }
}

#pragma mark - IPSettingsViewListener
-(void)changedDNS
{
    settings.dns1 = [ipSettingsView getDNS1];
    settings.dns2 = [ipSettingsView getDNS2];
    settings.dns3 = [ipSettingsView getDNS3];
}

#pragma mark - Public Methods
-(void)load:(NetworkSettings*)newSettings
{
    settings = newSettings;
    ipdhcpSwt.on = settings.ipdhcp;
    [self editingEnable:ipdhcpSwt.isOn];
    [ipSettingsView load:settings.ethernetIP dns1:settings.dns1 dns2:settings.dns2 dns3:settings.dns3];
}

-(BOOL)isFilledAllSettings
{
    BOOL result = ipdhcpSwt.on;
    if (!result)
        result = [ipSettingsView isFilled];
    return result;
}

-(void)updateSettings
{
    settings.ipdhcp = ipdhcpSwt.on;
    [ipSettingsView update];
}

#pragma mark - Action Methods
-(IBAction)switchDHCP:(UISwitch*)sender
{
    [self editingEnable:sender.isOn];
}

-(IBAction)hideKeyboard
{
    [self endEditing:YES];
}

#pragma mark - Private Methods
-(void)editingEnable:(BOOL)isEnable
{
    CGFloat alpha = isEnable ? 0.7f : 1.0f;
    staticSettingsView.alpha = alpha;
    staticSettingsView.userInteractionEnabled = !isEnable;
}

@end

