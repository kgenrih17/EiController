//
//  DataBaseStorage.m
//  EiController
//
//  Created by Genrih Korenujenko on 13.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DataBaseStorage.h"

@interface DataBaseStorage ()
{
    NSString *eicontrollerDatabaseName;
}

@end

@implementation DataBaseStorage

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        eicontrollerDatabaseName = @"eicontroller.sqlite";
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self pathToDataBase]])
            [self copyDatabaseFromBoundle];
    }
    return self;
}

-(void)copyDatabaseFromBoundle
{
    NSError *error = nil;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:eicontrollerDatabaseName];
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:defaultDBPath toPath:[self pathToDataBase] error:&error];
    if (!success)
        NSAssert1(NO, @"error of copy database file '%@'.", [error localizedDescription]);
}

-(NSString*)pathToDataBase
{
    return [[AppInfromation getPathToDocuments] stringByAppendingPathComponent:eicontrollerDatabaseName];
}

#pragma mark - Public Methods
-(void)transactionSQL:(NSString*)sql arguments:(NSArray*)arguments
{
    FMDatabaseQueue *databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self pathToDataBase]];
    [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
    {
        [db executeUpdate:sql withArgumentsInArray:arguments];
    }];
}

-(void)executeSQL:(NSString*)sql arguments:(NSArray*)arguments completion:(CallBack)completion
{
    FMDatabaseQueue *databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self pathToDataBase]];
    [databaseQueue inDatabase:^(FMDatabase *db)
    {
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:arguments];
        completion(resultSet);
        [resultSet close];
    }];
}

@end

//@interface DatabaseQueue : NSObject
//
//@property (nonatomic, readwrite, copy) NSString *sql;
//@property (nonatomic, readwrite, strong) NSArray *arguments;
//@property (nonatomic, readwrite) BOOL isTransaction;
//@property (nonatomic, readwrite, weak) CallBack completion;
//
//@end
//
//@implementation DatabaseQueue
//
//@end
//
//@interface DataBaseStorage ()
//{
//    NSMutableArray <DatabaseQueue*>*queues;
//    DatabaseQueue *currentQueue;
//}
//@end
//
//@implementation DataBaseStorage
//
//#pragma mark - Override Init Methods
//-(instancetype)init
//{
//    self = [self initWithDatabaseName:@"eicontroller.sqlite"];
//
//    if (self)
//    {
//        queues = [NSMutableArray new];
//        [database open];
//    }
//
//    return self;
//}
//
//-(void)dealloc
//{
//    [database close];
//    database = nil;
//    [queues removeAllObjects];
//    currentQueue = nil;
//}
//
//#pragma mark - Public Init Methods
//+(instancetype)storage
//{
//    static DataBaseStorage *storage = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{ storage = [self new]; });
//    return storage;
//}
//
//#pragma mark - Public Methods
//-(void)transactionSQL:(NSString*)sql arguments:(NSArray*)arguments
//{
//    [self addQueueWithTransaction:YES sql:sql arguments:arguments completion:nil];
//}
//
//-(void)executeSQL:(NSString*)sql arguments:(NSArray*)arguments completion:(CallBack)completion
//{
//    [self addQueueWithTransaction:NO sql:sql arguments:arguments completion:completion];
//}
//
//#pragma mark - Private Methods
//-(void)addQueueWithTransaction:(BOOL)isTransaction sql:(NSString*)sql arguments:(NSArray*)arguments completion:(CallBack)completion
//{
//    DatabaseQueue *queue = [DatabaseQueue new];
//    queue.sql = sql;
//    queue.arguments = arguments;
//    queue.isTransaction = isTransaction;
//    queue.completion = completion;
//
//    [queues addObject:queue];
//    [self nextQueue];
//}
//
//-(void)nextQueue
//{
//    dispatch_sync(dispatch_queue_create("database_storage_queue", NULL), ^
//    {
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//        if (!queues.isEmpty && (currentQueue == nil))
//        {
//            currentQueue = queues.firstObject;
//            [self performQueue];
//            [queues removeObject:currentQueue];
//            currentQueue = nil;
//            dispatch_semaphore_signal(semaphore);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
//            {
//                [self nextQueue];
//            });
//        }
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    });
//}
//
//-(void)performQueue
//{
//    if (currentQueue.isTransaction)
//        [self beginTransaction];
//    else if (currentQueue.completion != nil)
//        [self execute];
//}
//
//-(void)beginTransaction
//{
//    [database beginTransaction];
//    [database executeUpdate:currentQueue.sql withArgumentsInArray:currentQueue.arguments];
//    [database commit];
//}
//
//-(void)execute
//{
//    FMResultSet *resultSet = [database executeQuery:currentQueue.sql withArgumentsInArray:currentQueue.arguments];
//    currentQueue.completion(resultSet);
//}
//
//@end

