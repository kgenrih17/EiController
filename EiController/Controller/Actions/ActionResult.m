//
//  ActionResult.m
//  EiController
//
//  Created by Genrih Korenujenko on 22.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ActionResult.h"

@implementation ActionResult

#pragma mark - Public Init Methods
+(instancetype)build:(NSString*)error data:(id)data
{
    ActionResult *result = [ActionResult new];
    result.error = error;
    result.data = data;
    return result;
}

@end
