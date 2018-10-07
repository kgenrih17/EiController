//
//  ServerLogsTable.m
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ServerLogsTable.h"
#import "DataBaseStorage.h"

@implementation ServerLogsTable

#pragma mark - Private Methods
-(NSString*)name
{
    return @"ServerLogs";
}

-(NSArray*)columns
{
    return @[@"action_title", @"error_code", @"timestamp", @"server", @"description", @"error_message"];
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

#pragma mark - ServerLogStorageInterface
-(void)add:(ServerLog*)item
{
    NSMutableArray *columns = [NSMutableArray arrayWithArray:[self columns]];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", [self name], [columns componentsJoinedByString:@","], [self questionMarks:columns.count]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[item.actionTitle,
                                                          @(item.errorCode),
                                                          @(item.timestamp),
                                                          [NSString valueOrEmptyString:item.server],
                                                          [NSString valueOrEmptyString:item.desc],
                                                          [NSString valueOrEmptyString:item.errorMessage]]];
}

-(NSMutableArray<ServerLog*>*)getBy:(NSInteger)timestamp
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE timestamp >= ?", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[@(timestamp)] completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            ServerLog *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(void)clearByTimestamp:(NSInteger)timestamp
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE timestamp <= ?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[@(timestamp)]];
}

#pragma mark - Public Methods
-(NSMutableArray<ServerLog*>*)getAll
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
     {
         while ([resultSet next])
         {
             ServerLog *item = [self parse:resultSet];
             [result addObject:item];
         }
     }];
    return result;
}

-(void)remove:(ServerLog*)item
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
-(ServerLog*)parse:(FMResultSet*)set
{
    ServerLog *item = [ServerLog new];
    item.itemId = [set intForColumn:@"id"];
    item.errorCode = [set intForColumn:@"error_code"];
    item.timestamp = [set intForColumn:@"timestamp"];
    item.actionTitle = [set stringForColumn:@"action_title"];
    item.errorMessage = [set stringForColumn:@"error_message"];
    item.server = [set stringForColumn:@"server"];
    item.desc = [set stringForColumn:@"description"];
    return item;
}

@end
