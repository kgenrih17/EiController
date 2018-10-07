//
//  ScheduleStorage.m
//  EiController
//
//  Created by Genrih Korenujenko on 22.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ScheduleStorage.h"

@implementation ScheduleStorage

@synthesize listener;

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    if (self)
        schedulesTable = [SchedulesTable new];
    return self;
}

#pragma mark - ScheduleStorageInterface
-(void)update:(Schedule*)item
{
    [self findDuplicate:item];
    [schedulesTable update:@[item]];
}

-(Schedule*)getByFingerprint:(NSString*)fingerprint
{
    return [schedulesTable getByFingerprint:fingerprint];
}

-(Schedule*)getByMD5:(NSString*)md5 fingerprint:(NSString*)fingerprint
{
    return [schedulesTable getByMD5:md5 fingerprint:fingerprint];
}

-(NSMutableArray<Schedule*>*)getNotUpload
{
    return [schedulesTable getNotUpload];
}

-(void)removeBy:(NSString*)fingerprint
{
    [schedulesTable removeBy:fingerprint];
}

-(void)clear
{
    [schedulesTable clear];
}

-(void)setListener:(id<ScheduleStorageListener>)newListener
{
    listener = newListener;
}

#pragma mark - Private Methods
-(void)findDuplicate:(Schedule*)item
{
    Schedule *schedule = [schedulesTable getByFingerprint:item.fingerprint];
    if (schedule != nil)
        [listener previousScheduleFoundFor:schedule.fingerprint];
}

@end
