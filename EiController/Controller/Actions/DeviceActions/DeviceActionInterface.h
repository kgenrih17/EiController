//
//  DeviceActionInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 25.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "ActionInterface.h"
#import "TransferInterface.h"

@protocol DeviceActionInterface <ActionInterface, TransferListener>

@required
-(void)setDevice:(Device*)device byConnectionData:(ConnectionData*)connectionData;

@end

