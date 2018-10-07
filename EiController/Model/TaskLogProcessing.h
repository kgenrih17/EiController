//
//  TaskLogProcessing.h
//  EiController
//
//  Created by Genrih Korenujenko on 03.11.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskLogProcessing : NSObject

@property (nonatomic, readwrite) NSInteger itemId;
@property (nonatomic, readwrite) NSInteger taskId;
@property (nonatomic, readwrite) NSInteger timestamp;
@property (nonatomic, readwrite, copy) NSString *fingerprint;
@property (nonatomic, readwrite, copy) NSString *message;

+(instancetype)create:(NSDictionary*)dic;

@end
