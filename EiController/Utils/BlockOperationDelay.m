//
//  BlockOperationDelay.m
//  EiController
//
//  Created by Genrih Korenujenko on 04.04.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "BlockOperationDelay.h"

@implementation BlockOperationDelay

#pragma mark - Public Init Methods
+(instancetype)build:(NSInteger)waitingTime completion:(void (^)(void))completion
{
    BlockOperationDelay *result = [BlockOperationDelay blockOperationWithBlock:completion];
    result.waitingTime = waitingTime;
    return result;
}

#pragma mark - Override Methods
-(void)main
{
    if (self.waitingTime > 0)
    {
        waitingTimer = [NSTimer scheduledTimerWithTimeInterval:self.waitingTime repeats:NO block:^(NSTimer *timer)
        {
            [self stopTimer];
            if (!self.isCancelled)
                [super main];
        }];
    }
    else if (!self.isCancelled)
        [super main];
}

-(void)cancel
{
    [self stopTimer];
    [super cancel];
}

#pragma mark - Private Methods
-(void)stopTimer
{
    if (waitingTimer.valid)
        [waitingTimer invalidate];
    waitingTimer = nil;
}

@end
