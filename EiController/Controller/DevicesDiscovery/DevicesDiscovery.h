//
//  AppliancesDiscovery.h
//  TestProj
//
//  Created by admin on 2/16/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(NSArray *result, NSString *error);

@interface DevicesDiscovery : NSObject 

-(void)searchDevices:(CompletionBlock)_complation;
-(void)stop;

@end
