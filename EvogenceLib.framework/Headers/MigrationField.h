//
//  MigrationField.h
//  MegrationDB
//
//  Created by Admin on 12/16/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MigrationField : NSObject

@property (nonatomic) NSInteger cid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, getter=isNotNull) BOOL notNull;
@property (nonatomic, strong) NSString *defaultValue;
@property (nonatomic, getter=isPrimaryKey) BOOL primaryKey;
@property (nonatomic, getter=isAutoIncrement) BOOL autoIncrement;

@end
