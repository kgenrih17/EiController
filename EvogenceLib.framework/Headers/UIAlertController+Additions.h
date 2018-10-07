//
//  UIAlertController+Additions.h
//  NavigationScroll
//
//  Created by admin on 11/13/15.
//  Copyright © 2015 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Additions)

+(void)showMessage:(NSString*)_text withTitle:(NSString*)_title;
+(void)showMessage:(NSString*)_text withTitle:(NSString *)_title acceptText:(NSString*)_acceptText declineText:(NSString*)_declinetext completion:(void (^)(BOOL isAccepted))_completion;

@end
