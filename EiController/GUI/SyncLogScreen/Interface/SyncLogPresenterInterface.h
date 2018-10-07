//
//  SyncLogPresenterInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 21.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncLogScreenInterface.h"
#import "AppInteractorInterface.h"
#import <MessageUI/MessageUI.h>

@protocol SyncLogPresenterInterface <NSObject>

@property (nonatomic, readwrite, weak) id <SyncLogScreenInterface> screen;
@property (nonatomic, readwrite, weak) id <AppInteractorInterface> interactor;

@required
+(instancetype)build:(id<SyncLogScreenInterface>)screen
          interactor:(id<AppInteractorInterface>)interactor;
-(void)onCreate;
-(void)sendLog:(SyncLogViewModel*)viewModel cells:(NSArray<SyncLogCellViewModel*>*)cells;

@optional
-(void)setFingerprint:(NSString*)fingerprint;

@end
