//
//  NSDate+NewAdditions.m
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 29.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "NSDate+NewAdditions.h"

@implementation NSDate (NewAdditions)

+(NSDate*)today:(NSInteger)hour min:(NSInteger)min
{
    return [NSDate todayDateWithHour:hour min:min];
}

@end
