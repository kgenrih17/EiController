//
//  DeviceOperationLog.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "EDeviceActionType.h"

@interface DeviceOperationLog : NSObject

@property (nonatomic, readwrite) NSInteger itemId;
@property (nonatomic, readwrite) NSInteger errorCode;
@property (nonatomic, readwrite) NSInteger timestamp;
@property (nonatomic, readwrite, copy) NSString *actionTitle;
@property (nonatomic, readwrite, copy) NSString *errorMessage;
@property (nonatomic, readwrite, copy) NSString *desc;
@property (nonatomic, readwrite, copy) NSString *fingerprint;

+(instancetype)build:(NSString*)title
                code:(NSInteger)code
        errorMessage:(NSString*)errorMessage
                desc:(NSString*)desc
   fingerprint:(NSString*)fingerprint;

@end
