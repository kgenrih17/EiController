//
//  AuthDialog.m
//  ASEnterprise
//
//  Created by admin on 7/21/16.
//  Copyright © 2016 Evogence. All rights reserved.
//

#import "AuthDialog.h"

//@interface AuthDialog () <UITextFieldDelegate>
//{
//    IBOutlet UIView *contentView;
//
//    // Pin
//    IBOutlet UIView *pinView;
//    IBOutlet UITextField *pinText;
//    IBOutletCollection(UIButton) NSArray *pinBtns;
//    IBOutlet UIView *pinBgView;
//    IBOutlet UIButton *pinButton;
//    IBOutlet UIView *pinBottomLineView;
//
//    // Login and Password
//    IBOutlet UIView *loginView;
//    IBOutlet UITextField *logintTextField;
//    IBOutlet UITextField *passwordTextField;
//    IBOutlet UIButton *loginButton;
//    IBOutlet UIView *loginBottomLineView;
//
//    __weak AuthPresenter *presenter;
//}
//@end
//
//@implementation AuthDialog
//
//@synthesize mode;
//
//#pragma mark - Public Init Methods
//-(instancetype)initWithPresenter:(AuthPresenter*)authPresenter
//{
//    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AuthDialog class]) owner:self options:nil] firstObject];
//
//    if (self)
//    {
//        presenter = authPresenter;
//        mode = LOGIN_MODE;
//        pinButton.tag = PIN_MODE;
//        loginButton.tag = LOGIN_MODE;
//        [self prepareByAuthMode];
//        [self preparePinButtons];
//    }
//
//    return self;
//}
//
//#pragma mark - Override Methods
//-(void)didMoveToSuperview
//{
//    [super didMoveToSuperview];
//
//    if (self.superview)
//    {
//        for (UIButton *button in pinBtns)
//            button.titleLabel.adjustsFontSizeToFitWidth = YES;
//
//        self.translatesAutoresizingMaskIntoConstraints = NO;
//        [[self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor] setActive:YES];
//        [[self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor] setActive:YES];
//        [[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor] setActive:YES];
//        [[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor] setActive:YES];
//    }
//}
//
//-(void)dealloc
//{
//    presenter = nil;
//}
//
//#pragma mark - Public Methods
//-(void)login
//{
//    switch (mode)
//    {
//        case PIN_MODE:
//        {
//            if (pinText.text.length == 0)
//                [UIAlertController showMessage:@"Please enter PIN" withTitle:@"Info"];
////            else
////                [presenter authByPin:pinText.text.copy];
//        }
//            break;
//
//        case LOGIN_MODE:
//        {
//            if (logintTextField.text.length == 0 || passwordTextField.text.length == 0)
//                [UIAlertController showMessage:@"Please enter login and password" withTitle:@"Info"];
////            else
////                [presenter authByLogin:logintTextField.text password:passwordTextField.text];
//        }
//            break;
//    }
//}
//
//-(void)showMode:(EDialogMode)mode
//{
//    switch (mode)
//    {
//        case PIN_MODE:
//            [self changeMode:pinButton];
//            break;
//        case LOGIN_MODE:
//            [self changeMode:loginButton];
//            break;
//    }
//}
//
//-(void)setPin:(NSString*)pin
//{
//    pinText.text = pin;
//}
//
//-(void)setLogin:(NSString*)login password:(NSString*)password
//{
//    logintTextField.text = login;
//    passwordTextField.text = password;
//}
//
//#pragma mark - IBActions
//-(IBAction)changeMode:(UIButton*)button
//{
//    if (button.tag == mode)
//        return;
//
//    mode = button.tag;
//
//    [self clearTextFields];
//    [self prepareByAuthMode];
//}
//
//-(IBAction)pinEditing:(UIButton*)button
//{
//    if (button.tag == 101)
//    {
//        if (pinText.text.length > 0)
//        {
//            NSMutableString *string = [[NSMutableString alloc] initWithString:pinText.text];
//            [string deleteCharactersInRange:NSMakeRange(pinText.text.length - 1, 1)];
//            pinText.text = string;
//        }
//    }
//    else if (pinText.text.length < 8)
//    {
//        NSMutableString *string = [[NSMutableString alloc] initWithString:pinText.text];
//        [string appendString:button.titleLabel.text];
//        pinText.text = string;
//    }
//}
//
//#pragma mark - Private Methods
//-(void)preparePinButtons
//{
//    CGFloat cornerRadius = 4.0f;
//
//    [pinBgView.layer setCornerRadius:cornerRadius];
//    [self.layer setCornerRadius:cornerRadius];
//
//    for (UIButton *button in pinBtns)
//    {
//        CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//        UIGraphicsBeginImageContext(rect.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//
//        CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:(66.0f/255.0f) green:(119.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f] CGColor]);
//        CGContextFillRect(context, rect);
//
//        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
//        [button.layer setCornerRadius:3.0f];
//        [button setBackgroundImage:image forState:UIControlStateHighlighted];
//    }
//}
//
//-(void)prepareByAuthMode
//{
//    for (UIView *subview in contentView.subviews)
//        [subview removeFromSuperview];
//
//    UIView *currentContent = nil;
//    UIFont *selectedFont = [UIFont boldSystemFontOfSize:20];
//    UIFont *normalFont = [UIFont systemFontOfSize:20];
//    if (mode == PIN_MODE)
//    {
//        currentContent = pinView;
//        pinBottomLineView.hidden = NO;
//        loginBottomLineView.hidden = YES;
//        pinButton.selected = YES;
//        loginButton.selected = NO;
//        pinButton.titleLabel.font = selectedFont;
//        loginButton.titleLabel.font = normalFont;
//    }
//    else
//    {
//        currentContent = loginView;
//        pinBottomLineView.hidden = YES;
//        loginBottomLineView.hidden = NO;
//        pinButton.selected = NO;
//        loginButton.selected = YES;
//        pinButton.titleLabel.font = normalFont;
//        loginButton.titleLabel.font = selectedFont;
//    }
//
//    currentContent.frame = contentView.bounds;
//    [contentView addSubview:currentContent];
//    [self addConstraintForViewMode:currentContent];
//}
//
//-(void)addConstraintForViewMode:(UIView*)viewMode
//{
//    [contentView setNeedsLayout];
//    viewMode.translatesAutoresizingMaskIntoConstraints = NO;
//    [[viewMode.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor] setActive:YES];
//    [[viewMode.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor] setActive:YES];
//    [[viewMode.topAnchor constraintEqualToAnchor:contentView.topAnchor] setActive:YES];
//    [[viewMode.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor] setActive:YES];
//    [contentView layoutIfNeeded];
//}
//
//-(void)clear
//{
//    pinText.text = @"";
//    passwordTextField.text = @"";
//}
//
//-(void)clearTextFields
//{
//    [self clear];
//    logintTextField.text = @"";
//}
//
//#pragma mark - UITextFieldDelegate
//-(BOOL)textFieldShouldReturn:(UITextField*)textField
//{
//    [textField resignFirstResponder];
//    return NO;
//}
//
//@end
