//
//  ApplicationFile.m
//  EiController
//
//  Created by Genrih Korenujenko on 23.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "ApplicationFile.h"

@implementation ApplicationFile

@synthesize fileSize;
@synthesize fingerprint;
@synthesize unique;
@synthesize fileUrl;
@synthesize localPath;


-(BOOL)isEqual:(id)object
{
    if (![[object class] isSubclassOfClass:[self class]])
        return NO;
    ApplicationFile *item = (ApplicationFile*)object;
    if (![item.fingerprint isEqualToString:self.fingerprint])
        return NO;
    else if (![item.unique isEqualToString:self.unique])
        return NO;
    else
        return YES;
}

@end
