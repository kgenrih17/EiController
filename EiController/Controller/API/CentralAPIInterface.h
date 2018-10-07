//
//  CentralAPIInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 16.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "CentralConnectionData.h"

@protocol CentralAPIInterface <NSObject>

@required
/// Last Request Error
-(NSInteger)getErrorCode;
-(NSString*)getErrorMessage;
///
-(void)cancel;

-(void)setConnectionData:(CentralConnectionData*)connectionData;
-(void)checkConnection:(void (^)(BOOL isSuccess))completion;
-(void)authByPin:(NSString*)pin
     compenyCode:(NSString*)compenyCode
      completion:(void(^)(NSDictionary*))completion;
-(void)authByLogin:(NSString*)login
          password:(NSString*)password
       compenyCode:(NSString*)compenyCode
        completion:(void(^)(NSDictionary*))completion;
-(void)getDevices:(void(^)(NSDictionary*answer))completion;
-(void)getSchedules:(NSString*)fingerprint completion:(void(^)(NSDictionary*result))completion;

@end
