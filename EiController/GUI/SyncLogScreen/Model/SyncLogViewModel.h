//
//  SyncLogViewModel.h
//  EiController
//
//  Created by Genrih Korenujenko on 21.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncLogViewModel : NSObject

@property (nonatomic, readwrite) BOOL isExtender;
@property (nonatomic, readwrite, copy) NSString *tabBarTitle;
@property (nonatomic, readwrite, copy) NSAttributedString *title;
@property (nonatomic, readwrite) NSInteger numberOfLine;

-(UIColor*)getBackgroundColor;
-(UIColor*)getContainerColor;

@end
