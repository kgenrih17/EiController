//
//  LogFilesTable.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "LogFilesTable.h"
#import "DataBaseStorage.h"
#import "UploadFileStatus.h"

@implementation LogFilesTable

#pragma mark - Private Methods
-(NSString*)name
{
    return @"LogFiles";
}

-(NSArray*)columns
{
    return @[@"uniq", @"fingerprint", @"file_url", @"local_path", @"file_size"];
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
    NSArray *columns = [self columns];
    DataBaseStorage *storage = [DataBaseStorage new];
    for (LogFile *item in items)
    {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", [self name], [columns componentsJoinedByString:@","], [self questionMarks:columns.count]];
        [storage transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.unique],
                                                [NSString valueOrEmptyString:item.fingerprint],
                                                [NSString valueOrEmptyString:item.fileUrl],
                                                [NSString valueOrEmptyString:item.localPath],
                                                @(item.fileSize)]];
    }
}

-(void)update:(LogFile*)item
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET local_path=?, file_size=? WHERE uniq=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.localPath],
                                                          @(item.fileSize),
                                                          [NSString valueOrEmptyString:item.unique]]];
}

-(NSMutableArray<LogFile*>*)getNotUpload:(NSString*)fingerprint
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT lf.* FROM %@ lf INNER JOIN DownloadFileStatuses dfs ON dfs.is_downloaded=1 AND lf.uniq=dfs.file_id INNER JOIN UploadFileStatuses ufs ON ufs.is_uploaded=0 AND lf.uniq=dfs.file_id WHERE lf.fingerprint = ? GROUP BY lf.uniq", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            LogFile *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(NSMutableArray<LogFile*>*)getAllNotUpload
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT lf.* FROM %@ lf WHERE lf.uniq IN (SELECT dfs.file_id FROM DownloadFileStatuses dfs INNER JOIN UploadFileStatuses ufs ON ufs.file_id = dfs.file_id WHERE ufs.is_uploaded=0 AND ufs.destination=%tu AND dfs.is_downloaded=1)", [self name], CENTRAL_DESTINATION];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            LogFile *item = [self parse:resultSet];
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

-(NSMutableArray<id<FileInfoInterface>>*)getBy:(NSString*)fingerprint
{
    return nil;
}

-(NSMutableArray<id<FileInfoInterface>>*)getDuplicatePointers:(NSString*)fingerprint
{
    return nil;
}

-(NSMutableArray<id<FileInfoInterface>>*)getNotDownload
{
    return nil;
}

-(void)removeItems:(NSArray<id<FileInfoInterface>>*)items
{
    
}

-(id<FileInfoInterface>)getByMD5:(NSString*)md5 fingerprint:(NSString*)fingerprint
{
    return nil;
}

#pragma mark - Public Methods
-(NSMutableArray<LogFile*>*)getAll
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
     {
         while ([resultSet next])
         {
             LogFile *item = [self parse:resultSet];
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
-(LogFile*)parse:(FMResultSet*)set
{
    LogFile *item = [LogFile new];
    item.unique = [set stringForColumn:@"uniq"];
    item.fingerprint = [set stringForColumn:@"fingerprint"];
    item.fileUrl = [set stringForColumn:@"file_url"];
    item.localPath = [set stringForColumn:@"local_path"];
    item.fileSize = [set intForColumn:@"file_size"];
    return item;
}

@end
