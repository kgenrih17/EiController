//
//  SyncLogCellViewModel.m
//  EiController
//
//  Created by Genrih Korenujenko on 14.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "SyncLogCellViewModel.h"

@implementation SyncLogCellViewModel

-(UIColor*)getTitleColor
{
    if (self.descColor != nil)
        return self.descColor;
    else if (self.isExtender)
        return [UIColor colorWithRed:0.11 green:0.122 blue:0.137 alpha:1];
    else
        return [UIColor whiteColor];
}

-(UIColor*)getSubtitleColor
{
    if (self.isExtender)
        return [UIColor colorWithRed:0.561 green:0.553 blue:0.6 alpha:1];
    else
        return [UIColor colorWithRed:0.278 green:0.267 blue:0.349 alpha:1];
}

-(UIColor*)getContainerColor
{
    if (self.isExtender)
        return [UIColor whiteColor];
    else
        return [UIColor colorWithRed:0.329 green:0.318 blue:0.404 alpha:1];
}

@end
