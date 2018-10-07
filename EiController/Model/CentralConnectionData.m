//
//  CentralConnectionData.m
//  EiController
//
//  Created by Genrih Korenujenko on 12.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "CentralConnectionData.h"

@implementation CentralConnectionData

#pragma mark - Public Methods
-(void)save
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.scheme forKey:[self.class getKey:@"scheme"]];
    [userDefaults setObject:self.host forKey:[self.class getKey:@"host"]];
    [userDefaults setObject:@(self.port) forKey:[self.class getKey:@"port"]];
}

+(instancetype)get
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *scheme = [userDefaults stringForKey:[self getKey:@"scheme"]];
    NSString *host = [userDefaults stringForKey:[self getKey:@"host"]];
    NSInteger port = [userDefaults integerForKey:[self getKey:@"port"]];
    return [self createWithScheme:scheme host:host port:port];
}

#pragma mark - Override Property Methods
-(NSString*)companyUniq
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"company_uniq"];
}

-(NSString*)token
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
}

#pragma mark - Private Methods
+(NSString*)getKey:(NSString*)addition
{
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass(self.class), addition];
}

@end
