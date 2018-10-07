//
//  EDeviceStatus.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#ifndef EDeviceStatus_h
#define EDeviceStatus_h

typedef NS_ENUM(NSInteger, EDeviceStatus)
{
    CENTRAL_AND_LOCAL_STATUS = 0,     /// green: exist local and exist on Central
    CENTRAL_STATUS,       /// grey: exit on Central, but does not exit local
    LOCAL_STATUS,         /// red: exist local, but does not exist on Central
    /// yellow: exist local and exist on Central, but refuse connection
    /// purple: exist local, don't exist on Central, but does not refuse connection
};

#endif /* EDeviceStatus_h */
