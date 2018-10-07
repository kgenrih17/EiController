//
//  TransferInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "TransferListener.h"
#import "TransferInfo.h"

typedef void(^TransferCompletion)(TransferResult *result);

@protocol TransferInterface <NSObject>

@property (nonatomic, readwrite, weak) id <TransferListener> listener;
@property (nonatomic, readwrite, strong) TransferInfo *settings;
@property (nonatomic, readwrite, strong) TransferCompletion completion;

@required
+(instancetype)build:(id<TransferListener>)listener settings:(TransferInfo*)settings;
-(void)upload:(TransferCompletion)completion;
-(void)download:(TransferCompletion)completion;
-(void)sendRequest:(TransferCompletion)completion;
-(void)cancel;

@end
