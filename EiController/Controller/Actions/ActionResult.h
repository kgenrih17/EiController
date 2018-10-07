//
//  ActionResult.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionResult : NSObject

@property (nonatomic, readwrite, copy) NSString *error;
@property (nonatomic, readwrite, strong) id data;

+(instancetype)build:(NSString*)error data:(id)data;

@end
