//
//  StorageCleanerInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 15.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "StorageInterface.h"

@protocol StorageCleanerInterface <NSObject>

@required
-(void)clearDataForNewSchedule:(NSString*)fingerprint;
-(void)clearAllData;
-(void)clearUnnecessaryDeviceData:(NSArray<NSString*>*)fingerprints;

@end
