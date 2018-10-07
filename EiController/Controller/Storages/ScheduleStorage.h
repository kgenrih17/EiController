//
//  ScheduleStorage.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ScheduleStorageInterface.h"
#import "SchedulesTable.h"

@interface ScheduleStorage : NSObject <ScheduleStorageInterface>
{
    SchedulesTable *schedulesTable;
}

@property (nonatomic, readonly, weak) id <ScheduleStorageListener> listener;

@end
