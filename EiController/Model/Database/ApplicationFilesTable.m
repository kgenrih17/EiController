//
//  ApplicationFilesTable.m
//  EiController
//
//  Created by Genrih Korenujenko on 23.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "ApplicationFilesTable.h"
#import "DataBaseStorage.h"
#import "UploadFileStatus.h"

@implementation ApplicationFilesTable

#pragma mark - Private Methods
-(NSString*)name
{
    return @"ApplicationFiles";
}

-(NSArray*)columns
{
    return @[@"uniq", @"fingerprint", @"file_url", @"local_path", @"file_name", @"file_size"];

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
    NSMutableArray *columns = [NSMutableArray arrayWithArray:[self columns]];
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)", [self name], [columns componentsJoinedByString:@","], [self questionMarks:columns.count]];
    DataBaseStorage *storage = [DataBaseStorage new];
    
    for (ApplicationFile *item in items)
    {
        [storage transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.unique],
                                                [NSString valueOrEmptyString:item.fingerprint],
                                                [NSString valueOrEmptyString:item.fileUrl],
                                                [NSString valueOrEmptyString:item.localPath],
                                                [NSString valueOrEmptyString:item.fileName],
                                                @(item.fileSize)]];
    }
}

-(void)update:(ApplicationFile*)item
{
    [self updateItems:@[item]];
}

-(NSMutableArray<ApplicationFile*>*)getBy:(NSString*)fingerprint
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
     {
         while ([resultSet next])
         {
             ApplicationFile *item = [self parse:resultSet];
             [result addObject:item];
         }
     }];
    return result;
}

-(NSMutableArray<ApplicationFile*>*)getNotDownload
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT a.* FROM %@ a INNER JOIN DownloadFileStatuses dfs ON dfs.is_downloaded=0 AND a.uniq=dfs.file_id GROUP BY a.uniq", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            ApplicationFile *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(NSMutableArray<ApplicationFile*>*)getNotUpload:(NSString*)fingerprint
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT af.* FROM %@ af WHERE af.uniq IN (SELECT dfs.file_id FROM DownloadFileStatuses dfs INNER JOIN UploadFileStatuses ufs ON ufs.file_id = dfs.file_id AND ufs.fingerprint = dfs.fingerprint WHERE ufs.is_uploaded=0 AND ufs.destination=%tu AND dfs.is_downloaded=1 AND dfs.fingerprint='%@') AND af.fingerprint='%@'", [self name], EINODE_DESTINATION, fingerprint, fingerprint];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            ApplicationFile *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(NSMutableArray<ApplicationFile*>*)getDuplicatePointers:(NSString*)fingerprint
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE uniq IN (SELECT uniq FROM %@ WHERE fingerprint=?) AND fingerprint!=? GROUP BY fingerprint", [self name], [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint],
                                                      [NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            ApplicationFile *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(ApplicationFile*)getByMD5:(NSString*)md5 fingerprint:(NSString*)fingerprint
{
    return nil;
}

-(void)removeBy:(NSString*)fingerprint
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]]];
}

-(void)removeItems:(NSArray<ApplicationFile*>*)items
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fingerprint=? AND uniq=?", [self name]];
    DataBaseStorage *dataBaseStorage = [DataBaseStorage new];
    for (ApplicationFile *item in items)
    {
        [dataBaseStorage transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.fingerprint],
                                                        [NSString valueOrEmptyString:item.unique]]];
    }
}

-(NSMutableArray<id<FileInfoInterface>>*)getAllNotUpload
{
    return nil;
}

#pragma mark - Public Methods
-(void)remove:(ApplicationFile*)item
{
    [self removeBy:item.fingerprint];
}

#pragma mark - DatabaseTableInterface
-(void)clear
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:nil];
}

#pragma mark - Parse Methods
-(ApplicationFile*)parse:(FMResultSet*)set
{
    ApplicationFile *item = [ApplicationFile new];
    item.fingerprint = [set stringForColumn:@"fingerprint"];
    item.unique = [set stringForColumn:@"uniq"];
    item.fileUrl = [set stringForColumn:@"file_url"];
    item.localPath = [set stringForColumn:@"local_path"];
    item.fileName = [set stringForColumn:@"file_name"];
    item.fileSize = [set intForColumn:@"file_size"];
    return item;
}

@end
