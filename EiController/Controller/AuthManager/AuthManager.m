//
//  AuthManager.m
//  EiController
//
//  Created by Genrih Korenujenko on 26.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "AuthManager.h"
#import "UserDefaultsKeys.h"
#import "EiController-Swift.h"

#warning TODO hvk: add authorization after if token is expired

static NSString * const DEFAULT_AUTH_LOGIN = @"evo_user";
static NSString * const DEFAULT_AUTH_PASSWORD = @"s3rv1c3";

@implementation AuthManager

@synthesize listener, api, status;

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        biometricAuth = [BiometricAuth new];
        loggedUser = [User authUser];
    }
    return self;
}

#pragma mark - AuthManagerInterface
+(instancetype)build:(id<AuthManagerListener>)listener
      connectionData:(CentralConnectionData*)connectionData
{
    AuthManager *result = [self new];
    result.status = NON_AUTH;
    result.listener = listener;
    result.api = [EiCentralAPI build:connectionData];
    return result;
}

-(void)setConnectionData:(CentralConnectionData*)connectionData
{
    [api setConnectionData:connectionData];
}

-(void)auth
{
    EUserAuthType userAuthType = [[NSUserDefaults standardUserDefaults] integerForKey:USER_AUTH_TYPE_KEY];
    switch (userAuthType)
    {
        case AUTH_BY_PIN:
        case AUTH_BY_LOGIN:
        {
            if (AppStatus.isExtendedMode)
            {
                if ([SystemInformation GetConnectionType] == NONE_CONNECTION)
                {
                    self.status = OFFLINE_AUTH;
                    [listener authWithStatus:self.status];
                }
                else
                    [self processingSendAuth:userAuthType];
            }
            else
            {
                [self createServiceData];
                [listener authWithStatus:self.status];
            }
        }
        break;
        case NONE_AUTH:
            [listener authWithStatus:NON_AUTH];
        break;
    }
}

-(void)authByPin:(NSString*)pin companyID:(NSString*)companyID completion:(void(^)(NSString*))completion
{
    [api authByPin:pin compenyCode:companyID completion:^(NSDictionary *result)
    {
        NSString *error = [api getErrorMessage];
        if (error == nil)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:AUTH_BY_PIN forKey:USER_AUTH_TYPE_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:companyID forKey:@"company_id"];
            [self parseUserData:result];
        }
        BLOCK_SAFE_RUN(completion, error);
    }];
}

-(void)authByLogin:(NSString*)login password:(NSString*)password companyID:(NSString*)companyID completion:(void(^)(NSString*))completion
{
    [api authByLogin:login password:password compenyCode:companyID completion:^(NSDictionary *result)
    {
        NSString *error = [api getErrorMessage];
        if (error == nil)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:AUTH_BY_LOGIN forKey:USER_AUTH_TYPE_KEY];
            [[NSUserDefaults standardUserDefaults] setObject:companyID forKey:@"company_id"];
            NSMutableDictionary *answer = [NSMutableDictionary dictionaryWithDictionary:result];
            NSMutableDictionary *employee = [NSMutableDictionary dictionaryWithDictionary:result[@"employee"]];
            [employee setObject:password forKey:@"password"];
            [answer setObject:employee forKey:@"employee"];
            [self parseUserData:answer];
        }
        BLOCK_SAFE_RUN(completion, error);
    }];
}

-(void)authByLogin:(NSString*)login password:(NSString*)password completion:(void(^)(NSString *error))completion
{
    NSString *error = nil;
    if ([login isEqualToString:DEFAULT_AUTH_LOGIN] && [password isEqualToString:DEFAULT_AUTH_PASSWORD])
    {
        [self createServiceData];
    }
    else
    {
        self.status = NON_AUTH;
        error = @"Incorrect login or password";
    }
    [[NSUserDefaults standardUserDefaults] setInteger:AUTH_BY_LOGIN forKey:USER_AUTH_TYPE_KEY];
    BLOCK_SAFE_RUN(completion, error);
}

-(User*)getLoggedUser
{
    return loggedUser;
}

-(void)prepareForLogout
{
    [self clearUserData];
}

#pragma mark - Private Methods
-(void)createServiceData
{
    [AppStatus saveMode];
    self.status = OFFLINE_AUTH;
    loggedUser = [User empty];
    loggedUser.level = ADMIN_LEVEL;
    loggedUser.authType = AUTH_BY_LOGIN;
    loggedUser.login = DEFAULT_AUTH_LOGIN;
    loggedUser.password = DEFAULT_AUTH_PASSWORD;
}

-(void)processingSendAuth:(EUserAuthType)userAuthType
{
    if (userAuthType == AUTH_BY_PIN)
    {
        [self authByPin:loggedUser.pin companyID:loggedUser.companyID completion:^(NSString *error)
        {
            [self authWithStatus:error];
        }];
    }
    else
    {
        [self authByLogin:loggedUser.login password:loggedUser.password companyID:loggedUser.companyID completion:^(NSString *error)
        {
            [self authWithStatus:error];
        }];
    }
}

-(void)authWithStatus:(NSString*)error
{
    if (error == nil)
    {
        self.status = ONLINE_AUTH;
        [listener authWithStatus:self.status];
    }
    else
    {
        self.status = NON_AUTH;
        [listener authError:error];
    }
}

-(void)parseUserData:(NSDictionary*)result
{
    [self saveUserData:result];
    NSDictionary *employee = [result dictionaryForKey:@"employee"];
    loggedUser = [User create:employee];
    self.status = ONLINE_AUTH;
}

-(void)saveUserData:(NSDictionary*)result
{
    NSDictionary *employee = [result dictionaryForKey:@"employee"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:employee forKey:@"employee"];
    [userDefaults setObject:[result stringForKey:@"token"] forKey:@"token"];
    [userDefaults setObject:[employee stringForKey:@"company_id"] forKey:@"company_uniq"];
    [userDefaults setInteger:[NSDate date].timeIntervalSince1970 forKey:USER_LAST_SYNC_TIMESTAMP];
}

-(void)clearUserData
{
    if ([biometricAuth isAuthOn])
        [biometricAuth disableAuthForPin:loggedUser.pin succesBlock:nil failureBlock:nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"employee"];
    [userDefaults setObject:nil forKey:@"token"];
    [userDefaults setObject:nil forKey:@"company_id"];
    [userDefaults setObject:nil forKey:USER_LAST_SYNC_TIMESTAMP];
    [userDefaults setObject:nil forKey:USER_AUTH_TYPE_KEY];
    loggedUser = nil;
    [AppStatus clearMode];
}

@end
