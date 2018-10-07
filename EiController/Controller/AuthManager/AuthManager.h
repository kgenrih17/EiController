//
//  AuthManager.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "AuthManagerInterface.h"
#import "EiCentralAPI.h"
#import "BiometricAuth.h"
#import "User.h"

@interface AuthManager : NSObject <AuthManagerInterface>
{
    BiometricAuth *biometricAuth;
    User *loggedUser;
}

@property (nonatomic, readwrite, strong) EiCentralAPI *api;

@end
