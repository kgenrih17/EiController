//
//  PublisherAPIInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "CentralConnectionData.h"

@protocol PublisherAPIInterface <NSObject>

@required
-(void)cancel;

-(void)getApplications:(NSString*)fingerprint
                 token:(NSString*)token
               isForce:(BOOL)isForce
            completion:(void(^)(NSDictionary*applications))completion;
-(void)downloadAppliactionFile:(NSString*)filename toPath:(NSString*)path completion:(void(^)(NSInteger length))completion;
-(void)setUploadedFiles:(NSArray<NSDictionary*>*)files completion:(void(^)(void))completion;

/// Last Request Error
-(NSInteger)getErrorCode;
-(NSString*)getErrorMessage;
///

@end

