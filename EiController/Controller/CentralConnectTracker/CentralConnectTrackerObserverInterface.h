//
//  CentralConnectTrackerObserverInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#ifndef CentralConnectTrackerObserverInterface_h
#define CentralConnectTrackerObserverInterface_h

@protocol CentralConnectTrackerObserverInterface

@required
-(void)changeConnectionTo:(BOOL)isStable;

@end

#endif /* CentralConnectTrackerObserverInterface_h */
