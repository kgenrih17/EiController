//
//  NSArray+Additions.h
//  ASEnterprise
//
//  Created by Dambooldor on 09.09.14.
//  Copyright (c) 2014 Evogence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

-(NSString*)json;
-(BOOL)isEmpty;
-(BOOL)isValidIndex:(NSInteger)_index;

@end
