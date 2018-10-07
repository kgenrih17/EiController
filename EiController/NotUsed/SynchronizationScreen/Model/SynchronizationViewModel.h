//
//  SynchronizationViewModel.h
//  EiController
//
//  Created by Genrih Korenujenko on 18.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger MINUTES_INTERVAL_MIN = 1;
static const NSInteger INTERVAL_LENGTH_MAX = 4;

@interface SynchronizationViewModel : NSObject

@property (nonatomic, readwrite, copy) NSString *interval;
@property (nonatomic, readwrite) BOOL isAutoSync;
@property (nonatomic, readwrite) BOOL isShowStatusState;

@end
