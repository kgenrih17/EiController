//
//  SchedulesTable.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DatabaseTableInterface.h"
#import "Schedule.h"

@interface SchedulesTable : NSObject <DatabaseTableInterface>

-(void)update:(NSArray<Schedule*>*)items;
-(NSMutableArray<Schedule*>*)getAll;
-(NSMutableArray<Schedule*>*)getNotUpload;
-(Schedule*)getByFingerprint:(NSString*)fingerprint;
-(Schedule*)getByMD5:(NSString*)md5 fingerprint:(NSString*)fingerprint;
-(void)removeBy:(NSString*)fingerprint;

@end
