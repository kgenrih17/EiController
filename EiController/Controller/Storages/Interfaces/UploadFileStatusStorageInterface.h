//
//  UploadFileStatusStorageInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "StorageInterface.h"
#import "UploadFileStatus.h"

@protocol UploadFileStatusStorageInterface <StorageInterface>

@required
-(void)update:(NSArray<UploadFileStatus*>*)items;
-(void)updateFlag:(BOOL)isUpload code:(NSInteger)code byFileId:(NSString*)fileId fingerprint:(NSString*)fingerprint;
-(void)removeBy:(NSString*)fingerprint;

@end
