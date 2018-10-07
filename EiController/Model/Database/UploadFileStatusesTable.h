//
//  UploadFileStatusesTable.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DatabaseTableInterface.h"
#import "UploadFileStatusStorageInterface.h"
#import "UploadFileStatus.h"

@interface UploadFileStatusesTable : NSObject <DatabaseTableInterface, UploadFileStatusStorageInterface>

-(NSMutableArray<UploadFileStatus*>*)getAll;
-(NSMutableArray<UploadFileStatus*>*)getByFingerprint:(NSString*)fingerprint;
-(void)remove:(UploadFileStatus*)item;
-(void)updateFlag:(BOOL)isDownload code:(NSInteger)code fingerprints:(NSArray<NSString*>*)fingerprints;

@end
