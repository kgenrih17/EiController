//
//  SyncLogViewModel.m
//  EiController
//
//  Created by Genrih Korenujenko on 21.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "SyncLogViewModel.h"

@implementation SyncLogViewModel

-(UIColor*)getBackgroundColor
{
    if (self.isExtender)
        return [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1];
    else
        return [UIColor colorWithRed:0.137 green:0.133 blue:0.165 alpha:1];
}

-(UIColor*)getContainerColor
{
    if (self.isExtender)
        return [UIColor whiteColor];
    else
        return [UIColor colorWithRed:0.329 green:0.318 blue:0.404 alpha:1];
}

@end
