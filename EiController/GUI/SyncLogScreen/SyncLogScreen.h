//
//  SyncLogScreen.h
//  EiController
//
//  Created by Genrih Korenujenko on 21.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncLogPresenterInterface.h"
#import "SyncLogCell.h"

@interface SyncLogScreen : UIViewController <SyncLogScreenInterface, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UIView *titleView;
    __weak IBOutlet UILabel *tabBarLabel;
    __weak IBOutlet UILabel *textLabel;
    __weak IBOutlet UITableView *logsTableView;
    __weak IBOutlet UIButton *sendLogButton;
    __weak IBOutlet UIView *subtitleView;
    IBOutlet NSLayoutConstraint *topContainerConstraint;

    id <SyncLogPresenterInterface> presenter;
    SyncLogViewModel *model;
    NSArray <SyncLogCellViewModel*> *cells;
}

-(instancetype)initWithPresenterClass:(Class<SyncLogPresenterInterface>)aClass fingerprint:(NSString*)fingerprint;

@end
