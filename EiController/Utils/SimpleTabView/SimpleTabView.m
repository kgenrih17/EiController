//
//  SimpleTabView.m
//  ASEnterprise
//
//  Created by Genrih Korenujenko on 22.12.16.
//  Copyright © 2016 Evogence. All rights reserved.
//

#import "SimpleTabView.h"

static const CGFloat DEFAULT_TAB_TITLE_WIDTH_PERCENT = 0.19;
static const CGFloat DEFAULT_GRADIENT_WIDTH_PERCENT = 0.07;

@interface SimpleTabView () <UIScrollViewDelegate>
{
    NSInteger indexes;
    NSInteger maximumNumberOfTitles;
    NSInteger selectedIndex;
    NSMutableArray *tabTitlesView;
    
    UIScrollView *titlesScrollView;
    UIImageView *leftGradientView;
    UIImageView *rightGradientView;
}
@end

@implementation SimpleTabView

@synthesize datasource;
@synthesize titlesView;
@synthesize detailsView;
@synthesize indentBetweenTabs;

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    indentBetweenTabs = 0;
    maximumNumberOfTitles = NSNotFound;
    tabTitlesView = [NSMutableArray new];
    
    [self initScrollView];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Init Classes
-(void)initScrollView
{
    titlesScrollView = [[UIScrollView alloc] initWithFrame:titlesView.bounds];
    titlesScrollView.backgroundColor = [UIColor clearColor];
    titlesScrollView.delegate = self;
    titlesScrollView.alwaysBounceVertical = NO;
    titlesScrollView.alwaysBounceHorizontal = NO;
    titlesScrollView.showsVerticalScrollIndicator = NO;
    titlesScrollView.showsHorizontalScrollIndicator = NO;
    
    [titlesView addSubview:titlesScrollView];
    
    titlesScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [[titlesScrollView.topAnchor constraintEqualToAnchor:titlesView.topAnchor] setActive:YES];
    [[titlesScrollView.bottomAnchor constraintEqualToAnchor:titlesView.bottomAnchor] setActive:YES];
    [[titlesScrollView.leadingAnchor constraintEqualToAnchor:titlesView.leadingAnchor] setActive:YES];
    [[titlesScrollView.trailingAnchor constraintEqualToAnchor:titlesView.trailingAnchor] setActive:YES];
}

#pragma mark - Public Methods
-(void)reloadData
{
    if ([datasource respondsToSelector:@selector(numberOfTabsInSimpleTabView:)])
    {
        indexes = [datasource numberOfTabsInSimpleTabView:self];
        
        if ([datasource respondsToSelector:@selector(isOnHorizontalScroll)])
            titlesScrollView.alwaysBounceHorizontal = [datasource isOnHorizontalScroll];
        else
            titlesScrollView.alwaysBounceHorizontal = NO;
        
        if ([datasource respondsToSelector:@selector(maximumNumberOfTitles)])
            maximumNumberOfTitles = [datasource maximumNumberOfTitles];
        
        [self clearTabTitlesView];
        [self clearTabDetailsView];
        
        selectedIndex = 0;
        
        if (indexes > 0)
            [self buildTabView];
    }
}

#pragma mark - Private Methods
-(void)clearTabTitlesView
{
    for (UIView *subview in tabTitlesView)
    {
        [titlesScrollView removeConstraints:subview.constraints];
        [subview removeFromSuperview];
    }
    
    [tabTitlesView removeAllObjects];
    
    [leftGradientView removeFromSuperview];
    [rightGradientView removeFromSuperview];
}

-(void)clearTabDetailsView
{
    for (UIView *subview in detailsView.subviews)
        [subview removeFromSuperview];
}

-(void)buildTabView
{
    [self setNeedsLayout];
    
    for (NSInteger index = 0; index < indexes; index++)
        [self prepareTabTitleViewAtIndex:index];
    
    [self addConstraintsForTabTitles];
    
    if ([datasource respondsToSelector:@selector(selectedTitleIndex)])
        selectedIndex = [datasource selectedTitleIndex];
    
    [self prepareTabDetailView];
    
    if (titlesScrollView.alwaysBounceHorizontal)
        [self prepareGradientsView];
    
    [self layoutIfNeeded];
}

-(void)prepareTabTitleViewAtIndex:(NSInteger)_index
{
    SimpleTabTitleView *tabTitleView = nil;
    
    if ([datasource respondsToSelector:@selector(simpleTabView:tabTitleViewAtIndex:)])
    {
        tabTitleView = [datasource simpleTabView:self tabTitleViewAtIndex:_index];
        
        if (tabTitleView)
        {
            tabTitleView.frame = CGRectMake(100 * _index, 0, 200, CGRectGetHeight(titlesScrollView.frame));
            tabTitleView.titleButton.tag = _index;
            [tabTitleView.titleButton addTarget:self action:@selector(didSelectedTitle:) forControlEvents:UIControlEventTouchUpInside];
            
            [titlesScrollView addSubview:tabTitleView];
            [tabTitlesView addObject:tabTitleView];
        }
    }
}

-(void)addConstraintsForTabTitles
{
    UIView *prevTabTitleView = nil;
    
    for (UIView *tabTitleView in tabTitlesView)
    {
        CGFloat percent = 1.0 / (CGFloat)indexes;
        
        if (maximumNumberOfTitles != NSNotFound)
            percent = 1.0 / (CGFloat)maximumNumberOfTitles;
        else if (titlesScrollView.alwaysBounceHorizontal)
            percent = DEFAULT_TAB_TITLE_WIDTH_PERCENT;
        
        tabTitleView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [[tabTitleView.topAnchor constraintEqualToAnchor:titlesScrollView.topAnchor] setActive:YES];
        [[tabTitleView.bottomAnchor constraintEqualToAnchor:titlesScrollView.bottomAnchor] setActive:YES];
        [[tabTitleView.heightAnchor constraintEqualToAnchor:titlesScrollView.heightAnchor multiplier:1] setActive:YES];
        [[tabTitleView.widthAnchor constraintEqualToAnchor:titlesScrollView.widthAnchor multiplier:percent] setActive:YES];
        
        if (prevTabTitleView)
            [[tabTitleView.leadingAnchor constraintEqualToAnchor:prevTabTitleView.trailingAnchor constant:self.indentBetweenTabs] setActive:YES];
        else
            [[tabTitleView.leadingAnchor constraintEqualToAnchor:titlesScrollView.leadingAnchor constant:self.indentBetweenTabs] setActive:YES];
        
        if ([tabTitleView isEqual:tabTitlesView.lastObject])
            [[tabTitleView.trailingAnchor constraintEqualToAnchor:titlesScrollView.trailingAnchor constant:self.indentBetweenTabs] setActive:YES];
        else
            prevTabTitleView = tabTitleView;
    }
}

-(void)prepareTabDetailView
{
    if ([datasource respondsToSelector:@selector(simpleTabView:tabDetailsViewAtIndex:)])
    {
        UIView *tabDetailsView = [datasource simpleTabView:self tabDetailsViewAtIndex:selectedIndex];
        
        if (tabDetailsView)
        {
            [detailsView addSubview:tabDetailsView];
            
            tabDetailsView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [[tabDetailsView.leadingAnchor constraintEqualToAnchor:detailsView.leadingAnchor] setActive:YES];
            [[tabDetailsView.topAnchor constraintEqualToAnchor:detailsView.topAnchor] setActive:YES];
            [[tabDetailsView.bottomAnchor constraintEqualToAnchor:detailsView.bottomAnchor] setActive:YES];
            [[tabDetailsView.trailingAnchor constraintEqualToAnchor:detailsView.trailingAnchor] setActive:YES];
        }
    }
}

-(void)prepareGradientsView
{
    leftGradientView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, CGRectGetHeight(titlesView.frame))];
    rightGradientView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, CGRectGetHeight(titlesView.frame))];
    
    leftGradientView.image = [UIImage imageNamed:@"settings_tab_left_gradient"];
    rightGradientView.image = [UIImage imageNamed:@"settings_tab_right_gradient"];
    
    leftGradientView.backgroundColor = [UIColor clearColor];
    rightGradientView.backgroundColor = [UIColor clearColor];
    
    [titlesView addSubview:leftGradientView];
    [titlesView addSubview:rightGradientView];
    
    [self addConstraintsForGradiesntViews];
    [self scrollViewDidScroll:titlesScrollView];
}

-(void)addConstraintsForGradiesntViews
{
    for (UIView *view in @[leftGradientView, rightGradientView])
    {
        view.userInteractionEnabled = NO;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        [[view.topAnchor constraintEqualToAnchor:titlesView.topAnchor] setActive:YES];
        [[view.widthAnchor constraintEqualToAnchor:titlesView.widthAnchor multiplier:DEFAULT_GRADIENT_WIDTH_PERCENT] setActive:YES];
        [[view.heightAnchor constraintEqualToAnchor:titlesView.heightAnchor multiplier:1] setActive:YES];
    }
    
    [[rightGradientView.trailingAnchor constraintEqualToAnchor:titlesView.trailingAnchor] setActive:YES];
    [[leftGradientView.leadingAnchor constraintEqualToAnchor:titlesView.leadingAnchor] setActive:YES];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)scrollToSelectedTabIndex
{
    CGPoint newContentOffset = titlesScrollView.contentOffset;
    SimpleTabTitleView *tabTitleView = [tabTitlesView objectAtIndex:selectedIndex];
    
    CGFloat minX = CGRectGetMinX(tabTitleView.frame);
    CGFloat maxX = CGRectGetMaxX(tabTitleView.frame);
    CGFloat contentOffsetX = titlesScrollView.contentOffset.x;
    CGFloat scrollWidth = CGRectGetWidth(titlesScrollView.frame);
    
    if (maxX > (scrollWidth + contentOffsetX))
        newContentOffset.x = (maxX - scrollWidth);
    else if (minX < contentOffsetX)
        newContentOffset.x = minX;
    
    [titlesScrollView setContentOffset:newContentOffset animated:YES];
}

#pragma mark - Action
-(void)didSelectedTitle:(UIButton*)_button
{
    if ([datasource respondsToSelector:@selector(simpleTabView:didSelectedTabAtIndex:)])
        [datasource simpleTabView:self didSelectedTabAtIndex:_button.tag];
    
    [self reloadData];
    
    if (titlesScrollView.alwaysBounceHorizontal)
        [self scrollToSelectedTabIndex];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    NSInteger width = CGRectGetWidth(scrollView.frame);
    NSInteger contentWidth = scrollView.contentSize.width;
    NSInteger contentOffsetX = scrollView.contentOffset.x;
    
    leftGradientView.hidden = (scrollView.contentOffset.x <= 0);
    rightGradientView.hidden = ( (width + contentOffsetX) >= contentWidth );
}

#pragma mark - Notifications
-(void)changeOrientation
{
    [self scrollViewDidScroll:titlesScrollView];
}

@end
