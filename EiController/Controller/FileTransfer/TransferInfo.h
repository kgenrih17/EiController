//
//  TransferInfo.h
//  EiController
//
//  Created by Genrih Korenujenko on 29.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferInfo : NSObject

@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, copy) NSString *pathToFile;
@property (nonatomic, readwrite, copy) NSDictionary <NSString*, NSString*> *parameters;

@end
