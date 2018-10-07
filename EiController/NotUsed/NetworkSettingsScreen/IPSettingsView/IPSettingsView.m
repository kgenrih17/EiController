//
//  IPSettingsView.m
//  EiController
//
//  Created by Genrih Korenujenko on 28.03.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "IPSettingsView.h"
#import "UITextField+Additions.h"

@implementation IPSettingsView

@synthesize dns1Array, dns2Array, dns3Array, listener;

#pragma mark - Public Init Methods
+(instancetype)build:(id<IPSettingsViewListener>)listener
{
    IPSettingsView *result = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    result.listener = listener;
    return result;
}

#pragma mark - Override Methods
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview != nil)
    {
        ipVersionSwitch.transform = CGAffineTransformMakeScale(0.70, 0.65);
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.superview setNeedsLayout];
        [[self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor] setActive:YES];
        [[self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor] setActive:YES];
        [[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor] setActive:YES];
        [[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor] setActive:YES];
        [self.superview layoutIfNeeded];
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL result = ((newString != nil) && (newString.length < 4) && [string isEqualToString:filtered]);
    if (result)
    {
        [textField addString:string range:range nextFirstResponders:allDNSs maxLength:3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
        {
            [listener changedDNS];
        });
    }
    return result;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField*)textField
{
    if (textField.text.isEmpty)
        textField.text = nil;
}

#pragma mark - Public Methods
-(void)load:(IPSettings*)settings dns1:(NSString*)dns1 dns2:(NSString*)dns2 dns3:(NSString*)dns3
{
    currentSettings = settings;
    [self refresh];
    [self fill:[dns1 componentsSeparatedByString:@"."] forFields:dns1Array];
    [self fill:[dns2 componentsSeparatedByString:@"."] forFields:dns2Array];
    [self fill:[dns3 componentsSeparatedByString:@"."] forFields:dns3Array];
}

-(BOOL)isFilled
{
    BOOL result = ([self isFilledFields:dns1Array] || [self isFilledFields:dns2Array] || [self isFilledFields:dns3Array]);
    if (result)
    {
        if (ipVersionSwitch.isOn)
        {
            result = ([self isFilledFields:ip4View.addressesArray] && [self isFilledFields:ip4View.netmasksArray] && [self isFilledFields:ip4View.gatewaysArray]);
        }
        else
            result = [ip6View isFilled];
    }
    return result;
}

-(void)update
{
    if (ipVersionSwitch.isOn)
    {
        currentSettings.address = [self getAddressFromFields:ip4View.addressesArray];
        currentSettings.netmask = [self getAddressFromFields:ip4View.netmasksArray];
        currentSettings.gateway = [self getAddressFromFields:ip4View.gatewaysArray];
    }
    else
    {
        currentSettings.address = ip6View.addressTextField.text;
        currentSettings.netmask = ip6View.prefixLengthTextField.text;
        currentSettings.gateway = ip6View.gatewayTextField.text;
    }
}

-(NSString*)getDNS1
{
    return [self getAddressFromFields:dns1Array];
}

-(NSString*)getDNS2
{
    return [self getAddressFromFields:dns2Array];
}

-(NSString*)getDNS3
{
    return [self getAddressFromFields:dns3Array];
}

#pragma mark - Action Methods
-(IBAction)changeVersion:(UISwitch*)sender
{
    [self endEditing:YES];
    currentSettings.versionType = (EIPVersionType)sender.isOn;
    [self refresh];
}

#pragma mark - Private Methods
-(void)refresh
{
    switch (currentSettings.versionType)
    {
        case IP4_VERSION_TYPE:
        {
            [self fillIP4:currentSettings];
            ip6View.hidden = YES;
            ip4View.hidden = NO;
        }
            break;
            
        case IP6_VERSION_TYPE:
        {
            [self fillIP6:currentSettings];
            ip4View.hidden = YES;
            ip6View.hidden = NO;
        }
            break;
    }
    ipVersionSwitch.on = (currentSettings.versionType == IP4_VERSION_TYPE);
    ipVersionLabel.text = currentSettings.version;
}

-(void)fillIP4:(IPSettings*)settings
{
    if (ip4View == nil)
    {
        ip4View = [IP4View build:[settings.address componentsSeparatedByString:@"."]
                         netmask:[settings.netmask componentsSeparatedByString:@"."]
                         gateway:[settings.gateway componentsSeparatedByString:@"."]];
        [self addIPView:ip4View];
    }
    else
    {
        [ip4View load:[settings.address componentsSeparatedByString:@"."]
              netmask:[settings.netmask componentsSeparatedByString:@"."]
              gateway:[settings.gateway componentsSeparatedByString:@"."]];
    }
}

-(void)fillIP6:(IPSettings*)settings
{
    if (ip6View == nil)
    {
        ip6View = [IP6View build:settings.address
                    prefixLength:settings.netmask
                         gateway:settings.gateway];
        [self addIPView:ip6View];
    }
    else
    {
        [ip6View load:settings.address
         prefixLength:settings.netmask
              gateway:settings.gateway];
    }
}

-(void)addIPView:(UIView*)view
{
    [ipContainerView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [[view.leadingAnchor constraintEqualToAnchor:ipContainerView.leadingAnchor] setActive:YES];
    [[view.trailingAnchor constraintEqualToAnchor:ipContainerView.trailingAnchor] setActive:YES];
    [[view.topAnchor constraintEqualToAnchor:ipContainerView.topAnchor] setActive:YES];
    [[view.bottomAnchor constraintEqualToAnchor:ipContainerView.bottomAnchor] setActive:YES];
}

-(void)fill:(NSArray<NSString*>*)values forFields:(NSArray<UITextField*>*)fields
{
    [fields enumerateObjectsUsingBlock:^(UITextField *field, NSUInteger idx, BOOL *stop)
    {
        field.text = [values isValidIndex:idx] ? values[idx] : @"";
    }];
}

-(BOOL)isFilledFields:(NSArray<UITextField*>*)fields
{
    NSArray *groupAddress = [fields valueForKey:pNameForClass(UITextField, text)];
    return (![groupAddress containsObject:[NSNull null]] && ![groupAddress containsObject:@""]);
}

-(NSString*)getAddressFromFields:(NSArray<UITextField*>*)fields
{
    NSString *address = @"";
    NSArray *groupAddress = [fields valueForKey:pNameForClass(UITextField, text)];
    if (![groupAddress containsObject:[NSNull null]] && ![groupAddress containsObject:@""])
        address = [groupAddress componentsJoinedByString:@"."];
    return address;
}

@end
