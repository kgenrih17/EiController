//
//  EiControllerSysInfo.m
//  EiController
//
//  Created by Genrih Korenujenko on 13.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "EiControllerSysInfo.h"

@implementation EiControllerSysInfo

+(NSString*)getUdid
{
//#warning TODO hvk: for test
//    return @"2AB06539-DC80-4DEB-A85E-85FDD8B42535";
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *stringUDID;
    
    if ([userDefault objectForKey:@"UUIDString"])
    {
        stringUDID = [userDefault stringForKey:@"UUIDString"];
    }
    else
    {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
            stringUDID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        else
            stringUDID = [Utils GetUniqueID];
        
        if ([stringUDID length] > 36)
            stringUDID = [stringUDID substringWithRange:NSMakeRange(0, 36)];
        
        [userDefault setObject:stringUDID forKey:@"UUIDString"];
        [userDefault synchronize];
    }
    return stringUDID;
}


@end
