//
//  DevicesTable.m
//  EiController
//
//  Created by Genrih Korenujenko on 13.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DevicesTable.h"
#import "DataBaseStorage.h"

@interface DevicesTable ()

@end

@implementation DevicesTable

#pragma mark - Private Methods
-(NSString*)name
{
    return @"Devices";
}

-(NSArray*)columns
{
    return @[@"fingerprint", @"title", @"system_id", @"serial_number", @"version", @"edition", @"model", @"company_unique", @"timezone"];
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
-(void)update:(NSArray<Device*>*)items
{
    NSArray *columns = [self columns];
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)", [self name], [columns componentsJoinedByString:@","], [self questionMarks:columns.count]];
    DataBaseStorage *storage = [DataBaseStorage new];
    
    for (Device *device in items)
    {
        [storage transactionSQL:sql arguments:@[[NSString valueOrEmptyString:device.fingerprint],
                                                [NSString valueOrEmptyString:device.title],
                                                [NSString valueOrEmptyString:device.sid],
                                                [NSString valueOrEmptyString:device.sn],
                                                [NSString valueOrEmptyString:device.version],
                                                [NSString valueOrEmptyString:device.edition],
                                                [NSString valueOrEmptyString:device.model],
                                                [NSString valueOrEmptyString:device.company],
                                                [NSString valueOrEmptyString:device.timezone]]];
    }
}

-(NSMutableArray<Device*>*)getAll
{
    NSMutableArray *result = [NSMutableArray new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [self name]];
    
    [[DataBaseStorage new] executeSQL:sql arguments:nil completion:^(FMResultSet *resultSet)
    {
        while ([resultSet next])
        {
            Device *device = [self parse:resultSet];
            [result addObject:device];
        }
    }];
    return result;
}

-(NSString*)getCompanyUniqByFingerprint:(NSString*)fingerprint
{
    __block NSString *result = @"";
    NSString *sql = [NSString stringWithFormat:@"SELECT company_unique FROM %@ WHERE fingerprint=?", [self name]];
    
    [[DataBaseStorage new] executeSQL:sql arguments:@[[NSString valueOrEmptyString:fingerprint]] completion:^(FMResultSet *resultSet)
    {
        if ([resultSet next])
            result = [resultSet stringForColumn:@"company_unique"];
    }];
    return result;
}

-(void)removeByFingerprints:(NSArray<NSString*>*)fingerprints
{
    NSMutableString * fingers = [NSMutableString new];
    for (NSString *fingerprint in fingerprints)
    {
        if ([fingerprint isEqualToString:fingerprints.lastObject])
            [fingers appendFormat:@"'%@'", fingerprint];
        else
            [fingers appendFormat:@"'%@',", fingerprint];
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fingerprint IN (%@)", [self name], fingers];
    [[DataBaseStorage new] transactionSQL:sql arguments:nil];
}

#pragma mark - DatabaseTableInterface
-(void)clear
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [self name]];
    [[DataBaseStorage new] transactionSQL:sql arguments:nil];
}

#pragma mark - Parse Methods
-(Device*)parse:(FMResultSet*)set
{
    Device *item = [Device new];
    item.fingerprint = [set stringForColumn:@"fingerprint"];
    item.title = [set stringForColumn:@"title"];
    item.sid = [set stringForColumn:@"system_id"];
    item.sn = [set stringForColumn:@"serial_number"];
    item.version = [set stringForColumn:@"version"];
    item.edition = [set stringForColumn:@"edition"];
    item.model = [set stringForColumn:@"model"];
    item.company = [set stringForColumn:@"company_unique"];
    item.timezone = [set stringForColumn:@"timezone"];
    
    return item;
}

@end
