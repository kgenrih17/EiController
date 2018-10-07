//
//  NavigationInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 25.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "CentralConnectionData.h"
#import "AppInteractorInterface.h"
#import "AuthObserverInterface.h"
#import "ScreenInterface.h"

@protocol AuthInterface;

@protocol NavigationInterface <NSObject, ScreenInterface, AuthObserverInterface>

@required
-(void)showDeviceDetailsScreen:(NSString*)fingerprint actionInterface:(id)actionInterface; // IDeviceDetailsScreenAction
-(void)leftAnimationChangeDetailsView:(NSString*)fingerprint actionInterface:(id)actionInterface; // IDeviceDetailsScreenAction
-(void)rigthAnimationChangeDetailsView:(NSString*)fingerprint actionInterface:(id)actionInterface; // IDeviceDetailsScreenAction
-(void)showNetworkSettingsScreen:(NSArray<NSString*>*)fingerprints;
-(void)showDeviceSyncLogScreen:(NSString*)fingerprint;
-(void)showServerSyncLogScreen;
-(void)showSettingsScreen;
-(void)showModeConfigurationScreen:(NSString*)fingerprint;
-(void)showDeviceRebotShutdownScreen:(NSString*)fingerprint;
-(void)showNodeIntegrationScreen:(NSArray<NSString*>*)fingerprints;

-(void)closeAllScreens;
-(void)showView:(UIView*)view;
-(void)setBackgroundColor:(UIColor*)color;

-(id<AppInteractorInterface, AuthInterface>)interactor;

@end
