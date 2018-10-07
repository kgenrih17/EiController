//
//  DownloadFileStatusStorageInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "StorageInterface.h"
#import "DownloadFileStatus.h"

@protocol DownloadFileStatusStorageInterface <StorageInterface>

@required
-(void)update:(NSArray<DownloadFileStatus*>*)items;
-(void)updateFlag:(BOOL)isDownload code:(NSInteger)code byFileId:(NSString*)fileId fingerprint:(NSString*)fingerprint;
-(void)removeBy:(NSString*)fingerprint;

@end
