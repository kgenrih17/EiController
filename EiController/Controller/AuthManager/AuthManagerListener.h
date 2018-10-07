//
//  AuthManagerListener.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef NS_ENUM(NSInteger, EAuthStatus)
{
    OFFLINE_AUTH = -1,
    NON_AUTH = 0,
    ONLINE_AUTH
};

@protocol AuthManagerListener <NSObject>

@required
-(void)authWithStatus:(EAuthStatus)status;
-(void)authError:(NSString*)error;

@end
