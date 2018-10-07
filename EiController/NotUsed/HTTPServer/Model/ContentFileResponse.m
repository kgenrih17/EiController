//
//  ContentFileResponse.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ContentFileResponse.h"
//#import "ContentFilesTable.h"

@implementation ContentFileResponse

#pragma mark - HTTPResponseInterface
-(NSString*)processing:(NSString*)path
{
    NSString *response = nil;
    
    if ([self isValid:path])
    {
//        ContentFile *file = [[ContentFilesTable new] getByURL:path];
        
//        if (file != nil)
//            response = [NSString stringWithFormat:@"%@/%@", [AppInfromation getPathToDocuments], file.localPath];
//        else
//            response = [NSDictionary errorRPCWithMessage:@"This content does not exist" code:1 exception:NSStringFromClass([self class])];
    }
    else
        response = [NSDictionary errorRPCWithMessage:@"Incorrent URL" code:1 exception:NSStringFromClass([self class])];
    
    return response;
}

#pragma mark - Private Methods
-(BOOL)isValid:(NSString*)path
{
    BOOL isValid = NO;
    NSArray *components = path.pathComponents;
    for (NSString *pathComponent in components)
    {
        if ([pathComponent containsString:@"."] && [pathComponent isEqualToString:components.lastObject])
            isValid = YES;
    }
    
    return isValid;
}

@end
