//
//  AppInteractor.h
//  EiController
//
//  Created by Genrih Korenujenko on 13.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppInteractorInterface.h"
#import "AuthInterface.h"

@class Navigation;

@interface AppInteractor : NSObject <AppInteractorInterface, AuthInterface>

@property (nonatomic, readwrite, weak) Navigation *navigation;

-(void)start;

@end
