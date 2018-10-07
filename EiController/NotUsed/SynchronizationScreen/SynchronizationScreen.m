//
//  SynchronizationScreen.m
//  EiController
//
//  Created by Genrih Korenujenko on 18.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "SynchronizationScreen.h"

@implementation SynchronizationScreen

#pragma mark - Public Init Methods
-(instancetype)initWithNib
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self)
    {
        presenter = [SynchronizationPresenter build:self
                                      authInterface:self.interactor];
    }
    return self;
}

#pragma mark - Override Methods
-(void)viewDidLoad
{
    [super viewDidLoad];
    viewLogButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [presenter onCreate];
}

-(void)removeFromParentViewController
{
    [super removeFromParentViewController];
    presenter = nil;
}

#pragma mark - SynchronizationScreenInterface
-(void)refresh:(SynchronizationViewModel*)viewModel
{
    intervalTextField.text = viewModel.interval;
    [self refreshSwitchToState:viewModel.isAutoSync constraint:autoSyncViewRightConstraint view:autoSyncView];
    [self refreshSwitchToState:viewModel.isShowStatusState constraint:showStatusViewRightConstraint view:showStatusView];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:intervalTextField])
    {
        NSString *newValue = [textField.text stringByAppendingString:string];
        return (newValue.length <= 4 && newValue.integerValue >= 0);
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField*)textField
{
    if ((textField.text.isEmpty || textField.text == nil || textField.text.integerValue <= 0) && [textField isEqual:intervalTextField])
        textField.text = @(MINUTES_INTERVAL_MIN).stringValue;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Private Methods
-(void)refreshSwitchToState:(BOOL)isOn constraint:(NSLayoutConstraint*)constraint view:(UIView*)view
{
    [self.view setNeedsLayout];
    if (isOn)
    {
        constraint.active = YES;
        view.backgroundColor = [UIColor colorWithRed:0 green:0.82 blue:0.486 alpha:1];
    }
    else
    {
        constraint.active = NO;
        view.backgroundColor = [UIColor grayColor];
    }
    [UIView animateWithDuration:0.25 animations:^
    {
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Action Methods
-(IBAction)changeSwitchState:(UITapGestureRecognizer*)tap
{
    if ([tap.view isEqual:autoSyncContainerView])
    {
        [self refreshSwitchToState:!autoSyncViewRightConstraint.active constraint:autoSyncViewRightConstraint view:autoSyncView];
        intervalContent.hidden = !autoSyncViewRightConstraint.active;
    }
    else
        [self refreshSwitchToState:!showStatusViewRightConstraint.active constraint:showStatusViewRightConstraint view:showStatusView];
}

-(IBAction)accept
{
    [self hideKeyboard];
    SynchronizationViewModel *viewModel = [SynchronizationViewModel new];
    viewModel.interval = intervalTextField.text;
    viewModel.isShowStatusState = showStatusViewRightConstraint.active;
    viewModel.isAutoSync = autoSyncViewRightConstraint.active;
    [presenter accept:viewModel];
}

-(IBAction)viewLog
{
    [self.navigation showServerSyncLogScreen];
}

@end
