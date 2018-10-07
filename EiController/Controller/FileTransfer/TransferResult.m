//
//  TransferResult.m
//  EiController
//
//  Created by Genrih Korenujenko on 02.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "TransferResult.h"

@implementation TransferResult

#pragma mark - Public Init Methods
+(instancetype)build:(NSString*)error data:(id)data
{
    TransferResult *result = [TransferResult new];
    result.error = error;
    result.data = data;
    return result;
}

@end
