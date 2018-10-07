//
//  DownloadFileStatusesTable.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DatabaseTableInterface.h"
#import "DownloadFileStatusStorageInterface.h"
#import "DownloadFileStatus.h"

@interface DownloadFileStatusesTable : NSObject <DatabaseTableInterface, DownloadFileStatusStorageInterface>

-(NSMutableArray<DownloadFileStatus*>*)getAll;
-(NSMutableArray<DownloadFileStatus*>*)getByFingerprint:(NSString*)fingerprint;
-(void)remove:(DownloadFileStatus*)item;

@end
