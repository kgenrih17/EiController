//
//  SynchronizationScreenInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 18.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynchronizationViewModel.h"

@protocol SynchronizationScreenInterface <NSObject>

@required
-(void)refresh:(SynchronizationViewModel*)viewModel;
-(void)close;

@end
