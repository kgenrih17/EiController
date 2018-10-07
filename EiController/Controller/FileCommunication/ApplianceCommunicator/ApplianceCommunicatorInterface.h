//
//  ApplianceCommunicatorInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "TransferInterface.h"

@protocol ApplianceCommunicatorInterface <NSObject>

@required
+(instancetype)communicatorWithTransfer:(id<TransferInterface>)transfer;
-(void)setTransfer:(id<TransferInterface>)transfer;
-(void)uploadFiles;
-(void)downloadLogFiles;
-(void)stop;

@end
