//
//  AuthManagerInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthManagerListener.h"
#import "CentralConnectionData.h"

@protocol AuthManagerInterface <NSObject>

@property (nonatomic, readwrite, weak) id <AuthManagerListener> listener;
@property (nonatomic, readwrite) EAuthStatus status;

@required
+(instancetype)build:(id<AuthManagerListener>)listener
      connectionData:(CentralConnectionData*)connectionData;
-(void)setConnectionData:(CentralConnectionData*)connectionData;
-(void)auth;
-(void)authByPin:(NSString*)pin companyID:(NSString*)companyID completion:(void(^)(NSString *error))completion;
-(void)authByLogin:(NSString*)login password:(NSString*)password companyID:(NSString*)companyID completion:(void(^)(NSString *error))completion;
-(void)authByLogin:(NSString*)login password:(NSString*)password completion:(void(^)(NSString *error))completion;
-(User*)getLoggedUser;
-(void)prepareForLogout;

@end
