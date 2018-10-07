//
//  DeviceSyncListener.h
//  EiController
//
//  Created by Genrih Korenujenko on 14.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

@protocol DeviceSyncListener <NSObject>

@required
-(void)syncToCentralComplete;
-(void)startSync:(NSString*)fingerprint;
-(void)syncChangeProgress:(CGFloat)progress withMessage:(NSString*)message;
-(void)syncError:(NSString*)error fingerprint:(NSString*)fingerprint;
-(void)endSync:(NSString*)fingerprint;

@end
