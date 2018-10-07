//
//  AppInfromation.h
//  WineDiscovery
//
//  Created by Anatolij on 2/19/13.
//  Copyright (c) 2013 Radical Computing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfromation : NSObject

+(NSString*)getPathToDocuments;
+(void)createTempFolder;
+(void)createPathIfNeed:(NSString*)path;

@end
