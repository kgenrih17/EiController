//
//  GroupOperationView.m
//  ASController
//
//  Created by Max on 11/24/14.
//  Copyright (c) 2014 Evogence. All rights reserved.
//

#import "GroupOperationView.h"

@interface GroupOperationView ()
{
//    __weak id <GroupOperationViewActionInterface> actionInterface;
    IBOutletCollection(UIButton) NSArray *buttons;
    __weak IBOutlet UIImageView *selectAllImageView;
    __weak IBOutlet UILabel *selectAllLabel;
    __weak IBOutlet UIButton *selectAllButton;
    __weak IBOutlet UIButton *restartButton;
    __weak IBOutlet UIButton *restartPlaybackButton;
    __weak IBOutlet UIButton *networkSettingsButton;
    __weak IBOutlet UIButton *managementButton;
    __weak IBOutlet UIButton *reverseMonitoringButton;
}
@end

@implementation GroupOperationView

//#pragma mark - Public Init Methods
//-(instancetype)initWithActionInterface:(id<GroupOperationViewActionInterface>)interface
//{
//    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
//
//    if (self)
//    {
//        actionInterface = interface;
//    }
//
//    return self;
//}
//
//#pragma mark - Override Methods
//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//
//    selectAllButton.tag = SELECT_ALL_ACTION;
//    restartButton.tag = RESTART_NODE_ACTION;
//    restartPlaybackButton.tag = RESTART_PLAYBACK_ACTION;
//    networkSettingsButton.tag = NETWORK_SETTINGS_ACTION;
//    managementButton.tag = MANAGEMENT_SERVER_ACTION;
//    reverseMonitoringButton.tag = REVERSE_MONITORING_ACTION;
//}
//
//#pragma mark - Action Methods
//-(IBAction)action:(UIButton*)action
//{
//    [actionInterface groupOperationAction:action.tag];
//}
//
//-(void)select:(BOOL)isSelect byAction:(EGroupAction)action
//{
//    UIButton *button = buttons[action];
//    button.selected = isSelect;
//    [self refreshState:button Action:action];
//}
//
//#pragma mark - Private Methods
//-(void)refreshState:(UIButton*)button Action:(EGroupAction)action
//{
//    if (action == SELECT_ALL_ACTION)
//    {
//        if (button.isSelected)
//        {
//            selectAllLabel.text = @"DESELECT\nALL";
//            selectAllImageView.image = [UIImage imageNamed:@"group_operation_deselected_all_icon"];
//        }
//        else
//        {
//            selectAllLabel.text = @"SELECT\nALL";
//            selectAllImageView.image = [UIImage imageNamed:@"group_operation_selected_all_icon"];
//        }
//    }
//}

@end
