//
//  SynchronizationScreen.h
//  EiController
//
//  Created by Genrih Korenujenko on 18.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SynchronizationPresenter.h"
#import "SynchronizationScreenInterface.h"

@interface SynchronizationScreen : UIViewController <SynchronizationScreenInterface, UITextFieldDelegate>
{
    IBOutlet NSLayoutConstraint *showStatusViewRightConstraint;
    IBOutlet NSLayoutConstraint *autoSyncViewRightConstraint;
    __weak IBOutlet UIView *autoSyncContainerView;
    __weak IBOutlet UIView *autoSyncView;
    __weak IBOutlet UIView *showStatusContainerView;
    __weak IBOutlet UIView *showStatusView;
    __weak IBOutlet UIButton *viewLogButton;
    __weak IBOutlet UIView *intervalContent;   
    __weak IBOutlet UITextField *intervalTextField;    
    SynchronizationPresenter *presenter;
}

-(instancetype)initWithNib;

@end
