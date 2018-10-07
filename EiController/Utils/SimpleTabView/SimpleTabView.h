//
//  SimpleTabView.h
//  ASEnterprise
//
//  Created by Genrih Korenujenko on 22.12.16.
//  Copyright © 2016 Evogence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTabTitleView.h"

@protocol SimpleTabViewDatasource;

@interface SimpleTabView : UIView

@property (nonatomic, readwrite, weak) IBOutlet NSObject <SimpleTabViewDatasource> *datasource;
@property (nonatomic, readwrite) IBOutlet UIView *titlesView;
@property (nonatomic, readwrite) IBOutlet UIView *detailsView;

@property (nonatomic, readwrite) CGFloat indentBetweenTabs;

-(void)reloadData;

@end

@protocol SimpleTabViewDatasource <NSObject>

@required
-(NSInteger)numberOfTabsInSimpleTabView:(SimpleTabView*)_simpleTabView;
-(SimpleTabTitleView*)simpleTabView:(SimpleTabView*)_simpleTabView tabTitleViewAtIndex:(NSInteger)_index;
-(UIView*)simpleTabView:(SimpleTabView*)_simpleTabView tabDetailsViewAtIndex:(NSInteger)_index;
-(NSInteger)selectedTitleIndex;
-(void)simpleTabView:(SimpleTabView*)_simpleTabView didSelectedTabAtIndex:(NSInteger)_index;

@optional
-(BOOL)isOnHorizontalScroll;
-(NSInteger)maximumNumberOfTitles;

@end
