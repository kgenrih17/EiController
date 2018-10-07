//
//  AuthInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 25.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "AuthObserverInterface.h"
#import "User.h"

@protocol AuthInterface <NSObject>

@required
-(void)authIsSuccessful;
-(void)updateSyncSettings;
-(void)logout;

-(void)setAuthObserver:(id<AuthObserverInterface>)authObserver;
-(void)removeAuth;

@end
