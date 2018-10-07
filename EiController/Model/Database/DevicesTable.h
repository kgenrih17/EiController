//
//  DevicesTable.h
//  EiController
//
//  Created by Genrih Korenujenko on 13.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DatabaseTableInterface.h"
#import "Device.h"

@interface DevicesTable : NSObject <DatabaseTableInterface>

-(void)update:(NSArray<Device*>*)items;
-(NSMutableArray<Device*>*)getAll;
-(NSString*)getCompanyUniqByFingerprint:(NSString*)fingerprint;
-(void)removeByFingerprints:(NSArray<NSString*>*)fingerprints;

@end
