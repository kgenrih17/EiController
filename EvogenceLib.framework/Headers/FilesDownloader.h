//
//  FilesDownloader.h
//  Viewer
//
//  Created by Anatolij on 5/18/13.
//
//

#import <Foundation/Foundation.h>
#import "FileDownloader.h"
#import "DownloadItem.h"

@protocol FilesDownloaderDelegate <NSObject>
-(void)filesWasDownloaded;
@end

@interface FilesDownloader : NSObject <FileDownloaderDelegate>

@property(nonatomic, weak) id<FilesDownloaderDelegate> delegate;

-(void)downloadItems:(NSMutableArray*)_items;
-(void)cancel;

@end
