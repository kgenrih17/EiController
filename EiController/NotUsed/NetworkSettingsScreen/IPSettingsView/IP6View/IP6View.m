//
//  IP6View.m
//  EiController
//
//  Created by Genrih Korenujenko on 28.03.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "IP6View.h"

@implementation IP6View

@synthesize addressTextField, prefixLengthTextField, gatewayTextField;

#pragma mark - Public Init Methods
+(instancetype)build:(NSString*)address
        prefixLength:(NSString*)prefixLength
             gateway:(NSString*)gateway
{
    IP6View *result = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    [result load:address prefixLength:prefixLength gateway:gateway];
    return result;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField*)textField
{
    if (textField.text.isEmpty)
        textField.text = nil;
}

#pragma mark - Public Methods
-(void)load:(NSString*)address
prefixLength:(NSString*)prefixLength
    gateway:(NSString*)gateway
{
    addressTextField.text = address;
    addressTextField.text = prefixLength;
    addressTextField.text = gateway;
}

-(BOOL)isFilled
{
    return ((self.addressTextField.text.length > 0) && (self.prefixLengthTextField.text.length > 0) && (self.gatewayTextField.text.length > 0));
}

@end
