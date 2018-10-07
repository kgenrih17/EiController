//
//  PopupView.h
//  EiController
//
//  Created by admin on 2/15/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopupViewHideCompl)(NSDate*);

@interface PopupView : UIViewController

-(void)setParentView:(UIView*)_parentView;
-(void)show:(NSDate*)date;
-(void)hide;
-(void)closeCompletion:(PopupViewHideCompl)_completion;
-(BOOL)isShow;

@end
