//
//  SystemInformation+SwiftAdditions.m
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 19.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "SystemInformation+SwiftAdditions.h"
#import <EvogenceLib/EvogenceLib.h>

@implementation NSObject (SwiftAdditions)

+(NSInteger)getRAM:(EMemoryType)type
{
    return [SystemInformation GetRAMSpace:(EMemoryInfoType)type];
}

+(NSInteger)getStorage:(EMemoryType)type
{
    return [SystemInformation GetFlashDiskSpace:(EMemoryInfoType)type];
}

@end
