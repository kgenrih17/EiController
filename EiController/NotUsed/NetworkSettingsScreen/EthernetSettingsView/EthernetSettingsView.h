//
//  EthernetSettingsView.h
//  EiController
//
//  Created by admin on 8/17/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPSettingsView.h"
#import "NetworkSettings.h"

@interface EthernetSettingsView : UIView <UITextFieldDelegate, IPSettingsViewListener>
{
    __weak IBOutlet UISwitch *ipdhcpSwt;
    __weak IBOutlet UIView *staticSettingsView;
    IPSettingsView *ipSettingsView;
    NetworkSettings *settings;
}

-(void)load:(NetworkSettings*)settings;
-(BOOL)isFilledAllSettings;
-(void)updateSettings;

@end
