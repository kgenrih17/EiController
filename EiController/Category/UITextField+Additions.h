//
//  UITextField+Additions.h
//  EiController
//
//  Created by Genrih Korenujenko on 30.04.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NUMBERS @"0123456789"

@interface UITextField (Additions)

-(void)addString:(NSString*)string
           range:(NSRange)range
nextFirstResponders:(NSArray<UITextField*>*)fields
       maxLength:(NSInteger)maxLength;

@end
