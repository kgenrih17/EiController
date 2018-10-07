//
//  CommandResult.h
//  EiController
//
//  Created by admin on 2/18/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandResult : NSObject

@property (nonatomic, strong) id params;
@property (nonatomic, copy) NSString *error;

+(instancetype)initWithError:(NSString*)_error;
+(instancetype)initWithResult:(id)_result;
-(NSDictionary*)dicParams;

@end
