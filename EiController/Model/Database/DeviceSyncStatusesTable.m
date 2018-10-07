//
//  OSSyncStatuses.m
//  EiController
//
//  Created by Genrih Korenujenko on 25.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DeviceSyncStatusesTable.h"
#import "DataBaseStorage.h"

@implementation DeviceSyncStatusesTable

#pragma mark - Private Methods
-(NSString*)name
{
    return @"DeviceSyncStatuses";
}

-(NSArray*)columns
{
    return @[@"fingerprint", @"message", @"processing", @"last_timestamp"];
}

-(NSString*)questionMarks:(NSInteger)count
{
    NSMutableString *marks = [NSMutableString new];
    for (NSInteger index = 1; index <= count; index++)
    {
        if (index < count)
            [marks appendFormat:@"?,"];
        else
            [marks appendString:@"?"];
    }
    return marks;
}

#pragma mark - Public Methods
-(void)update:(DeviceSyncStatus*)item
{
    NSArray *columns = [self columns];
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)", [self name], [columns componentsJoinedByString:@","], [self questionMarks:columns.count]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.fingerprint],
                                                          [NSString valueOrEmptyString:item.message],
                                                          @(item.processing),
                                                          @(item.lastTimestamp)]];
}

-(void)updateItems:(NSArray<DeviceSyncStatus*>*)items
{
    NSArray *columns = [self columns];
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)", [self name], [columns componentsJoinedByString:@","], [self questionMarks:columns.count]];
    DataBaseStorage *dataBaseStorage = [DataBaseStorage new];
    for (DeviceSyncStatus *item in items)
    {
        [dataBaseStorage transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.fingerprint],
                                                              [NSString valueOrEmptyString:item.message],
                                                              @(item.processing),
                                                              @(item.lastTimestamp)]];
    }
}

-(NSMutableDictionary<NSString*,DeviceSyncStatus*>*)getByFingerprints:(NSArray<NSString*>*)fingerprints
{
    NSMutableSet *set = [NSMutableSet setWithArray:fingerprints];
    NSMutableDictionary *result = [NSMutableDictionary new];
    NSMutableString * fingers = [NSMutableString new];
    for (NSString *fingerprint in set.allObjects)
    {
        if ([fingerprint isEqualToString:set.allObjects.lastObject])
            [fingers appendFormat:@"'%@'", fingerprint];
        else
            [fingers appendFormat:@"'%@',", fingerprint];
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE fingerprint IN (%@)", [self name], fingers];
    
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
     {
         while ([resultSet next])
         {
             DeviceSyncStatus *item = [self parse:resultSet];
             [result setObject:item forKey:item.fingerprint];
         }
     }];
    return result;
}

-(NSArray<DeviceSyncStatus*>*)getWithProgressWaitingAndSync
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE processing = %tu OR processing = %tu", [self name], WAITING_SYNC,
                     SYNCHRONIZING];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            DeviceSyncStatus *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(void)removeBy:(NSString*)fingerprint
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]]];
}

#pragma mark - Public Methods
-(NSMutableArray<DeviceSyncStatus*>*)getAll
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [self name]];
    
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            DeviceSyncStatus *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(DeviceSyncStatus*)getByFingerprint:(NSString*)fingerprint
{
    __block DeviceSyncStatus *result = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE fingerprint=?", [self name]];
    
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        if ([resultSet next])
            result = [self parse:resultSet];
    }];
    return result;
}

#pragma mark - DatabaseTableInterface
-(void)clear
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:nil];
}

#pragma mark - Parse Methods
-(DeviceSyncStatus*)parse:(FMResultSet*)set
{
    DeviceSyncStatus *item = [DeviceSyncStatus new];
    item.processing = [set intForColumn:@"processing"];
    item.lastTimestamp = [set intForColumn:@"last_timestamp"];
    item.fingerprint = [set stringForColumn:@"fingerprint"];
    item.message = [set stringForColumn:@"message"];
    
    return item;
}

@end
