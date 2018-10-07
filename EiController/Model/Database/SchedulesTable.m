//
//  SchedulesTable.m
//  EiController
//
//  Created by Genrih Korenujenko on 22.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "SchedulesTable.h"
#import "DataBaseStorage.h"
#import "UploadFileStatus.h"

@implementation SchedulesTable

#pragma mark - Private Methods
-(NSString*)name
{
    return @"Schedules";
}

-(NSArray*)columns
{
    return @[@"fingerprint", @"details", @"md5"];
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
-(void)update:(NSArray<Schedule*>*)items
{
    NSMutableArray *columns = [NSMutableArray arrayWithArray:[self columns]];
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)", [self name], [columns componentsJoinedByString:@","], [self questionMarks:columns.count]];
    DataBaseStorage *storage = [DataBaseStorage new];
    
    for (Schedule *item in items)
    {
        [storage transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.fingerprint],
                                                [NSString valueOrEmptyString:item.details],
                                                [NSString valueOrEmptyString:item.md5]]];
    }
}

-(NSMutableArray<Schedule*>*)getAll
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            Schedule *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(NSMutableArray<Schedule*>*)getNotUpload
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT s.* FROM %@ s WHERE s.fingerprint IN (SELECT dfs.fingerprint FROM DownloadFileStatuses dfs INNER JOIN UploadFileStatuses ufs ON ufs.file_id = dfs.file_id AND ufs.fingerprint = dfs.fingerprint WHERE ufs.is_uploaded=0 AND ufs.destination=%tu AND dfs.is_downloaded=1) AND s.fingerprint IN (SELECT dfs.fingerprint FROM (SELECT fingerprint from (SELECT fingerprint,min(is_downloaded) as t1 From DownloadFileStatuses group by fingerprint) WHERE t1=1) as dfs INNER JOIN (SELECT fingerprint FROM UploadFileStatuses WHERE is_uploaded = 0 AND destination=%tu GROUP BY fingerprint) as ufs ON ufs.fingerprint = dfs.fingerprint)", [self name], EINODE_DESTINATION, EINODE_DESTINATION];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            Schedule *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(Schedule*)getByFingerprint:(NSString*)fingerprint
{
    __block Schedule *result = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE fingerprint=? GROUP BY fingerprint", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        if ([resultSet next])
            result = [self parse:resultSet];
    }];
    return result;
}

-(Schedule*)getByMD5:(NSString*)md5 fingerprint:(NSString*)fingerprint
{
    __block Schedule *result = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE md5=? AND fingerprint=?", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:md5],
                                                      [NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        if ([resultSet next])
            result = [self parse:resultSet];
    }];
    return result;
}

-(void)removeBy:(NSString*)fingerprint
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[fingerprint]];
}

#pragma mark - DatabaseTableInterface
-(void)clear
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:nil];
}

#pragma mark - Parse Methods
-(Schedule*)parse:(FMResultSet*)set
{
    Schedule *item = [Schedule new];
    item.fingerprint = [set stringForColumn:@"fingerprint"];
    item.details = [set stringForColumn:@"details"];
    item.md5 = [set stringForColumn:@"md5"];
    return item;
}

@end
