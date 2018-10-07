//
//  DeviceActionStatus.m
//  EiController
//
//  Created by Genrih Korenujenko on 02.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "DeviceActionStatus.h"

@implementation DeviceActionStatus

@synthesize actionIndex;
@synthesize progress;
@synthesize errorText;
@synthesize info;
@synthesize percents;

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        percents = [NSMutableArray new];
        for (NSInteger index = 0; index < DEVICE_ACTIONS_COUNT; index++)
            [percents addObject:@([self getPercent:index])];
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
-(NSString*)getProgressTitle
{
    NSString *title = @"";
    NSArray *titles = @[@"Upload schedules", @"Upload applications", @"Download logs"];
    if ([titles isValidIndex:self.actionIndex])
        title = titles[self.actionIndex];
    else
        title = @"Completed";
    return title;
}

-(void)clear
{
    actionIndex = 0;
    progress = 0;
    errorText = nil;
    info = nil;
}

#pragma mark - Private Methods
-(CGFloat)getPercent:(NSInteger)index
{
    NSArray *percentsParts = @[@(35), @(35), @(30)];
    return [percentsParts[index] floatValue];
}

@end
