//
//  RequestResult.h
//  EvogenceLib
//
//  Created by admin on 4/21/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestResult : NSObject

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, copy) NSString *resultStr;
@property (nonatomic, copy) NSString *errorStr;

@end
