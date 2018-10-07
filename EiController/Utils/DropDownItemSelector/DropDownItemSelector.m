//
//  ItemSelector.m
//  Collabra
//
//  Created by Artem on 5/21/14.
//  Copyright (c) 2014 Radical Computing. All rights reserved.
//

#import "DropDownItemSelector.h"
#import "DropDownItemSelectorCell.h"

static NSString *upImage = @"dropdown_up_arrow";
static NSString *downImage = @"dropdown_down_arrow";
const NSInteger TITLE_LBL_TAG = NSIntegerMax;

static const CGFloat ICON_WIDTH = 5.0;
static const CGFloat ICON_HEIGHT = 12.0;
static const CGFloat ICON_SPACE = 15.0;

@interface DropDownItemSelector ()
{
    CGFloat widthComboBox;
    CGFloat teableComboBox;
    
    NSMutableArray *titlesArray;
    
    NSLayoutConstraint *widthConstraint;
}
@end

@implementation DropDownItemSelector
@synthesize selectedIcon, titleSelectedItem, titleBg, heightTableCell, cellFont, selectedItemCell;
@synthesize isShowEvenAOneItem;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.count = 4;
        
        [self prepareGui];
        selectedItemCell = NON_SELECTED_INDEX;
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        titlesArray = [NSMutableArray new];
        
        [self initTableView];
        [self initSelectedItem];
        [self initTitleSelectedItem];
        [self initTitleBackground];
        [self initSeparatorLine];
        [self initSelectedIcon];
        
        
        [self addSubview:tableComboBox];
        [self addSubview:titleBg];
        [self addSubview:selectedItem];
        [self addSubview:titleSelectedItem];
        [self addSubview:separatedLine];
        [self addSubview:selectedIcon];
    }
    
    return self;
}

#pragma mark - Init Classes
-(void)initTableView
{
    tableComboBox = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthComboBox, 0.0)];
    tableComboBox.delegate = self;
    tableComboBox.dataSource = self;
    tableComboBox.separatorColor = [UIColor clearColor];
    tableComboBox.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableComboBox.backgroundColor = [UIColor clearColor];
    tableComboBox.scrollEnabled = YES;
}

-(void)initSelectedItem
{
    selectedItem = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, widthComboBox, heightTableCell)];
    [selectedItem addTarget:self action:@selector(showTable) forControlEvents:UIControlEventTouchUpInside];
    selectedItem.backgroundColor = [UIColor clearColor];
}

-(void)initTitleSelectedItem
{
    titleSelectedItem = [[UILabel alloc] initWithFrame:CGRectMake(4, 0.0, widthComboBox - ICON_WIDTH - ICON_SPACE - 4, self.frame.size.height)];
    titleSelectedItem.backgroundColor = [UIColor clearColor];
    titleSelectedItem.font = [UIFont systemFontOfSize:14];
    titleSelectedItem.textColor = [UIColor colorWithRed:(18.0f/255.0f) green:(96.0f/255.0f) blue:(174.0f/255.0f) alpha:1.0f];
    titleSelectedItem.textAlignment = NSTextAlignmentLeft;
}

-(void)initTitleBackground
{
    titleBg = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthComboBox, heightTableCell)];
    titleBg.backgroundColor = [UIColor whiteColor];
}

-(void)initSeparatorLine
{
    separatedLine = [[UIView alloc] initWithFrame:CGRectMake(0, heightTableCell - 1, widthComboBox, 1)];
    separatedLine.backgroundColor = [UIColor colorWithRed:(219.0f/255.0f) green:(227.0f/255.0f) blue:(230.0f/255.0f) alpha:1.0f];
}

-(void)initSelectedIcon
{
    float iconYPos = (titleSelectedItem.frame.size.height/2) - (ICON_HEIGHT/4);
    float iconXPos = titleBg.frame.size.width - ICON_WIDTH - ICON_SPACE;
    
    selectedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconXPos, iconYPos, ICON_HEIGHT, ICON_WIDTH)];
    selectedIcon.image = [UIImage imageNamed:downImage];
    selectedIcon.backgroundColor = [UIColor clearColor];
}

#pragma mark - Public Methods
-(void)setItems:(NSArray*)array selectedItem:(NSInteger)_selectedItem;
{
    [titlesArray removeAllObjects];
    [titlesArray addObjectsFromArray:array];
    
    self.count = [titlesArray count];
    
    selectedItemCell = _selectedItem;
    if (selectedItemCell == NON_SELECTED_INDEX)
        [titleSelectedItem setFrame:CGRectMake(titleSelectedItem.frame.origin.x, 7, titleSelectedItem.frame.size.width, titleSelectedItem.frame.size.height)];
    
    [self prepareGui];
}

-(void)show
{
    if ( (titlesArray.count > 0) && (self.isShowed == NO) )
    {
        self.isShowed = YES;
        [tableComboBox reloadData];
        selectedIcon.image = [UIImage imageNamed:upImage];
        tableComboBox.alpha = 1.0f;
        
        if ([self.delegate respondsToSelector:@selector(willShowItemSelector:byHeight:)])
            [self.delegate willShowItemSelector:self byHeight:heightTableCell+teableComboBox];
        
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, widthComboBox, heightTableCell+teableComboBox);
            tableComboBox.frame = CGRectMake(0.0, heightTableCell, widthComboBox, teableComboBox);
            titleSelectedItem.alpha = 0.0f;
        }
        completion:^(BOOL finished)
        {
            if ([self.delegate respondsToSelector:@selector(didShowItemSelector:)])
                [self.delegate didShowItemSelector:self];
        }];
    }
}

-(void)hide
{
    [self hideWithAnimation:YES];
}

-(void)setSelectedItemColor:(UIColor*)_color
{
    titleSelectedItem.textColor = _color;
}

-(void)setBorder:(CGFloat)_borderWidth color:(UIColor *)_color cornerRadius:(CGFloat)_radius
{
    [self.layer setCornerRadius:_radius];
    [self.layer setBorderWidth:_borderWidth];
    [self.layer setBorderColor:[_color CGColor]];
}

-(void)recalculateSize
{
    widthComboBox = CGRectGetWidth(self.frame);
    heightTableCell = CGRectGetHeight(self.frame);
    
    [self hideWithAnimation:NO];
    
    [UIView animateWithDuration:0.25 animations:^
    {
        [tableComboBox setWidth:widthComboBox];
        [selectedItem setWidth:widthComboBox];
        [titleSelectedItem setWidth:(widthComboBox - ICON_WIDTH - ICON_SPACE - 4)];
        [titleBg setWidth:widthComboBox];
        [separatedLine setWidth:widthComboBox];
        
        float iconYPos = (titleSelectedItem.frame.size.height/2) - (ICON_HEIGHT/4);
        float iconXPos = titleBg.frame.size.width - ICON_WIDTH - ICON_SPACE;
        
        selectedIcon.frame = CGRectMake(iconXPos, iconYPos, ICON_HEIGHT, ICON_WIDTH);
    }];
}

#pragma mark - Private Methods
-(void)prepareGui
{
    widthComboBox = self.frame.size.width;
    heightTableCell = self.frame.size.height;
    
    [UIView animateWithDuration:0.0f animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, widthComboBox, heightTableCell);
    }];
    
    selectedItem.enabled = YES;
    selectedIcon.hidden = NO;
    
    titleSelectedItem.textAlignment = NSTextAlignmentLeft;
    
    if (self.count > 8)
        self.count = 8;
    else if (self.count == 1)
        selectedItem.enabled = isShowEvenAOneItem;
    
    teableComboBox = heightTableCell * self.count;
    
    [self prepareTableComboBox];
}

-(void)prepareTableComboBox
{
    if ([titlesArray count] > 0)
    {
        if (selectedItemCell != NON_SELECTED_INDEX && [titlesArray isValidIndex:selectedItemCell])
            titleSelectedItem.text = [titlesArray objectAtIndex:selectedItemCell];
        else
            titleSelectedItem.text = @"";
    }
    
    [self initSwipe];
    [tableComboBox reloadData];
}

-(void)initSwipe
{
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showTable)];
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [selectedItem addGestureRecognizer:downSwipe];
    
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showTable)];
    [upSwipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [selectedItem addGestureRecognizer:upSwipe];
}

-(void)showTable
{
    if (!self.isShowed)
        [self show];
    else
        [self hide];
}

-(void)hideWithAnimation:(BOOL)_animation
{
    if (self.isShowed == YES)
    {
        self.isShowed = NO;
        selectedIcon.image = [UIImage imageNamed:downImage];
        
        if (_animation)
        {
            if ([self.delegate respondsToSelector:@selector(willHideItemSelector:byHeight:)])
                [self.delegate willHideItemSelector:self byHeight:heightTableCell];

            [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^
            {
                [self setupHide];
            }
            completion:^(BOOL finished)
            {
                if ([self.delegate respondsToSelector:@selector(didHideItemSelector:)])
                    [self.delegate didHideItemSelector:self];
            }];
        }
        else
            [self setupHide];
    }
}

-(void)setupHide
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, widthComboBox, heightTableCell);
    tableComboBox.frame = CGRectMake(0.0, 0.0, widthComboBox, 0.0);
    titleSelectedItem.alpha = 1.0f;
    tableComboBox.alpha = 0.2f;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titlesArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropDownItemSelectorCell *cell = (DropDownItemSelectorCell*)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DropDownItemSelectorCell class])];
    
    if (!cell)
        cell = (DropDownItemSelectorCell*)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DropDownItemSelectorCell class]) owner:self options:nil] firstObject];
    
    cell.title.text = [titlesArray objectAtIndex:indexPath.row];
    
    if (selectedItemCell == indexPath.row)
        cell.title.textColor = [UIColor colorWithRed:(18.0f/255.0f) green:(96.0f/255.0f) blue:(174.0f/255.0f) alpha:1.0f];
    else
        cell.title.textColor = [UIColor blackColor];
    
    if (cellFont)
        cell.title.font = cellFont;
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return heightTableCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    titleSelectedItem.text = [titlesArray objectAtIndex:indexPath.row];
    selectedItemCell = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(didSelect:withItem:)])
        [self.delegate didSelect:self withItem:indexPath.row];
    
    [self hide];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

@end
