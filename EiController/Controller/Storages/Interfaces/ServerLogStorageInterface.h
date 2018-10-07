//
//  ServerLogStorageInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "StorageInterface.h"
#import "ServerLog.h"

@protocol ServerLogStorageInterface <StorageInterface>

@required
-(void)add:(ServerLog*)item;
-(NSMutableArray<ServerLog*>*)getBy:(NSInteger)timestamp;
-(void)clearByTimestamp:(NSInteger)timestamp;

@end
