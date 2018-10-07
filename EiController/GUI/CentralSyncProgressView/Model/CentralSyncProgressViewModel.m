//
//  CentralSyncProgressViewModel.m
//  EiController
//
//  Created by Genrih Korenujenko on 23.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "CentralSyncProgressViewModel.h"

@implementation CentralSyncProgressViewModel

#pragma mark - Public Methods
-(BOOL)isSuccessful
{
    return (self.error == nil || self.error.isEmpty);
}

-(UIImage*)getProgressImage
{
    return [[UIImage imageNamed:@"central_sync_progress_view_patern.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                                                           resizingMode:UIImageResizingModeTile];
}

@end
