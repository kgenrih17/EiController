//
//  NSString+NewAdditions.m
//  EiController
//
//  Created by Genrih Korenujenko on 22.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "NSString+NewAdditions.h"

@implementation NSString (NewAdditions)

+(NSString*)valueOrNA:(NSString*)string
{
    return (string != nil && [[string class] isSubclassOfClass:[NSString class]] && !string.isEmpty) ? string : @"N/A";
}

+(NSString*)localUS
{
    return @"en_US";
}

-(BOOL)isHTML
{
    return ([self containsString:@"</"] && [self containsString:@">"]);
}

-(NSString*)convertHTMLToString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:data
                                                                      options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                           documentAttributes:NULL error:NULL];
    return attrString.string;
}

+(NSString*)fromDate:(NSDate*)date dateFormate:(NSString*)dateFormate forLocal:(NSString*)localString
{
    return [NSString getStringFromDate:date dateFormate:dateFormate forLocal:localString];
}

@end
