//
//  WiFiSettingsView.m
//  EiController
//
//  Created by admin on 8/17/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import "WiFiSettingsView.h"

@implementation WiFiSettingsView

#pragma mark - Init
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        self.frame = frame;
        wifiEnabledSwt.transform = CGAffineTransformMakeScale(0.70, 0.65);
        wifiPreferedSwt.transform = CGAffineTransformMakeScale(0.70, 0.65);
        ipDhcpSwt.transform = CGAffineTransformMakeScale(0.70, 0.65);
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
        [self prepareDropDownSelector];
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
-(void)load:(NetworkSettings*)newSettings protocols:(NSDictionary*)newProtocols selectedIndex:(NSInteger)selectedIndex
{
    settings = newSettings;
    protocols = newProtocols;
    wifiEnabledSwt.on = settings.wifiEnabled;
    wifiPreferedSwt.on = settings.wifiPreferred;
    ipDhcpSwt.on = settings.wifiIpdhcp1;
    ssidFld.text = settings.wifiSsid;
    authKeyFld.text = settings.wifiAuthKey;
    passwordFld.text = settings.wifiAuthPassword;
    [ipSettingsView load:settings.wifiIP dns1:settings.dns1 dns2:settings.dns2 dns3:settings.dns3];
    [dropDownSelector setItems:[protocols objectForKey:@"values"] selectedItem:selectedIndex];
    CGRect selectorFrame = protocolView.frame;
    selectorFrame.origin.y += CGRectGetMinY(settingsView.frame);
    dropDownSelector.frame = selectorFrame;
    [dropDownSelector recalculateSize];
    [self refreshEnableViews];
    [self refreshProtocolGUI];
}

-(BOOL)isFilledAllSettings
{
    BOOL result = wifiEnabledSwt.isOn ? NO : YES;
    if (!result)
    {
        result = (ssidFld.text.length > 0);
        if (result)
        {
            EWiFiSecurityProtocol securityProtocol = (EWiFiSecurityProtocol)dropDownSelector.selectedItemCell;
            if (securityProtocol == WEP_PROTOCOL || securityProtocol == WPA_PSK_PROTOCOL)
                result = (authKeyFld.text.length > 0);
            else if (securityProtocol == WPA_2_EAP_PROTOCOL)
                result = (authKeyFld.text.length > 0 && passwordFld.text.length > 0);
        }
        if (result && !ipDhcpSwt.on)
            result = [ipSettingsView isFilled];
    }
    return result;
}

-(void)updateSettings
{
    settings.wifiEnabled = wifiEnabledSwt.on;
    settings.wifiPreferred = wifiPreferedSwt.on;
    settings.wifiIpdhcp1 = ipDhcpSwt.on;
    settings.wifiSsid = ssidFld.text;
    [ipSettingsView update];
    NSString *authKey = @"";
    NSString *authIdentity = @"";
    NSString *authPassword = @"";
    switch ((EWiFiSecurityProtocol)dropDownSelector.selectedItemCell)
    {
        case WEP_PROTOCOL:
        case WPA_PSK_PROTOCOL:
        {
            authKey = authKeyFld.text;
        }
            break;
            
        case WPA_2_EAP_PROTOCOL:
        {
            authIdentity = authKeyFld.text;
            authPassword = passwordFld.text;
        }
            break;
            
        default:
            break;
    }
    settings.wifiAuthKey = authKey;
    settings.wifiAuthIdentity = authIdentity;
    settings.wifiAuthPassword = authPassword;
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    if (dropDownSelector.isShowed)
        [dropDownSelector hide];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (dropDownSelector.isShowed)
        [dropDownSelector hide];
}

#pragma mark - DropDownItemSelectorDelegate
-(void)didSelect:(DropDownItemSelector*)itemSelector withItem:(NSInteger)index
{
    settings.wifiSecurityProtocol = [protocols objectForKey:@"keys"][index];
    [self refreshProtocolGUI];
}

#pragma mark - Actions Methods
-(IBAction)wifiEnable:(UISwitch*)sender
{
    if (dropDownSelector.isShowed)
        [dropDownSelector hide];
    [self refreshEnableViews];
}

-(IBAction)switchDHCP:(UISwitch*)sender
{
    if (dropDownSelector.isShowed)
        [dropDownSelector hide];
    [self endEditing:YES];
    [self editingEnable:!sender.isOn userInteractionEnabled:!sender.isOn view:staticSettingsView];
}

-(IBAction)hideKeyboard
{
    [self endEditing:YES];
}

#pragma mark - Private Methods
-(void)refreshEnableViews
{
    [self endEditing:YES];
    [self editingEnable:wifiEnabledSwt.isOn userInteractionEnabled:wifiEnabledSwt.isOn view:settingsView];
    [self editingEnable:wifiEnabledSwt.isOn userInteractionEnabled:wifiEnabledSwt.isOn view:dropDownSelector];
    if (wifiEnabledSwt.isOn)
        [self editingEnable:!ipDhcpSwt.isOn userInteractionEnabled:!ipDhcpSwt.isOn view:staticSettingsView];
    else
        [self editingEnable:YES userInteractionEnabled:YES view:staticSettingsView];
}

-(void)editingEnable:(BOOL)isEnable userInteractionEnabled:(BOOL)userInteractionEnabled view:(UIView*)view
{
    CGFloat alpha = isEnable ? 1.0f : 0.7f;
    view.alpha = alpha;
    view.userInteractionEnabled = userInteractionEnabled;
}

-(void)prepareDropDownSelector
{
    CGRect selectorFrame = protocolView.frame;
    selectorFrame.origin.y += CGRectGetMinY(settingsView.frame);
    dropDownSelector = [[DropDownItemSelector alloc] initWithFrame:selectorFrame];
    dropDownSelector.delegate = self;
    UIColor *borderColor = [UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1.f];
    [dropDownSelector setBorder:1.f color:borderColor cornerRadius:3.f];
    [dropDownSelector setSelectedItemColor:[UIColor blackColor]];
    [containerScrollView addSubview:dropDownSelector];
    dropDownSelector.translatesAutoresizingMaskIntoConstraints = NO;
    [[dropDownSelector.centerXAnchor constraintEqualToAnchor:protocolView.centerXAnchor] setActive:YES];
    [[dropDownSelector.centerYAnchor constraintEqualToAnchor:protocolView.centerYAnchor] setActive:YES];
    [[dropDownSelector.heightAnchor constraintEqualToAnchor:protocolView.heightAnchor] setActive:YES];
    [[dropDownSelector.widthAnchor constraintEqualToAnchor:protocolView.widthAnchor] setActive:YES];
}

-(void)refreshProtocolGUI
{
    [self setNeedsLayout];
    switch ((EWiFiSecurityProtocol)dropDownSelector.selectedItemCell)
    {
        case NONE_PROTOCOL:
        {
            protocolDetailsViewHeight.constant = 0;
        }
            break;
        
        case WPA_PSK_PROTOCOL:
        case WEP_PROTOCOL:
        {
            authLabel.text = @"Auth key";
            authKeyFld.text = settings.wifiAuthKey;
            protocolDetailsViewHeight.constant = 40;
        }
            break;
            
        case WPA_2_EAP_PROTOCOL:
        {
            authLabel.text = @"Identity";
            authKeyFld.text = settings.wifiAuthIdentity;
            protocolDetailsViewHeight.constant = 76;
        }
            break;
    }
    [UIView animateWithDuration:0.25 animations:^
    {
        [self layoutIfNeeded];
    }];
}

@end
