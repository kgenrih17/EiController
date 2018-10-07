//
//  SyncLogCell.m
//  EiController
//
//  Created by Genrih Korenujenko on 16.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "SyncLogCell.h"

#import "EiController-Swift.h"

@interface SyncLogCell ()

@property (nonatomic, readwrite, weak) IBOutlet GradientLabel *actionLabel;
@property (nonatomic, readwrite, weak) IBOutlet UIView *containerView;

@end

@implementation SyncLogCell

#pragma mark - Init
-(instancetype)initWithNib
{
    self = [super init];
    if (self)
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0];
    return self;
}

#pragma mark - Override Methods
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.descTextView.editable = NO;
}

#pragma mark - Public Methods
-(void)load:(SyncLogCellViewModel*)model
{
    self.containerView.backgroundColor = model.getContainerColor;
    self.actionLabel.title = model.action;
    self.dateLabel.text = model.date;
    self.dateLabel.backgroundColor = model.getSubtitleColor;
    self.descTextView.text = model.desc;
    self.descTextView.textColor = model.getTitleColor;
}

@end
