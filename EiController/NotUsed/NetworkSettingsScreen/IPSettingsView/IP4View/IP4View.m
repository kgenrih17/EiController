//
//  IP4View.m
//  EiController
//
//  Created by Genrih Korenujenko on 28.03.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "IP4View.h"
#import "UITextField+Additions.h"

@implementation IP4View

@synthesize addressesArray, netmasksArray, gatewaysArray;

#pragma mark - Public Init Methods
+(instancetype)build:(NSArray<NSString*>*)address
             netmask:(NSArray<NSString*>*)netmask
             gateway:(NSArray<NSString*>*)gateway
{
    IP4View *result = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    [result load:address netmask:netmask gateway:gateway];
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

-(BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL result = ((newString != nil) && (newString.length < 4) && [string isEqualToString:filtered]);
    if (result)
        [textField addString:string range:range nextFirstResponders:allFields maxLength:3];
    return result;
}

#pragma mark - Public Methods
-(void)load:(NSArray<NSString*>*)address
    netmask:(NSArray<NSString*>*)netmask
    gateway:(NSArray<NSString*>*)gateway
{
    [self fill:address forFields:addressesArray];
    [self fill:netmask forFields:netmasksArray];
    [self fill:gateway forFields:gatewaysArray];
}

#pragma mark - Private Methods
-(void)fill:(NSArray<NSString*>*)values forFields:(NSArray<UITextField*>*)fields
{
    [fields enumerateObjectsUsingBlock:^(UITextField *field, NSUInteger idx, BOOL *stop)
    {
        field.delegate = self;
        field.text = [values isValidIndex:idx] ? values[idx] : @"";
    }];
}

@end
