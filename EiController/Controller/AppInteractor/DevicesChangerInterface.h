//
//  DevicesChangerInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 24.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

@protocol DevicesChangerInterface <NSObject>

@required
-(void)userDevicesUpdated;
-(void)userDevicesNotUpdated;

@end

