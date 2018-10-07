//
//  User.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EUserLevel.h"

typedef NS_ENUM(NSInteger, EUserAuthType)
{
    NONE_AUTH = 0,
    AUTH_BY_PIN,
    AUTH_BY_LOGIN
};

@interface User : NSObject

@property (nonatomic, readwrite, copy) NSString *unique;
@property (nonatomic, readwrite, copy) NSString *company;
@property (nonatomic, readwrite, copy) NSString *companyUniq;
@property (nonatomic, readwrite, copy) NSString *companyID;
@property (nonatomic, readwrite, copy) NSString *email;
@property (nonatomic, readwrite, copy) NSString *firstName;
@property (nonatomic, readwrite, copy) NSString *lastName;
@property (nonatomic, readwrite, copy) NSString *login;
@property (nonatomic, readwrite, copy) NSString *password;
@property (nonatomic, readwrite, copy) NSString *pin;
@property (nonatomic, readwrite) NSInteger lastSyncTimestamp;
@property (nonatomic, readwrite) EUserLevel level;
@property (nonatomic, readwrite) EUserAuthType authType;

+(instancetype)create:(NSDictionary*)dic;
+(instancetype)authUser;
+(instancetype)empty;

@end
