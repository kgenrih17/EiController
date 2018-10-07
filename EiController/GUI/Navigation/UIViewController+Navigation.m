//
//  UIViewController+Navigation.m
//  EiController
//
//  Created by Genrih Korenujenko on 25.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "UIViewController+Navigation.h"
#import <objc/runtime.h>

@implementation UIViewController (Navigation)

#pragma mark - Private Methods
-(UIButton*)backButton
{
    return objc_getAssociatedObject(self, "BackButton");
}

-(void)setBackButton:(UIButton*)backButton
{
    objc_setAssociatedObject(self, "BackButton", backButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton*)saveButton
{
    return objc_getAssociatedObject(self, "saveButton");
}

-(void)setSaveButton:(UIButton*)saveButton
{
    [saveButton setImage:[UIImage imageNamed:@"screen_save_icon"] forState:UIControlStateNormal];
    [saveButton setImageEdgeInsets:UIEdgeInsetsMake(7, 0, 7, 8)];
    saveButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    objc_setAssociatedObject(self, "saveButton", saveButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public Methods
-(id<NavigationInterface>)navigation
{
    return (id<NavigationInterface>)[UIApplication sharedApplication].keyWindow.rootViewController;
}

-(id<AppInteractorInterface, AuthInterface>)interactor;
{
    return [[self navigation] interactor];
}

-(IBAction)close
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)hideKeyboard
{
    [self.view endEditing:YES];
}

-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    [[self navigation] showAlertWithTitle:title message:message];
}

-(void)showAlert:(NSString*)title
         message:(NSString*)message
      acceptText:(NSString*)acceptText
     declineText:(NSString*)declinetext
      completion:(void (^)(BOOL isAccepted))completion
{
    [[self navigation] showAlert:title message:message acceptText:acceptText declineText:declinetext completion:completion];
}

-(void)showProcessing
{
    [[self navigation] showProcessing];
}

-(void)showProgressWithMessage:(NSString*)message
{
    [[self navigation] showProgressWithMessage:message];
}

-(void)hideProgress
{
    [[self navigation] hideProgress];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
