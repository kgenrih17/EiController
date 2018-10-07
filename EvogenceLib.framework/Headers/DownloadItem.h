//
//  DownloadItem.h
//  NufernOpticalFibers
//
//  Created by Anatolij on 3/16/13.
//  Copyright (c) 2013 Anatolij. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadItem : NSObject

@property(nonatomic, copy) NSString *fromPath;
@property(nonatomic, copy) NSString *toPath;

-(id)initWithFromPath:(NSString*)_fromPath andToPath:(NSString*)_toPath;
+(DownloadItem*)downloadItemWithFromPath:(NSString*)_fromPath andToPath:(NSString*)_toPath;

@end
