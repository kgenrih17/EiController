//
//  MenuView.h
//  EiController
//
//  Created by Genrih Korenujenko on 23.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EMenuAction)
{
    GROUP_OPERATIONS_ACTION = 0,
    SETTINGS_ACTION
};

@protocol MenuActionInterface <NSObject>

@required
-(void)performAction:(EMenuAction)action;
-(void)closeMenu;

@end

@interface MenuView : UIView

+(instancetype)menuWithActionInterface:(id<MenuActionInterface>)actionInterface
                                  xPos:(CGFloat)xPos;
-(void)showGroupOperations:(BOOL)isShow;

@end
