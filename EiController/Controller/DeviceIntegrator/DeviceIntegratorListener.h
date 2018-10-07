//
//  DeviceIntegratorListener.h
//  EiController
//
//  Created by Genrih Korenujenko on 02.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

@protocol DeviceIntegratorListener <NSObject>

@required
-(void)deviceSyncWillStartFor:(NSString*)fingerprint;
-(void)deviceSyncChangeProgress:(CGFloat)progress withMessage:(NSString*)message fingerprint:(NSString*)fingerprint;
-(void)deviceSyncError:(NSString*)error fingerprint:(NSString*)fingerprint;
-(void)deviceSyncDidEnd:(NSString*)fingerprint;

@optional
-(void)deviceSyncWillStart;
-(void)deviceSyncDidEnd;

@end
