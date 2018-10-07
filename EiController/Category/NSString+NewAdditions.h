//
//  NSString+NewAdditions.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NewAdditions)

+(NSString*)valueOrNA:(NSString*)string;
+(NSString*)localUS; /// en_US

-(BOOL)isHTML;
-(NSString*)convertHTMLToString;

+(NSString*)fromDate:(NSDate*)date dateFormate:(NSString*)dateFormate forLocal:(NSString*)localString;

@end
