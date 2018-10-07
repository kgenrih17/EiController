//
//  MenuView.m
//  EiController
//
//  Created by Genrih Korenujenko on 23.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "MenuView.h"

@interface MenuView ()
{
    IBOutletCollection(UIButton) NSArray *actionButtons;
    IBOutlet NSLayoutConstraint *rightDirectionConstraint;
    IBOutlet NSLayoutConstraint *centerXContainerConstraint;
    IBOutlet NSLayoutConstraint *groupOperationsHeightConstraint;;
    __weak IBOutlet UIView *directionView;
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UIButton *groupOperationsButton;
    __weak id <MenuActionInterface> actionInterface;
    CGFloat xPosition;
}

-(instancetype)initWithActionInterface:(id<MenuActionInterface>)actionInterface
                            xPos:(CGFloat)xPos;
@end

@implementation MenuView

#pragma mark - Public Init Methods
+(instancetype)menuWithActionInterface:(id<MenuActionInterface>)actionInterface
                                  xPos:(CGFloat)xPos;
{
    return [[MenuView alloc] initWithActionInterface:actionInterface xPos:xPos];
}

#pragma mark - Private Init Methods
-(instancetype)initWithActionInterface:(id<MenuActionInterface>)interface
                                  xPos:(CGFloat)xPos;
{
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    {
        actionInterface = interface;
        xPosition = xPos;
    }
    return self;
}

#pragma mark - Override Methods
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview != nil)
    {
        [self prepareConstraints];
        [self prepareActions];
        [directionView maskCorners:@[@(UIViewContentModeTopLeft), @(UIViewContentModeTopRight)]
                           toDepth:CGRectGetWidth(directionView.frame) / 2.0];
    }
}

-(void)removeFromSuperview
{
    [super removeFromSuperview];
    actionInterface = nil;
}

#pragma mark - Public Methods
-(void)showGroupOperations:(BOOL)isShow
{
    groupOperationsHeightConstraint.active = isShow;
    groupOperationsButton.hidden = !isShow;
}

#pragma mark - Action Methods
-(IBAction)action:(UIButton*)button
{
    [actionInterface performAction:button.tag];
    [self removeFromSuperview];
}

-(IBAction)close
{
    [actionInterface closeMenu];
    [self removeFromSuperview];
}

#pragma mark - Private Methods
-(void)prepareConstraints
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [[self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor] setActive:YES];
    [[self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor] setActive:YES];
    [[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor] setActive:YES];
    [[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor] setActive:YES];
    
    CGFloat superWidth = CGRectGetWidth(self.superview.frame);
    CGFloat directionWidth_2 = CGRectGetWidth(directionView.frame) / 2.0;
    CGFloat rightIndent = superWidth - (xPosition + directionWidth_2);
    CGFloat indent = 4;
    CGFloat minIndent = directionWidth_2 + indent;
    CGFloat maxIndent = superWidth - minIndent - directionWidth_2;
    
    if (rightIndent < minIndent)
        rightIndent = minIndent;
    else if (rightIndent > maxIndent)
        rightIndent = maxIndent;

    CGFloat minContainerIndent = 116;
    CGFloat containerIndent = 0;

    if (rightIndent < minContainerIndent)
        containerIndent = minContainerIndent - rightIndent;
    else if ((superWidth - rightIndent) < (minContainerIndent - indent))
        containerIndent = (superWidth - rightIndent - minIndent) - minContainerIndent;
    
    rightDirectionConstraint.constant = rightIndent;
    centerXContainerConstraint.constant = containerIndent;
}

-(void)prepareActions
{
    for (EMenuAction action = GROUP_OPERATIONS_ACTION; action < actionButtons.count; action++)
    {
        UIButton *button = actionButtons[action];
        button.tag = action;
    }
}

@end
