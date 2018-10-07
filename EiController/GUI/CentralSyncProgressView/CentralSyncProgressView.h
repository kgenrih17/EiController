//
//  CentralSyncProgressView.h
//  EiController
//
//  Created by Genrih Korenujenko on 23.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CentralSyncProgressViewModel.h"

@protocol CentralSyncProgressViewActionInterface <NSObject>

@required
-(void)closeCentralSyncProgressView;

@end

@interface CentralSyncProgressView : UIView

+(instancetype)progressWithActionInterface:(id<CentralSyncProgressViewActionInterface>)actionInterface
                                     model:(CentralSyncProgressViewModel*)model;

-(void)load:(CentralSyncProgressViewModel*)viewMode;

@end
