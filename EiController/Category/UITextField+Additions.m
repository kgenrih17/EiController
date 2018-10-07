//
//  UITextField+Additions.m
//  EiController
//
//  Created by Genrih Korenujenko on 30.04.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "UITextField+Additions.h"

@implementation UITextField (Additions)

#pragma mark - Public Methods
-(void)addString:(NSString*)string
           range:(NSRange)range
nextFirstResponders:(NSArray<UITextField*>*)fields
       maxLength:(NSInteger)maxLength
{
    NSString *newString = [self.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length == maxLength)
    {
        UITextField *nextField = [self prepareNextField:fields];
        if (nextField != nil)
            [self afterResignFirstResponder:nextField];
    }
}

#pragma mark - Private Methods
-(UITextField*)prepareNextField:(NSArray<UITextField*>*)fields
{
    UITextField *result = nil;
    NSInteger index = [fields indexOfObject:self];
    if ([fields isValidIndex:index + 1])
        result = fields[index + 1];
    else if (fields != nil && !fields.isEmpty)
        result = fields.firstObject;
    return result;
}

-(void)afterResignFirstResponder:(UITextField*)textField
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField becomeFirstResponder];
    });
}

@end
