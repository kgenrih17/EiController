//
//  User.m
//  EiController
//
//  Created by Genrih Korenujenko on 26.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "User.h"
#import "UserDefaultsKeys.h"

@implementation User

#pragma mark - Public Init Methods
+(instancetype)create:(NSDictionary*)dic
{
    User *result = [User new];
    result.unique = dic[@"unique"];
    result.company = dic[@"company"];
    result.companyUniq = dic[@"company_uniq"];
    result.companyID = [[NSUserDefaults standardUserDefaults] stringForKey:@"company_id"];
    result.email = dic[@"email"];
    result.firstName = dic[@"first_name"];
    result.lastName = dic[@"last_name"];
    result.login = dic[@"login"];
    result.password = dic[@"password"];
    result.pin = dic[@"pin"];
    result.level = ([dic integerForKey:@"is_admin"] == 1) ? ADMIN_LEVEL : USER_LEVEL;
    result.lastSyncTimestamp = [[NSUserDefaults standardUserDefaults] integerForKey:USER_LAST_SYNC_TIMESTAMP];
    result.authType = (EUserAuthType)[[NSUserDefaults standardUserDefaults] integerForKey:USER_AUTH_TYPE_KEY];
    return result;
}

+(instancetype)authUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *employee = [userDefaults dictionaryForKey:@"employee"];
    
    return (employee != nil) ? [self create:employee] : nil;
}

+(instancetype)empty
{
    User *result = [User new];
    result.unique = @"";
    result.company = @"";
    result.companyUniq = @"";
    result.companyID = @"";
    result.email = @"";
    result.firstName = @"";
    result.lastName = @"";
    result.login = @"";
    result.password = @"";
    result.pin = @"";
    result.level = USER_LEVEL;
    result.lastSyncTimestamp = 0;
    result.authType = NONE_AUTH;
    return result;
}

@end

