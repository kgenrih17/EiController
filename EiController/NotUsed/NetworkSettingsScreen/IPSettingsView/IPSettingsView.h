//
//  IPSettingsView.h
//  EiController
//
//  Created by Genrih Korenujenko on 28.03.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPSettings.h"
#import "IP4View.h"
#import "IP6View.h"

@protocol IPSettingsViewListener <NSObject>

@required
-(void)changedDNS;

@end

@interface IPSettingsView : UIView <UITextFieldDelegate>
{
    IBOutletCollection(UITextField) NSArray *allDNSs;
    IBOutlet UILabel *ipVersionLabel;
    IBOutlet UISwitch *ipVersionSwitch;
    IBOutlet UIView *ipContainerView;
    IP4View *ip4View;
    IP6View *ip6View;
    IPSettings *currentSettings;
}

@property (nonatomic, readwrite, weak) id <IPSettingsViewListener> listener;
@property (nonatomic, readonly, strong) IBOutletCollection(UITextField) NSArray *dns1Array;
@property (nonatomic, readonly, strong) IBOutletCollection(UITextField) NSArray *dns2Array;
@property (nonatomic, readonly, strong) IBOutletCollection(UITextField) NSArray *dns3Array;

+(instancetype)build:(id<IPSettingsViewListener>)listener;
-(void)load:(IPSettings*)settings dns1:(NSString*)dns1 dns2:(NSString*)dns2 dns3:(NSString*)dns3;
-(BOOL)isFilled;
-(void)update;
-(NSString*)getDNS1;
-(NSString*)getDNS2;
-(NSString*)getDNS3;

@end
