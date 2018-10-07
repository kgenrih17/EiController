//
//  BlockOperationDelay.h
//  EiController
//
//  Created by Genrih Korenujenko on 04.04.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockOperationDelay : NSBlockOperation
{
    NSTimer *waitingTimer;
}
@property (nonatomic, readwrite) NSInteger waitingTime;

+(instancetype)build:(NSInteger)waitingTime completion:(void (^)(void))completion;

@end
