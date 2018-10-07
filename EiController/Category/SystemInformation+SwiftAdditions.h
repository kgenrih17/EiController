//
//  SystemInformation+SwiftAdditions.h
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 19.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EMemoryType)
{
    TOTAL=0,
    FREE,
    USED
};

@interface NSObject (SwiftAdditions)

+(NSInteger)getRAM:(EMemoryType)type;
+(NSInteger)getStorage:(EMemoryType)type;

@end
