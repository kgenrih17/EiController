//
//  DeviceSyncStatus.h
//  EiController
//
//  Created by Genrih Korenujenko on 25.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EDeviceSyncProcessing)
{
    SYNCED = 0,
    WAITING_SYNC,
    SYNCHRONIZING,
    END_SYNC,
    ERROR_SYNC
};

@interface DeviceSyncStatus : NSObject

@property (nonatomic, readwrite) NSInteger itemId;
@property (nonatomic, readwrite) EDeviceSyncProcessing processing;
@property (nonatomic, readwrite) NSInteger lastTimestamp;
@property (nonatomic, readwrite, copy) NSString *fingerprint;
@property (nonatomic, readwrite, copy) NSString *message;

@end
