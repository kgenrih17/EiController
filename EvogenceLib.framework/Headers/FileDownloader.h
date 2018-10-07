//
//  FileDownloader.h
//  Downloder
//
//  Created by Dambooldor on 08.09.14.
//  Copyright (c) 2014 hackintosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileDownloaderDelegate <NSObject>

-(void)didSuccessfullDownload:(NSString*)path;
-(void)didFailedDownload:(NSString*)path withEror:(NSString*)error;

@end

@interface FileDownloader : NSObject <NSURLSessionDelegate>
{
    NSString *urlString;
    NSURLSession *urlConnection;
    
    NSString *pathToTempFile;
    NSString *pathToFile;
}

@property (nonatomic, getter = isReload) BOOL reload;

-(id)initWithDelegate:(id<FileDownloaderDelegate>)delegate;

-(void)downloadFrom:(NSString*)url to:(NSString*)path;
-(void)cancel;

@end