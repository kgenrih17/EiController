//
//  ScheduleStorageListener.h
//  EiController
//
//  Created by Genrih Korenujenko on 17.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

@protocol ScheduleStorageListener <NSObject>

@required
-(void)previousScheduleFoundFor:(NSString*)fingerprint;

@end
