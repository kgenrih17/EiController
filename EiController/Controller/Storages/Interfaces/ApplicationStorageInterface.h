//
//  ApplicationStorageInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 23.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "StorageInterface.h"
#import "Application.h"

@protocol ApplicationStorageInterface <StorageInterface>

@required
-(void)update:(Application*)item;
-(Application*)getBy:(NSString*)fingerprint;
-(void)removeBy:(NSString*)fingerprint;
-(NSMutableArray<Application*>*)getNotUpload;
-(Application*)getByMD5:(NSString*)md5;

@end
