//
//  RequestSender Version 4.0
//  Copyright (c) 2013 Radical Computing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestResult.h"

typedef void (^RequestCompleted)(RequestResult *_result);

@protocol RequestSenderDelegate <NSObject>

@required
-(void)requestSenderError:(NSString*)_error;

@optional
-(void)requestSenderResult:(NSString*)_result;
-(void)requestSenderDataResult:(NSData*)_result;

@end

@interface RequestSender : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, weak) id<RequestSenderDelegate>delegate;
@property (nonatomic) NSInteger timeout;
@property (nonatomic, readwrite, copy) NSString *parameters;

-(BOOL)isBusy;

-(void)setUserName:(NSString *)_user AndPassword:(NSString *)_pass;
-(void)setUrl:(NSString*)_urlString;

-(void)sendGetRequest:(NSString*)_request;
-(void)sendPostRequest:(NSString*)_request;

-(void)sendGet:(NSString*)_request completion:(RequestCompleted)_result;
-(void)sendPost:(NSString*)_request completion:(RequestCompleted)_result;

-(void)sendRequestCompletion:(RequestCompleted)_result;

-(void)cancel;

@end
