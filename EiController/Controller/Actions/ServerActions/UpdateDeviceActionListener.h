//
//  UpdateDeviceActionListener.h
//  EiController
//
//  Created by Genrih Korenujenko on 31.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "ActionListener.h"

@protocol UpdateDeviceActionListener <ActionListener>

@required
-(void)publisherDataUpdated;

@end
