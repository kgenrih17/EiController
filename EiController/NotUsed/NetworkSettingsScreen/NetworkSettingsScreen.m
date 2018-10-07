//
//  NetworkSettingsScreen.m
//  EiController
//
//  Created by admin on 2/23/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import "NetworkSettingsScreen.h"
#import "NetworkSettingsScreenInterface.h"
#import "NetworkSettingsPresenter.h"

#import "WiFiSettingsView.h"
#import "EthernetSettingsView.h"

@interface NetworkSettingsScreen () <NetworkSettingsScreenInterface>
{
    __weak IBOutlet UIButton *wifiButton;
    __weak IBOutlet UIView *wifiLineView;
    
    __weak IBOutlet UIButton *ethernetButton;
    __weak IBOutlet UIView *ethernetLineView;
    
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UILabel *errorLabel;

    WiFiSettingsView *wifiView;
    EthernetSettingsView *etherView;
    
    NetworkSettingsPresenter *presenter;
    NetworkSettingsViewModel *model;
}
@end

@implementation NetworkSettingsScreen

#pragma mark - Public Init Methods
-(instancetype)initWithFingerprints:(NSArray<NSString*>*)fingerprints
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    
    if (self)
    {
        presenter = [NetworkSettingsPresenter presenterWithScreen:self
                                                       interactor:self.interactor
                                                     fingerprints:fingerprints];
    }
    
    return self;
}

#pragma mark - Override Methods
-(void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setNeedsLayout];
    wifiView = [[WiFiSettingsView alloc] initWithFrame:containerView.bounds];
    wifiView.hidden = YES;
    [wifiView load:model.tempSettings protocols:model.securityProtocols selectedIndex:model.selectedProtocolIndex];
    [self addToContainerView:wifiView];
    
    etherView = [[EthernetSettingsView alloc] initWithFrame:containerView.bounds];
    [etherView load:model.tempSettings];
    [self addToContainerView:etherView];
    [self.view layoutIfNeeded];
    [presenter onCreate];
}

-(void)removeFromParentViewController
{
    [super removeFromParentViewController];

    [wifiView removeFromSuperview];
    wifiView = nil;
    [etherView removeFromSuperview];
    etherView = nil;
    presenter = nil;
    model = nil;
}

#pragma mark - NetworkSettingsScreenInterface
-(void)refresh:(NetworkSettingsViewModel*)viewModel
{
    model = viewModel;
    [wifiView load:model.tempSettings protocols:viewModel.securityProtocols selectedIndex:viewModel.selectedProtocolIndex];
    [etherView load:model.tempSettings];
    [self refreshViewMode:model.viewMode];
}

-(void)showError:(NSString*)error
{
    errorLabel.text = error;
    errorLabel.hidden = NO;
    containerView.hidden = YES;
    self.saveButton.enabled = NO;
}

-(void)hideError
{
    errorLabel.text = nil;
    errorLabel.hidden = YES;
    containerView.hidden = NO;
    self.saveButton.enabled = YES;
}

#pragma mark - Action Methods
-(IBAction)save
{
    NSString *message = nil;
    
    if (![etherView isFilledAllSettings])
        message = @"Please complete all Ethernet settings";
    else if (![wifiView isFilledAllSettings])
        message = @"Settings have not been changed";
    else
    {
        [etherView updateSettings];
        [wifiView updateSettings];
        
        if ([model.settings isEqual:model.tempSettings])
            message = @"Settings have not been changed";
    }
    
    if (message == nil)
        [presenter save:model];
    else
        [self showAlertWithTitle:@"Info" message:message];
}

-(IBAction)switchNetworkMode:(UIButton*)button
{
    switch (model.viewMode)
    {
        case ETHERNET_MODE:
            model.viewMode = WIFI_MODE;
            break;
            
        case WIFI_MODE:
            model.viewMode = ETHERNET_MODE;
            break;
    }
    
    if (errorLabel.isHidden)
        [self refreshViewMode:model.viewMode];
}

#pragma mark - Private Methods
-(void)addToContainerView:(UIView*)settingsView
{
    [containerView addSubview:settingsView];
    [settingsView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [settingsView sizeToFit];
}

-(void)refreshViewMode:(ENetworkViewMode)mode
{
    BOOL isEthernet = (mode == ETHERNET_MODE);
    
    UIFont *selectedFont = [UIFont boldSystemFontOfSize:20];
    UIFont *normalFont = [UIFont systemFontOfSize:20];
    
    wifiView.hidden = isEthernet;
    wifiLineView.hidden = isEthernet;
    wifiButton.selected = !isEthernet;
    wifiButton.titleLabel.font = isEthernet ? normalFont : selectedFont;
    
    etherView.hidden = !isEthernet;
    ethernetLineView.hidden = !isEthernet;
    ethernetButton.selected = isEthernet;
    ethernetButton.titleLabel.font = isEthernet ? selectedFont : normalFont;
}

@end
