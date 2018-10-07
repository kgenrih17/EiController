//
//  EditDeviceScreen.m
//  EiController
//
//  Created by admin on 8/17/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

//#import "EditDeviceScreen.h"
//#import "EditDevicePresenter.h"
//
//@interface EditDeviceScreen () <UITextFieldDelegate, UIActionSheetDelegate, EditDeviceScreenInterface>
//{
//    IBOutlet UITextField *nameTextField;
//    EditDevicePresenter *presenter;
//    EditDeviceViewModel *model;
//}
//@end
//
//@implementation EditDeviceScreen
//
//#pragma mark - Public Init Methods
//-(instancetype)initWithFingerprint:(NSString*)fingerprint
//{
//    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
//    
//    if (self)
//    {
//        presenter = [EditDevicePresenter presenterWithScreen:self
//                                                  interactor:self.interactor
//                                                 fingerprint:fingerprint];
//    }
//    
//    return self;
//}
//
//
//#pragma mark - Override Methods
//-(void)viewDidLoad
//{
//    [super viewDidLoad];
//    [presenter onCreate];
//}
//
//-(void)removeFromParentViewController
//{
//    [super removeFromParentViewController];
//    presenter = nil;
//    model = nil;
//}
//
//#pragma mark - EditDeviceScreenInterface
//-(void)refresh:(EditDeviceViewModel*)viewModel
//{
//    model = viewModel;
//    nameTextField.text = model.title;
//}
//
//#pragma mark - UITextFieldDelegate
//-(BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
//{
//    NSString *value = [textField.text stringByAppendingString:string];
//    return [presenter isValidateName:value];
//}
//
//-(BOOL)textFieldShouldReturn:(UITextField*)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
//
//#pragma mark - IBActions
//-(IBAction)saveTitle
//{
//    NSString *newTitle = nameTextField.text;
//    if (newTitle != nil && !newTitle.isEmpty)
//    {
//        if (![newTitle isEqualToString:model.title])
//            [presenter saveTitle:newTitle];
//        else
//            [self showAlertWithTitle:@"Info" message:@"The name of the Node is the same as before."];
//    }
//    else
//        [self showAlertWithTitle:@"Info" message:@"Please complete the ‘name’ field"];
//}
//
//@end
