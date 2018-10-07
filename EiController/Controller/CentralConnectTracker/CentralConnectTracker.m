//
//  CentralConnectTracker.m
//  EiController
//
//  Created by Genrih Korenujenko on 27.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "CentralConnectTracker.h"

@interface CentralConnectTracker ()
{
    BOOL lastConnectionStableFlag;
    BOOL isStarted;
    NSTimer *repeatTimer;
}

@property (nonatomic, readwrite, strong) id <CentralAPIInterface> api;
@property (nonatomic, readwrite, weak) id <CentralConnectTrackerObserverInterface> observer;
@property (nonatomic, readwrite) NSInteger timeout;

@end

@implementation CentralConnectTracker

@synthesize api;
@synthesize observer;
@synthesize timeout;

+(instancetype)build:(id<CentralConnectTrackerObserverInterface>)observer
                 api:(id<CentralAPIInterface>)api
             timeout:(NSInteger)timeout
{
    CentralConnectTracker *result = [CentralConnectTracker new];
    result.observer = observer;
    result.api = api;
    result.timeout = (timeout > 0) ? timeout : 60;
    return result;
}

#pragma mark - Public Methods
-(void)start
{
    if (!isStarted)
    {
        isStarted = YES;
        [self checkConnection:@(YES)];
    }
}

-(void)stop
{
    if (isStarted)
    {
        [self pause:YES];
        if (lastConnectionStableFlag)
        {
            lastConnectionStableFlag = NO;
            [observer changeConnectionTo:lastConnectionStableFlag];
        }
        timeout = 0;
        api = nil;
        observer = nil;
        isStarted = NO;
    }
}

-(void)pause:(BOOL)isPause
{
    if (isPause)
    {
        [repeatTimer invalidate];
        repeatTimer = nil;
        [api cancel];
    }
    else
        [self checkConnection:nil];
}

-(BOOL)isStarted
{
    return isStarted;
}

-(BOOL)getLastConnectionStableFlag
{
    return lastConnectionStableFlag;
}

#pragma mark - Private Methods
-(void)checkConnection:(id)firstStart
{
    [api checkConnection:^(BOOL isSuccess)
    {
        if (lastConnectionStableFlag != isSuccess || ([[firstStart class] isSubclassOfClass:[NSNumber class]] && [firstStart boolValue] == YES))
        {
            lastConnectionStableFlag = isSuccess;
            [observer changeConnectionTo:isSuccess];
        }
        repeatTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:_cmd userInfo:nil repeats:NO];
    }];
}

@end
