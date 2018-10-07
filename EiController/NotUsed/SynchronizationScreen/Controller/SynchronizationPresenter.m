//
//  SynchronizationPresenter.m
//  EiController
//
//  Created by Genrih Korenujenko on 18.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "SynchronizationPresenter.h"

@implementation SynchronizationPresenter

@synthesize screen, authInterface;

#pragma mark - Init
+(instancetype)build:(id<SynchronizationScreenInterface>)screenInterface
       authInterface:(id<AuthInterface>)authInterface
{
    SynchronizationPresenter *result = [self new];
    result.screen = screenInterface;
    result.authInterface = authInterface;
    return result;
}

-(void)dealloc
{
    screen = nil;
    authInterface = nil;
}

#pragma mark - Public Methods
-(void)onCreate
{
    SynchronizationViewModel *viewModel = [self createViewModel];
    [screen refresh:viewModel];
}

-(void)accept:(SynchronizationViewModel*)viewModel
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger interval = viewModel.interval.integerValue * SECOND_IN_ONE_HOUR;
    [userDefaults setInteger:interval forKey:CENTRAL_SYNC_TIMEOUT_KEY];
    [userDefaults setBool:viewModel.isShowStatusState forKey:CENTRAL_SYNC_STATUS_KEY];
    [userDefaults setBool:viewModel.isAutoSync forKey:CENTRAL_AUTO_SYNC_KEY];
    [authInterface updateSyncSettings];
    [screen close];
}

#pragma mark - Private Methods
-(SynchronizationViewModel*)createViewModel
{
    SynchronizationViewModel *model = [SynchronizationViewModel new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger syncTimeout = [userDefaults integerForKey:CENTRAL_SYNC_TIMEOUT_KEY];
    NSInteger interval = (syncTimeout == 0) ? SECONDS_IN_5_MINS : syncTimeout;
    model.interval = @(interval / SECOND_IN_ONE_HOUR).stringValue;
    model.isShowStatusState = [userDefaults boolForKey:CENTRAL_SYNC_STATUS_KEY];
    model.isAutoSync = [userDefaults boolForKey:CENTRAL_AUTO_SYNC_KEY];
    return model;
}

@end
