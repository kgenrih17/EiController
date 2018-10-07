//
//  IPSettings.h
//  EiController
//
//  Created by Genrih Korenujenko on 29.03.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EIPVersionType)
{
    IP4_VERSION_TYPE = 0,
    IP6_VERSION_TYPE
};

@interface IPSettings : NSObject <NSCopying>

@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, copy) NSString *netmask;
@property (nonatomic, readwrite, copy) NSString *gateway;
@property (nonatomic, readwrite, copy) NSString *version;
@property (nonatomic, readwrite) EIPVersionType versionType;

+(instancetype)build:(NSString*)address
             netmask:(NSString*)netmask
             gateway:(NSString*)gateway
             version:(NSString*)version;

@end
