//
//  SyncLogScreenInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 21.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "ScreenInterface.h"
#import "SyncLogViewModel.h"
#import "SyncLogCellViewModel.h"

@protocol SyncLogScreenInterface <ScreenInterface>

@required
-(void)refresh:(SyncLogViewModel*)model;
-(void)refreshTable:(NSArray<SyncLogCellViewModel*>*)cells;
-(void)showMailScreen:(NSArray<NSString*>*)recipients
              subject:(NSString*)subject
             mimeType:(NSString*)mimeType
             fileName:(NSString*)fileName
                 data:(NSData*)data;
@end
