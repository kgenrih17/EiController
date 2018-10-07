//
//  ErrorDescription.m
//  EiController
//
//  Created by Genrih Korenujenko on 27.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ErrorDescription.h"

@implementation ErrorDescription

+(NSString*)getError:(NSInteger)code
{
    NSString *result = nil;
    
    switch (code)
    {
        case ANSWER_DATA_IS_NIL:
            result = @"Data is nil";
            break;
            
        case ANSWER_DATA_IS_EMPTY:
            result = @"Data is empty";
            break;
            
        case PROCESS_CANCELED:
            result = @"Process canceled";
            break;
            
        case REQUEST_ERROR:
            result = @"Error connecting to server";
            break;
            
        case INCORRECT_FORMAT_ANSWER:
            result = @"incorrect format response";
            break;
            
        case DOWNLOAD_FILE_ERROR:
            result = @"Download file error";
            break;

        case UPLOAD_FILE_ERROR:
            result = @"Upload file error";
            break;
            
        case 0:
            result = @"";
            break;

        default:
            result = [NSString stringWithFormat:@"Unknown error code: %tu", code];
            break;
    }
    
    return result;
}

@end
