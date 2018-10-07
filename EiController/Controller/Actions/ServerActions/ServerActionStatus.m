//
//  ServerActionStatus.m
//  EiController
//
//  Created by Genrih Korenujenko on 21.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ServerActionStatus.h"

@implementation ServerActionStatus

@synthesize actionIndex;
@synthesize progress;
@synthesize errorText;
@synthesize info;
@synthesize percents;
@synthesize isProcessing;

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self clear];
        percents = [NSMutableArray new];
        for (NSInteger index = 0; index < SERVER_ACTIONS_COUNT; index++)
            [percents addObject:@([self getPercent:(EActionType)index])];
    }
    return self;
}

#pragma mark - Override Property Methods
-(void)setProgress:(CGFloat)newProgress
{
    CGFloat currentPercent = 0;
    for (NSInteger index = 0; index < actionIndex; index++)
        currentPercent += [percents[index] floatValue];
    
    if ([percents isValidIndex:actionIndex])
        progress = currentPercent + ([percents[actionIndex] floatValue] / 100.0 * newProgress);
    else
        progress = 100.0;
}

#pragma mark - ActionStatusInterface
-(NSString*)getServerName
{
    NSString *server = nil;
    if ([[self getProgressTitle] isEqualToString:@"Get apps"])
        server = @"EiPublisher";
    else
        server = @"EiCentral";
    return server;
}

-(NSString*)getProgressTitle
{
    NSString *title = @"";
    NSArray *titles = @[@"Update devices", @"Get schedules", @"Download schedules files", @"Get apps", @"Upload files"];
    if ([titles isValidIndex:actionIndex])
        title = titles[actionIndex];
    else
        title = @"Completed";
    return title;
}

-(void)clear
{
    actionIndex = 0;
    progress = 0;
    isProcessing = NO;
    errorText = nil;
    info = nil;
}

#pragma mark - Private Methods
-(CGFloat)getPercent:(NSInteger)index
{
    NSArray *percentsParts = @[@(6), @(10), @(36), @(36), @(12)];
    return [percentsParts[index] floatValue];
}

@end
