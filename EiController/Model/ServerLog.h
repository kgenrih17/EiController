//
//  ServerLog.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "EActionType.h"

@interface ServerLog : NSObject

@property (nonatomic, readwrite) NSInteger itemId;
@property (nonatomic, readwrite) NSInteger errorCode;
@property (nonatomic, readwrite) NSInteger timestamp;
@property (nonatomic, readwrite, copy) NSString *actionTitle;
@property (nonatomic, readwrite, copy) NSString *errorMessage;
@property (nonatomic, readwrite, copy) NSString *server;
@property (nonatomic, readwrite, copy) NSString *desc;

+(instancetype)build:(NSString*)title
                code:(NSInteger)code
        errorMessage:(NSString*)errorMessage
              server:(NSString*)server
                desc:(NSString*)desc;

@end
