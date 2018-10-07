//
//  CentralMethod.h
//  EiController
//
//  Created by Genrih Korenujenko on 06.11.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EiOSMethod : NSObject

+(NSString*)uploadMedia;
+(NSString*)applyScheduleData;
+(NSString*)uploadApplication;
+(NSString*)applyData;
+(NSString*)getLogFiles;
+(NSString*)downloadLogFile;
+(NSString*)setUploadedLogFiles;

@end

@interface IPMethod : NSObject

+(NSString*)getScheduleApplications;
+(NSString*)downloadFile;
+(NSString*)setUploadedFiles;

@end

@interface TaskMethod : NSObject

+(NSString*)getScheduleData;

@end

@interface ServerAllowMethod : NSObject

+(NSString*)authEmployeeByPin;
+(NSString*)authEmployee;

@end

@interface CentralMethod : NSObject

+(NSString*)dasJsonPHP;
+(NSString*)echo;
+(NSString*)regAppByToken;
+(NSString*)getNodesByToken;
+(NSString*)uploadLogFiles;

@end


