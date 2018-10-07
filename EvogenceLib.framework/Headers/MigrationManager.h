//
//  MigrationManager.h
//  MegrationDB
//
//  Created by Admin on 12/16/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "MigrationTable.h"
#import "MigrationField.h"

@interface MigrationManager : NSObject

@property (nonatomic, strong) NSString *pathToOldDB;
@property (nonatomic, strong) NSString *pathToNewDB;

-(instancetype)initWithPathOldDB:(NSString*)_oldPath andPathNewDB:(NSString*)_newPath;

-(BOOL)isNeedUpdate;
-(void)updateDatabase;

@end
