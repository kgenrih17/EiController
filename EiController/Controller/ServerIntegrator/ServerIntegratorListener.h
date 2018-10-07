//
//  ServerIntegratorListener.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

@protocol ServerIntegratorListener <NSObject>

@required
-(void)serverSyncChangeProgress:(CGFloat)progress withMessage:(NSString*)message;
-(void)serverSyncError:(NSString*)error;

@optional
-(void)serverSyncWillStart;
-(void)serverSyncDidEnd;

@end

