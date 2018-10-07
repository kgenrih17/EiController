//
//  UploadFileStatusesTable.m
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "UploadFileStatusesTable.h"
#import "DataBaseStorage.h"

@implementation UploadFileStatusesTable

#pragma mark - Private Methods
-(NSString*)name
{
    return @"UploadFileStatuses";
}

-(NSArray*)columns
{
    return @[@"file_id", @"fingerprint", @"destination"];
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

#pragma mark - UploadFileStatusStorageInterface
-(void)update:(NSArray<UploadFileStatus*>*)items
{
    NSMutableArray *columns = [NSMutableArray arrayWithArray:[self columns]];
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)", [self name], [columns componentsJoinedByString:@","], [self questionMarks:columns.count]];
    DataBaseStorage *storage = [DataBaseStorage new];
    
    for (UploadFileStatus *item in items)
    {
        [storage transactionSQL:sql arguments:@[[NSString valueOrEmptyString:item.fileId],
                                                [NSString valueOrEmptyString:item.fingerprint],
                                                @(item.destination)]];
    }
}

-(void)updateFlag:(BOOL)isUpload code:(NSInteger)code byFileId:(NSString*)fileId fingerprint:(NSString*)fingerprint
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET is_uploaded=?, error_code=? WHERE file_id=? AND fingerprint=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[@(isUpload),
                                                          @(code),
                                                          [NSString valueOrEmptyString:fileId],
                                                          [NSString valueOrEmptyString:fingerprint]]];
}

-(void)updateFlag:(BOOL)isUpload code:(NSInteger)code fingerprints:(NSArray<NSString*>*)fingerprints
{
    NSMutableString *fings = [NSMutableString new];
    for (NSString *fing in fingerprints)
    {
        if ([fing isEqual:fingerprints.lastObject])
            [fings appendFormat:@"'%@'", fing];
        else
            [fings appendFormat:@"'%@',", fing];
    }
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET is_uploaded=?, error_code=? WHERE fingerprint IN (%@)", [self name], fings];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[@(isUpload), @(code)]];
}

-(void)removeBy:(NSString*)fingerprint
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]]];
}

#pragma mark - Public Methods
-(NSMutableArray<UploadFileStatus*>*)getAll
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            UploadFileStatus *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(NSMutableArray<UploadFileStatus*>*)getByFingerprint:(NSString*)fingerprint
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE fingerprint=?", [self name]];
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            UploadFileStatus *item = [self parse:resultSet];
            [result addObject:item];
        }
    }];
    return result;
}

-(void)remove:(UploadFileStatus*)item
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
-(UploadFileStatus*)parse:(FMResultSet*)set
{
    UploadFileStatus *item = [UploadFileStatus new];
    item.itemId = [set intForColumn:@"id"];
    item.errorCode = [set intForColumn:@"error_code"];
    item.isUpload = [set intForColumn:@"is_uploaded"];
    item.fileId = [set stringForColumn:@"file_id"];
    item.fingerprint = [set stringForColumn:@"fingerprint"];
    return item;
}

@end
