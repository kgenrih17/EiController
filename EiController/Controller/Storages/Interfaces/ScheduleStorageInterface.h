//
//  ScheduleStorageInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 21.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "StorageInterface.h"
#import "ScheduleStorageListener.h"
#import "Schedule.h"

@protocol ScheduleStorageInterface <StorageInterface>

@required
-(void)update:(Schedule*)item;
-(Schedule*)getByFingerprint:(NSString*)fingerprint;
-(Schedule*)getByMD5:(NSString*)md5 fingerprint:(NSString*)fingerprint;
-(NSMutableArray<Schedule*>*)getNotUpload;
-(void)removeBy:(NSString*)fingerprint;
-(void)setListener:(id<ScheduleStorageListener>)listener;

@end
