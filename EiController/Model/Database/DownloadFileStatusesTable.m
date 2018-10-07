//
//  DownloadFileStatusesTable.m
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DownloadFileStatusesTable.h"
#import "DataBaseStorage.h"

@implementation DownloadFileStatusesTable

#pragma mark - Private Methods
-(NSString*)name
{
    return @"DownloadFileStatuses";
}

-(NSArray*)columns
{
    return @[@"file_id", @"fingerprint"];
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

#pragma mark - DownloadFileStatusStorageInterface
-(void)update:(NSArray<DownloadFileStatus*>*)items
{
    NSMutableArray *columns = [NSMutableArray arrayWithArray:[self columns]];
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)", [self name], [columns componentsJoinedByString:@","], [self questionMarks:columns.count]];
    DataBaseStorage *storage = [DataBaseStorage new];
    
    for (DownloadFileStatus *item in items)
    {
        [storage transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.fileId],
                                                [NSString valueOrEmptyString:item.fingerprint]]];
    }
}

-(void)updateFlag:(BOOL)isDownload code:(NSInteger)code byFileId:(NSString*)fileId fingerprint:(NSString*)fingerprint
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET is_downloaded=?, error_code=? WHERE file_id=? AND fingerprint=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[@(isDownload),
                                                          @(code),
                                                          [NSString valueOrEmptyString:fileId],
                                                          [NSString valueOrEmptyString:fingerprint]]];
}

-(void)removeBy:(NSString*)fingerprint
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]]];
}

#pragma mark - Public Methods
-(NSMutableArray<DownloadFileStatus*>*)getAll
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            DownloadFileStatus *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(NSMutableArray<DownloadFileStatus*>*)getByFingerprint:(NSString*)fingerprint
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            DownloadFileStatus *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(void)remove:(DownloadFileStatus*)item
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE file_id=? AND fingerprint=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.fileId],
                                                          [NSString valueOrEmptyString:item.fingerprint]]];
}

#pragma mark - DatabaseTableInterface
-(void)clear
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:nil];
}

#pragma mark - Parse Methods
-(DownloadFileStatus*)parse:(FMResultSet*)set
{
    DownloadFileStatus *item = [DownloadFileStatus new];
    item.itemId = [set intForColumn:@"id"];
    item.errorCode = [set intForColumn:@"error_code"];
    item.isDownloaded = [set intForColumn:@"is_downloaded"];
    item.fileId = [set stringForColumn:@"file_id"];
    item.fingerprint = [set stringForColumn:@"fingerprint"];
    return item;
}

@end
