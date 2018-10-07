//
//  Utils.h
//  Viewer
//
//  Created by anatolij on 26.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface Utils: NSObject 

+(id)NillOrValue:(id)valueOrNull;
+(NSString*)GetUniqueID;
+(NSString*)getClearFileNameFromPath:(NSString*)_path; //without expansion: *.pdf, *.png etc
+(NSString*)GetFormattedTimeDurection:(NSInteger)_duration;
+(NSString*)getCurrentDateAsString;

@end
