//
//  FileInfoStorageInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "StorageInterface.h"
#import "FileInfoInterface.h"

@protocol FileInfoStorageInterface <StorageInterface>

@required
-(void)updateItems:(NSArray<id<FileInfoInterface>>*)items;
-(void)update:(id<FileInfoInterface>)item;
-(NSMutableArray<id<FileInfoInterface>>*)getBy:(NSString*)fingerprint;
-(NSMutableArray<id<FileInfoInterface>>*)getNotDownload;
-(NSMutableArray<id<FileInfoInterface>>*)getNotUpload:(NSString*)fingerprint;
-(NSMutableArray<id<FileInfoInterface>>*)getAllNotUpload;
-(NSMutableArray<id<FileInfoInterface>>*)getDuplicatePointers:(NSString*)fingerprint;
-(id<FileInfoInterface>)getByMD5:(NSString*)md5 fingerprint:(NSString*)fingerprint;
-(void)removeBy:(NSString*)fingerprint;
-(void)removeItems:(NSArray<id<FileInfoInterface>>*)items;

@end
