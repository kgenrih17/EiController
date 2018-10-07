//
//  MigrationTable.h
//  MegrationDB
//
//  Created by Admin on 12/16/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MigrationTable : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) NSString *sql;
@property (nonatomic, getter=isContainsAutoIncrement) BOOL containsAutoIncrement;

@end
