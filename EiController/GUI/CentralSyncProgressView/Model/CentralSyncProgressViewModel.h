//
//  CentralSyncProgressViewModel.h
//  EiController
//
//  Created by Genrih Korenujenko on 23.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CentralSyncProgressViewModel : NSObject

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;
@property (nonatomic, readwrite, copy) NSString *error;
@property (nonatomic, readwrite) CGFloat percent;
@property (nonatomic, readwrite) BOOL isCompleted;

-(BOOL)isSuccessful;
-(UIImage*)getProgressImage;

@end
