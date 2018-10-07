//
//  ApplianceCommunicator.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ApplianceCommunicator.h"

@interface ApplianceCommunicator ()

@property (nonatomic, readwrite, weak) id <TransferInterface> transfer;

@end

@implementation ApplianceCommunicator

@synthesize transfer;

#pragma mark - ApplianceCommunicatorInterface
+(instancetype)communicatorWithTransfer:(id<TransferInterface>)transfer
{
    ApplianceCommunicator *result = [ApplianceCommunicator new];
    result.transfer = transfer;
    return result;
}

-(void)setTransfer:(id<TransferInterface>)newTransfer
{
    transfer = newTransfer;
}

-(void)uploadFiles
{
    
}

-(void)downloadLogFiles
{
    
}

-(void)stop
{
    
}

@end
