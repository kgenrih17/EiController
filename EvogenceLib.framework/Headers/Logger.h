//
//  Logger.h
//  Viewer
//
//  Created by anatolij on 07.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppInfromation.h"

typedef enum 
{
	DISABLE_L=0,
	ERROR_L,
	DEBUG_L,
	INFO_L

} ELogLevel;

typedef enum
{
    TXT_FORMAT = 0,
    CSV_FORMAT
} ELogFormat;

@interface Logger : NSObject
{
    ELogLevel logLevel;
    ELogFormat logFormat;
    
    int durationPiece; // in seconds
    int amountPieces;
    
    NSDateFormatter *dateFormatter;
}

+(id)currentLog;

-(void)setLogFormat:(ELogFormat)_logFormat;
-(void)setLogLevel:(ELogLevel)_logLevel;
-(void)setDurationOfLogPiece:(NSInteger)_minutes andAmountPiece:(NSInteger)_amount;

-(void)write:(NSString*)_text withLogLevel:(ELogLevel)_logLevel;
-(void)writeWithObject:(id)_object selector:(SEL)_selector text:(NSString*)_text logLevel:(ELogLevel)_logLevel;
-(void)writeWithObject:(id)_object selector:(SEL)_selector logLevel:(ELogLevel)_logLevel text:(NSString*)_text, ...;

@end
