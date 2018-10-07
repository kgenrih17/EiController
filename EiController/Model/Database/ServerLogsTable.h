//
//  ServerLogsTable.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DatabaseTableInterface.h"
#import "ServerLogStorageInterface.h"
#import "ServerLog.h"

@interface ServerLogsTable : NSObject <DatabaseTableInterface, ServerLogStorageInterface>

-(NSMutableArray<ServerLog*>*)getAll;
-(void)remove:(ServerLog*)item;

@end
