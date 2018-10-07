//
//  WiFiSettingsView.h
//  EiController
//
//  Created by admin on 8/17/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownItemSelector.h"
#import "IPSettingsView.h"
#import "NetworkSettings.h"

@interface WiFiSettingsView : UIView <UITextFieldDelegate, UIScrollViewDelegate, DropDownItemSelectorDelegate, IPSettingsViewListener>
{
    __weak IBOutlet UIScrollView *containerScrollView;
    __weak IBOutlet UIView *settingsView;
    __weak IBOutlet UISwitch *wifiEnabledSwt;
    __weak IBOutlet UISwitch *wifiPreferedSwt;
    __weak IBOutlet UITextField *ssidFld;
    __weak IBOutlet UITextField *authKeyFld;
    __weak IBOutlet UITextField *passwordFld;
    __weak IBOutlet UISwitch *ipDhcpSwt;
    __weak IBOutlet UIView *protocolView;
    __weak IBOutlet UILabel *authLabel;
    __weak IBOutlet UIView *staticSettingsView;
    IBOutlet NSLayoutConstraint *protocolDetailsViewHeight;
    IPSettingsView *ipSettingsView;
    NetworkSettings *settings;
    DropDownItemSelector *dropDownSelector;
    NSDictionary *protocols;
}

-(void)load:(NetworkSettings*)settings protocols:(NSDictionary*)protocols selectedIndex:(NSInteger)selectedIndex;
-(BOOL)isFilledAllSettings;
-(void)updateSettings;

@end
