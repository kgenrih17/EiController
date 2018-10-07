//
//  CentralConnectTracker.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CentralAPIInterface.h"
#import "CentralConnectTrackerObserverInterface.h"

@interface CentralConnectTracker : NSObject

+(instancetype)build:(id<CentralConnectTrackerObserverInterface>)observer
                 api:(id<CentralAPIInterface>)api
             timeout:(NSInteger)timeout;

-(void)start;
-(void)stop;
-(void)pause:(BOOL)isPause;
-(BOOL)isStarted;
-(BOOL)getLastConnectionStableFlag;

@end
