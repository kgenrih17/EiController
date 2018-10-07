//
//  TransferResult.h
//  EiController
//
//  Created by Genrih Korenujenko on 02.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferResult : NSObject

@property (nonatomic, readwrite, copy) NSString *error;
@property (nonatomic, readwrite, strong) id data;

+(instancetype)build:(NSString*)error data:(id)data;

@end
