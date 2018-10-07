//
//  NetworkSettingsScreenInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ScreenInterface.h"
#import "NetworkSettingsViewModel.h"

@protocol NetworkSettingsScreenInterface <ScreenInterface>

@required
-(void)refresh:(NetworkSettingsViewModel*)model;
-(void)showError:(NSString*)error;
-(void)hideError;

@end

