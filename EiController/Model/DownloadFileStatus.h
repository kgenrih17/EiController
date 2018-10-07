//
//  DownloadFileStatus.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadFileStatus : NSObject

@property (nonatomic, readwrite) NSInteger itemId;
@property (nonatomic, readwrite) NSInteger errorCode;
@property (nonatomic, readwrite) BOOL isDownloaded;
@property (nonatomic, readwrite, copy) NSString *fingerprint;
@property (nonatomic, readwrite, copy) NSString *fileId;

@end
