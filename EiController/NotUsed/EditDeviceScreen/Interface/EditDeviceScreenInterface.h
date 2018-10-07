
//
//  EditDeviceScreenInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ScreenInterface.h"
#import "EditDeviceViewModel.h"

@protocol EditDeviceScreenInterface <ScreenInterface>

@required
-(void)refresh:(EditDeviceViewModel*)model;

@end

