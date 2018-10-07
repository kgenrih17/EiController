//
//  ItemSelector.h
//  Collabra
//
//  Created by Artem on 5/21/14.
//  Copyright (c) 2014 Radical Computing. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger NON_SELECTED_INDEX = -1;

@protocol DropDownItemSelectorDelegate;

@interface DropDownItemSelector : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableComboBox;
    UIButton *selectedItem;
    UIView *separatedLine;
}

@property (nonatomic, strong) UILabel *titleSelectedItem;
@property (nonatomic, strong) UIView *titleBg;
@property (nonatomic, strong) UIImageView *selectedIcon;
@property (nonatomic) CGFloat heightTableCell;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger selectedItemCell;
@property (nonatomic, strong) UIColor *rowTitleColor;
@property (nonatomic, strong) UIColor *rowTitleSelectedColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIFont *cellFont;
@property(nonatomic) BOOL isShowed;
@property(nonatomic) BOOL isShowEvenAOneItem;
@property(nonatomic, weak) id<DropDownItemSelectorDelegate> delegate;

-(void)setItems:(NSArray*)array selectedItem:(NSInteger)_selectedItem;
-(void)show;
-(void)hide;

-(void)setSelectedItemColor:(UIColor*)_color;
-(void)setBorder:(CGFloat)_borderWidth color:(UIColor*)_color cornerRadius:(CGFloat)_radius;

-(void)recalculateSize;

@end

@protocol DropDownItemSelectorDelegate <NSObject>

@optional
-(void)didSelect:(DropDownItemSelector*)_itemSelector withItem:(NSInteger)_index;
-(void)willShowItemSelector:(DropDownItemSelector*)_itemSelector byHeight:(CGFloat)_height;
-(void)didShowItemSelector:(DropDownItemSelector*)_itemSelector;
-(void)willHideItemSelector:(DropDownItemSelector*)_itemSelector byHeight:(CGFloat)_height;
-(void)didHideItemSelector:(DropDownItemSelector*)_itemSelector;
@end
