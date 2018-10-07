//
//  ErrorDescription.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EErrorCode)
{
    ANSWER_DATA_IS_NIL = 1,
    ANSWER_DATA_IS_EMPTY = 2,
    PROCESS_CANCELED = 3,
    REQUEST_ERROR = 4,
    INCORRECT_FORMAT_ANSWER = 422,
    DOWNLOAD_FILE_ERROR = 408,
    UPLOAD_FILE_ERROR = 409
};

@interface ErrorDescription : NSObject

+(NSString*)getError:(NSInteger)code;

@end
