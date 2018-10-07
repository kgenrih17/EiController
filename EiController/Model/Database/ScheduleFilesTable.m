//
//  ScheduleFilesTable.m
//  EiController
//
//  Created by Genrih Korenujenko on 27.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ScheduleFilesTable.h"
#import "DataBaseStorage.h"
#import "UploadFileStatus.h"

@implementation ScheduleFilesTable

#pragma mark - Private Methods
-(NSString*)name
{
    return @"ScheduleFiles";
}

-(NSArray*)columns
{
    return @[@"uniq", @"fingerprint", @"md5", @"file_url", @"local_path", @"file_size", @"es_id"];
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

#pragma mark - FileInfoStorageInterface
-(void)updateItems:(NSArray<id<FileInfoInterface>>*)items
{
    DataBaseStorage *storage = [DataBaseStorage new];
    NSMutableArray *columns = [NSMutableArray arrayWithArray:[self columns]];
    
    for (ScheduleFile *item in items)
    {
        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)", [self name], [columns componentsJoinedByString:@","], [self questionMarks:columns.count]];
        [storage transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.unique],
                                                [NSString valueOrEmptyString:item.fingerprint],
                                                [NSString valueOrEmptyString:item.md5],
                                                [NSString valueOrEmptyString:item.fileUrl],
                                                [NSString valueOrEmptyString:item.localPath],
                                                @(item.fileSize),
                                                [NSString valueOrEmptyString:item.esID]]];
    }
}

-(NSMutableArray<ScheduleFile*>*)getBy:(NSString*)fingerprint
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            ScheduleFile *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(NSMutableArray<ScheduleFile*>*)getNotDownload
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT sf.* FROM %@ sf INNER JOIN DownloadFileStatuses dfs ON dfs.is_downloaded=0 AND sf.uniq=dfs.file_id", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            ScheduleFile *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(NSMutableArray<ScheduleFile*>*)getNotUpload:(NSString*)fingerprint
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT sf.* FROM %@ sf WHERE sf.uniq IN (SELECT dfs.file_id FROM DownloadFileStatuses dfs INNER JOIN UploadFileStatuses ufs ON ufs.file_id = dfs.file_id AND ufs.fingerprint = dfs.fingerprint WHERE ufs.is_uploaded=0 AND ufs.destination=%tu AND dfs.is_downloaded=1 AND dfs.fingerprint='%@') AND sf.fingerprint='%@'", [self name], EINODE_DESTINATION, fingerprint, fingerprint];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            ScheduleFile *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(NSMutableArray<ScheduleFile*>*)getDuplicatePointers:(NSString*)fingerprint
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uniq IN (SELECT uniq FROM %@ WHERE fingerprint=?) AND fingerprint!=? GROUP BY fingerprint", [self name], [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint],
                                                      [NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            ScheduleFile *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(void)update:(ScheduleFile*)item
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET local_path=?, file_size=? WHERE uniq=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.localPath],
                                                          @(item.fileSize),
                                                          [NSString valueOrEmptyString:item.unique]]];
}

-(void)removeBy:(NSString*)fingerprint
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]]];
}

-(void)removeItems:(NSArray<ScheduleFile*>*)items
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fingerprint=? AND uniq=?", [self name]];
    DataBaseStorage *dataBaseStorage = [DataBaseStorage new];
    for (ScheduleFile *item in items)
    {
        [dataBaseStorage transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.fingerprint],
                                                        [NSString valueOrEmptyString:item.unique]]];
    }
}

-(NSMutableArray<id<FileInfoInterface>>*)getAllNotUpload
{
    return nil;
}

-(id<FileInfoInterface>)getByMD5:(NSString*)md5 fingerprint:(NSString*)fingerprint
{
    __block ScheduleFile *item = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE md5=? AND fingerprint=?", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:md5],
                                                      [NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        if ([resultSet next])
            item = [self parse:resultSet];
    }];
    return item;
}

#pragma mark - Public Methods
-(NSMutableArray<ScheduleFile*>*)getAll
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
     {
         while ([resultSet next])
         {
             ScheduleFile *item = [self parse:resultSet];
             [result addObject:item];
         }
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
-(ScheduleFile*)parse:(FMResultSet*)set
{
    ScheduleFile *item = [ScheduleFile new];
    item.unique = [set stringForColumn:@"uniq"];
    item.fingerprint = [set stringForColumn:@"fingerprint"];
    item.md5 = [set stringForColumn:@"md5"];
    item.fileUrl = [set stringForColumn:@"file_url"];
    item.localPath = [set stringForColumn:@"local_path"];
    item.esID = [set stringForColumn:@"es_id"];
    item.fileSize = [set intForColumn:@"file_size"];
    return item;
}

@end
