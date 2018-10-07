//
//  SyncLogCell.h
//  EiController
//
//  Created by Genrih Korenujenko on 16.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncLogCellViewModel.h"

@interface SyncLogCell : UITableViewCell

@property (nonatomic, readwrite, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, readwrite, weak) IBOutlet UITextView *descTextView;

-(instancetype)initWithNib;
-(void)load:(SyncLogCellViewModel*)model;

@end
