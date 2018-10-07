//
//  SyncLogCellViewModel.h
//  EiController
//
//  Created by Genrih Korenujenko on 14.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncLogCellViewModel : NSObject

@property (nonatomic, readwrite) BOOL isExtender;

@property (nonatomic, readwrite, copy) NSString *action;
@property (nonatomic, readwrite, copy) NSString *date;
@property (nonatomic, readwrite, copy) NSString *desc;
@property (nonatomic, readwrite, strong) UIColor *descColor;

-(UIColor*)getTitleColor;
-(UIColor*)getSubtitleColor;
-(UIColor*)getContainerColor;

@end
