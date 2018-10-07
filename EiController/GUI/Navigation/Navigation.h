//
//  Navigation.h
//  EiController
//
//  Created by Genrih Korenujenko on 25.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationInterface.h"

@protocol AppInteractorInterface;
@protocol AuthInterface;
@protocol AuthObserverInterface;

@interface Navigation : UIViewController <NavigationInterface>

-(instancetype)initWithInteractor:(id<AppInteractorInterface, AuthInterface>)interactorInterface;
-(void)changeConnection:(NSString*)address connectStable:(BOOL)isConnectStable;
-(void)setShowServerConnection:(BOOL)isShow;

@end
