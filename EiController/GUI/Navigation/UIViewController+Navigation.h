//
//  UIViewController+Navigation.h
//  EiController
//
//  Created by Genrih Korenujenko on 25.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationInterface.h"
#import "AppInteractorInterface.h"

@interface UIViewController (Navigation) <ScreenInterface>

@property (nonatomic, readwrite, weak) IBOutlet UIButton *backButton;
@property (nonatomic, readwrite, weak) IBOutlet UIButton *saveButton;

-(id<NavigationInterface>)navigation;
-(id<AppInteractorInterface, AuthInterface>)interactor;
-(IBAction)close;
-(IBAction)hideKeyboard;

@end
