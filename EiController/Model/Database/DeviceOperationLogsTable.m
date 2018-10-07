//
//  DeviceOperationLogsTable.m
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DeviceOperationLogsTable.h"
#import "DataBaseStorage.h"

@implementation DeviceOperationLogsTable

#pragma mark - Private Methods
-(NSString*)name
{
    return @"DeviceOperationLogs";
}

-(NSArray*)columns
{
    return @[@"action_title", @"error_code", @"timestamp", @"description", @"error_message", @"fingerprint"];
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

#pragma mark - IDeviceOperationLogStorage
-(void)add:(DeviceOperationLog*)item
{
    NSMutableArray *columns = [NSMutableArray arrayWithArray:[self columns]];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", [self name], [columns componentsJoinedByString:@","], [self questionMarks:columns.count]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[item.actionTitle,
                                                          @(item.errorCode),
                                                          @(item.timestamp),
                                                          [NSString valueOrEmptyString:item.desc],
                                                          [NSString valueOrEmptyString:item.errorMessage],
                                                          [NSString valueOrEmptyString:item.fingerprint]]];
}

-(NSMutableArray<DeviceOperationLog*>*)getByFingerprint:(NSString*)fingerprint
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            DeviceOperationLog *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(DeviceOperationLog*)getLastByFingerprint:(NSString*)fingerprint
{
    __block DeviceOperationLog *result = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE fingerprint=? ORDER BY timestamp DESC LIMIT 1", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        if ([resultSet next])
            result = [self parse:resultSet];
    }];
    return result;
}

-(void)clearByTimestamp:(NSInteger)timestamp
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE timestamp <= ?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[@(timestamp)]];
}

-(void)removeByFingerping:(NSString*)fingerprint
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]]];
}

#pragma mark - Public Methods
-(NSMutableArray<DeviceOperationLog*>*)getAll
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
     {
         while ([resultSet next])
         {
             DeviceOperationLog *item = [self parse:resultSet];
             [result addObject:item];
         }
     }];
    return result;
}

-(void)remove:(DeviceOperationLog*)item
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[@(item.itemId)]];
}

#pragma mark - DatabaseTableInterface
-(void)clear
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:nil];
}

#pragma mark - Parse Methods
-(DeviceOperationLog*)parse:(FMResultSet*)set
{
    DeviceOperationLog *item = [DeviceOperationLog new];
    item.itemId = [set intForColumn:@"id"];
    item.errorCode = [set intForColumn:@"error_code"];
    item.timestamp = [set intForColumn:@"timestamp"];
    item.actionTitle = [set stringForColumn:@"action_title"];
    item.desc = [set stringForColumn:@"description"];
    item.errorMessage = [set stringForColumn:@"error_message"];
    item.fingerprint = [set stringForColumn:@"fingerprint"];
    return item;
}

@end
