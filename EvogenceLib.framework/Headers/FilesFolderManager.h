//
//  FilesFolderManager.h
//  Collabra
//
//  Created by Admin on 2/11/15.
//  Copyright (c) 2015 Radical Computing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileDownloader.h"
/*
 This class was created to keep track of the files in the specified folder, download files that are missing in real time.
 */
@protocol FilesFolderManagerDelegate;

@interface FilesFolderManager : NSObject <FileDownloaderDelegate>
{
    NSMutableSet *urlFiles;
    
    NSString *pathToWorkFolder;
    NSMutableArray *availableFiles;
    
    NSMutableArray *filesForDownload;
    
    FileDownloader *fileDownloader;
}

@property (nonatomic, readonly, getter=isWork) BOOL work;
@property (nonatomic, weak) id<FilesFolderManagerDelegate> delegate;

-(instancetype)initWithFolder:(NSString*)pathFolder andUrlFiles:(NSArray*)urlFiles;

-(void)addNewUrlFiles:(NSArray*)newUrlFiles;

-(void)start;
-(void)stop;

@end

@protocol FilesFolderManagerDelegate <NSObject>

@optional
-(void)didDownloadFiles;

@end
