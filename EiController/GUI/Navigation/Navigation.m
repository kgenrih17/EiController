//
//  Navigation.m
//  EiController
//
//  Created by Genrih Korenujenko on 25.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "Navigation.h"
#import "AppInteractorInterface.h"
#import "AuthInterface.h"
#import "AuthObserverInterface.h"
#import "CentralConnectTrackerObserverInterface.h"

#import "SyncLogScreen.h"
#import "NetworkSettingsScreen.h"
#import "ConnectionInfoView.h"

///
#import "DeviceSyncLogPresenter.h"
#import "ServerSyncLogPresenter.h"

#import "EiController-Swift.h"

@interface Navigation () <UINavigationControllerDelegate>
{
    __weak id<AppInteractorInterface, AuthInterface> interactor;
    BOOL isShowConnectionView;
    ConnectionInfoView *connectionInfoView;
    ProgressView *progressView;
    UINavigationController *viewNavigator;
    __weak IBOutlet UIView *contentView;
    __weak IBOutlet UIView *connectionView;
    IBOutlet NSLayoutConstraint *connectionViewHeightConstraint;
    UIColor *backgroundColor;
}

@end

@implementation Navigation

#pragma mark - Public Init Methods
-(instancetype)initWithInteractor:(id<AppInteractorInterface, AuthInterface>)interactorInterface
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    
    if (self)
    {
        interactor = interactorInterface;
        [interactor setAuthObserver:self];
    }
    
    return self;
}

#pragma mark - Override Methods
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareViewNavigator];
    progressView = [[ProgressView alloc] initWithParentView:self.view];
    connectionInfoView = [ConnectionInfoView connectionInfo];
    [self addContraints];
}

#pragma mark - Public Methods
-(void)setConnectionViewFlag:(BOOL)isHide
{
    connectionInfoView.hidden = isHide;
}

-(void)changeConnection:(NSString*)address connectStable:(BOOL)isConnectStable
{
    NSString *imageName = isConnectStable ? @"connection_stable_icon.png" : @"connection_unstable_icon.png";
    UIImage *icon = [UIImage imageNamed:imageName];
    [connectionInfoView setAddress:address icon:icon];
}

-(void)setShowServerConnection:(BOOL)isShow
{
    isShowConnectionView = isShow;
    [self refreshConnectionViewState];
}

#pragma mark - AuthObserverInterface
-(void)showAuthScreen
{
    AuthView *screen = [[AuthView alloc] init];
    [viewNavigator setViewControllers:@[screen] animated:YES];
    [connectionInfoView removeFromSuperview];
    [self refreshConstraints];
}

-(void)showNodesListScreen
{
    NodesListView *screen = [[NodesListView alloc] init];
    [viewNavigator setViewControllers:@[screen] animated:YES];
    [self refreshConnectionViewState];
}

#pragma mark - NavigationInterface
-(void)showDeviceDetailsScreen:(NSString*)fingerprint actionInterface:(id)actionInterface
{
    UIViewController *lastScreen = viewNavigator.topViewController;
    if (![lastScreen.class isSubclassOfClass:[DeviceDetailsScreen class]])
    {
        DeviceDetailsScreen *screen = [[DeviceDetailsScreen alloc] initWithFingerprint:fingerprint];
        screen.actionInterface = actionInterface;
        [viewNavigator pushViewController:screen animated:YES];
    }
    else
    {
        [(DeviceDetailsScreen*)lastScreen didUpdateDeviceInfo:fingerprint];
    }
}

-(void)leftAnimationChangeDetailsView:(NSString*)fingerprint actionInterface:(id)actionInterface
{
    DeviceDetailsScreen *screen = [[DeviceDetailsScreen alloc] initWithFingerprint:fingerprint];
    screen.actionInterface = actionInterface;
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:viewNavigator.viewControllers];
    [controllers removeLastObject];
    [controllers addObject:screen];
    [viewNavigator setViewControllers:controllers animated:YES];
}

-(void)rigthAnimationChangeDetailsView:(NSString*)fingerprint actionInterface:(id)actionInterface
{
    DeviceDetailsScreen *screen = [[DeviceDetailsScreen alloc] initWithFingerprint:fingerprint];
    screen.actionInterface = actionInterface;
    [viewNavigator pushViewController:screen animated:YES];
}

-(void)showNetworkSettingsScreen:(NSArray<NSString*>*)fingerprints
{
    NodeNetworkSettingsView *screen = [[NodeNetworkSettingsView alloc] initWithFingerprints:fingerprints];
    [viewNavigator pushViewController:screen animated:YES];
}

-(void)showDeviceSyncLogScreen:(NSString*)fingerprint
{
    SyncLogScreen *screen = [[SyncLogScreen alloc] initWithPresenterClass:[DeviceSyncLogPresenter class] fingerprint:fingerprint];
    [viewNavigator pushViewController:screen animated:YES];
}

-(void)showServerSyncLogScreen
{
    SyncLogScreen *screen = [[SyncLogScreen alloc] initWithPresenterClass:[ServerSyncLogPresenter class] fingerprint:nil];
    [viewNavigator pushViewController:screen animated:YES];
}

-(void)showSettingsScreen
{
    SettingsView *screen = [[SettingsView alloc] init];
    [viewNavigator pushViewController:screen animated:YES];
}

-(void)showModeConfigurationScreen:(NSString*)fingerprint;
{
    ModeConfigurationScreen *screen = [[ModeConfigurationScreen alloc] initWithFingerprint:fingerprint];
    [viewNavigator pushViewController:screen animated:YES];
}

-(void)showDeviceRebotShutdownScreen:(NSString*)fingerprint
{
    NodeRebootShutdownView *screen = [[NodeRebootShutdownView alloc] initWithFingerprint:fingerprint];
    [viewNavigator pushViewController:screen animated:YES];
}

-(void)showNodeIntegrationScreen:(NSArray<NSString*>*)fingerprints
{
    NodeIntegrationView *screen = [[NodeIntegrationView alloc] initWithFingerprints:fingerprints];
    [viewNavigator pushViewController:screen animated:YES];
}

-(id<AppInteractorInterface, AuthInterface>)interactor
{
    return interactor;
}

-(void)closeAllScreens
{
    [viewNavigator setViewControllers:@[]];
}

-(void)showView:(UIView*)view
{
    UIView *visibleView = viewNavigator.visibleViewController.view;
    [visibleView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [visibleView setNeedsLayout];
    [[view.topAnchor constraintEqualToAnchor:visibleView.topAnchor] setActive:YES];
    [[view.bottomAnchor constraintEqualToAnchor:visibleView.bottomAnchor] setActive:YES];
    [[view.leadingAnchor constraintEqualToAnchor:visibleView.leadingAnchor] setActive:YES];
    [[view.trailingAnchor constraintEqualToAnchor:visibleView.trailingAnchor] setActive:YES];
    [visibleView layoutIfNeeded];
}

-(void)setBackgroundColor:(UIColor*)color
{
    backgroundColor = color;
    for (UIViewController *screen in viewNavigator.viewControllers)
        screen.view.backgroundColor = backgroundColor;
}

#pragma mark - ScreenInterface
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    [UIAlertController showMessage:message withTitle:title];
}

-(void)showAlert:(NSString*)title
         message:(NSString*)message
      acceptText:(NSString*)acceptText
     declineText:(NSString*)declinetext
      completion:(void (^)(BOOL))completion
{
    [UIAlertController showMessage:message
                         withTitle:title acceptText:acceptText
                       declineText:declinetext
                        completion:^(BOOL isAccepted)
    {
        BLOCK_SAFE_RUN(completion, isAccepted);
    }];
}

-(void)showProgressWithMessage:(NSString*)message
{
    if (!progressView.isShowed)
        [progressView showWithTitle:message];
}

-(void)showProcessing
{
    [progressView showWithTitle:@"Processing..."];
}

-(void)hideProgress
{
    [progressView hide];
}

#pragma mark - Private Methods
-(void)prepareViewNavigator
{
    viewNavigator = [UINavigationController new];
    viewNavigator.delegate = self;
    [self addChildViewController:viewNavigator];
    viewNavigator.view.frame = self.view.bounds;
    viewNavigator.view.backgroundColor = [UIColor clearColor];
    [contentView addSubview:viewNavigator.view];
    [viewNavigator didMoveToParentViewController:self];
    viewNavigator.navigationBarHidden = YES;
}

-(void)addContraints
{
    viewNavigator.view.translatesAutoresizingMaskIntoConstraints = NO;
    [[viewNavigator.view.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor] setActive:YES];
    [[viewNavigator.view.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor] setActive:YES];
    [[viewNavigator.view.topAnchor constraintEqualToAnchor:contentView.topAnchor] setActive:YES];
    [[viewNavigator.view.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor] setActive:YES];
}

-(void)refreshConstraints
{
//    [self.view setNeedsLayout];
//    if (connectionInfoView.superview == nil)
//        connectionViewHeightConstraint.constant = 0;
//    else
//        connectionViewHeightConstraint.constant = CGRectGetHeight(connectionInfoView.frame);
//    [self.view layoutIfNeeded];
}

-(void)refreshConnectionViewState
{
//    if (connectionInfoView.superview == nil && isShowConnectionView)
//        [connectionView addSubview:connectionInfoView];
//    else if (connectionInfoView.superview != nil && !isShowConnectionView)
        [connectionInfoView removeFromSuperview];
//    [self refreshConstraints];
}

-(void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    viewController.view.backgroundColor = backgroundColor;
}

@end
