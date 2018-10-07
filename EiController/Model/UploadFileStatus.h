//
//  UploadFileStatus.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EDestination)
{
    EINODE_DESTINATION = 0,
    CENTRAL_DESTINATION
};

@interface UploadFileStatus : NSObject

@property (nonatomic, readwrite) NSInteger itemId;
@property (nonatomic, readwrite) NSInteger errorCode;
@property (nonatomic, readwrite) BOOL isUpload;
@property (nonatomic, readwrite) EDestination destination;
@property (nonatomic, readwrite, copy) NSString *fingerprint;
@property (nonatomic, readwrite, copy) NSString *fileId;

@end
