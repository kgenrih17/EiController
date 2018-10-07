//
//  SynchronizationPresenter.h
//  EiController
//
//  Created by Genrih Korenujenko on 18.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynchronizationScreenInterface.h"
#import "AuthInterface.h"
#import "UserDefaultsKeys.h"

@interface SynchronizationPresenter : NSObject

@property (nonatomic,readwrite, weak) id <SynchronizationScreenInterface> screen;
@property (nonatomic,readwrite, weak) id <AuthInterface> authInterface;

+(instancetype)build:(id<SynchronizationScreenInterface>)screenInterface
       authInterface:(id<AuthInterface>)authInterface;

-(void)onCreate;
-(void)accept:(SynchronizationViewModel*)viewModel;

@end
