//
//  Database version 1
//  Copyright (c) 2013 Radical Computing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Database : NSObject
{
    FMDatabase *database;
}

@property (nonatomic, strong) FMDatabase *database;

-(id)initWithDatabaseName:(NSString*)_databaseName;
-(void)clearTable:(NSString*)_table;
-(NSInteger)getSchemaVersion;
-(NSInteger)getUserVersion;

#pragma mark abstract methods
-(void)clear;

@end
