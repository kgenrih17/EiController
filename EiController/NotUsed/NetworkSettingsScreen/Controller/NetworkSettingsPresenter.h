//
//  NetworkSettingsPresenter.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkSettingsScreenInterface.h"
#import "AppInteractorInterface.h"

@interface NetworkSettingsPresenter : NSObject

+(instancetype)presenterWithScreen:(id<NetworkSettingsScreenInterface>)screenInterface
                        interactor:(id<AppInteractorInterface>)interactorInterface
                      fingerprints:(NSArray<NSString*>*)fingerprints;

-(void)onCreate;
-(void)save:(NetworkSettingsViewModel*)viewModel;

@end
