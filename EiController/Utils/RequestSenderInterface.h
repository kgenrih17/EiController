//
//  RequestSenderInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 18.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestResultInterface;

typedef void (^RequestCompletedBlock)(id <RequestResultInterface> result);

@protocol RequestSenderInterface <NSObject>

@property (nonatomic) NSInteger timeout;
@property (nonatomic, readwrite, copy) NSString *parameters;

@required
-(BOOL)isBusy;
-(void)setUrl:(NSString*)urlString;
-(void)sendGet:(NSString*)request completion:(RequestCompletedBlock)result;
-(void)sendPost:(NSString*)request completion:(RequestCompletedBlock)result;
-(void)sendRequestCompletion:(RequestCompletedBlock)result;
-(void)cancel;

@end

@protocol RequestResultInterface <NSObject>

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, copy) NSString *resultStr;
@property (nonatomic, copy) NSString *errorStr;

@required
-(id)getRPCResult;
-(NSString*)getRPCErrorMessage;
-(NSInteger)getRPCErrorCode;
-(BOOL)isHaveError;
-(BOOL)isRPC;

@end

