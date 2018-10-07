//
//  ActionStatusInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 02.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

@protocol ActionStatusInterface <NSObject>

@property (nonatomic, readwrite) NSInteger actionIndex;
@property (nonatomic, readwrite) CGFloat progress;
@property (nonatomic, readwrite, copy) NSString *errorText;
@property (nonatomic, readwrite, strong) id info;
@property (nonatomic, readwrite, strong) NSMutableArray *percents;

@required
-(NSString*)getProgressTitle;
-(void)clear;

@optional
-(NSString*)getServerName;

@end
