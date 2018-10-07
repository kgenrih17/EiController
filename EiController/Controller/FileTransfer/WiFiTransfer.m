//
//  WiFiTransfer.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "WiFiTransfer.h"

@implementation WiFiTransfer

@synthesize listener, settings, completion;

#pragma mark - TransferInterface
+(instancetype)build:(id<TransferListener>)listener settings:(TransferInfo*)settings
{
    return nil;
}

-(void)upload:(TransferCompletion)completion
{

}

-(void)download:(TransferCompletion)completion
{

}

-(void)sendRequest:(TransferCompletion)completion
{

}

-(void)cancel
{

}

@end
