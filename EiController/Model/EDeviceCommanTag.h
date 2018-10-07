//
//  EDeviceCommanTag.h
//  EiController
//
//  Created by Genrih Korenujenko on 02.04.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#warning TODO hvk: Rename error on xCode, need convert to swift enum
typedef NS_ENUM(NSInteger, EDeviceCommanTag)
{
    SYNC_WITH_EI_CENTRAL_TAG = 0,
    RESTART_NODE_TAG,
    RESTART_PLAYBACK_TAG,
    REBOOT_AND_SHUTDOWN_TAG,
    NETWORK_SETTINGS_TAG,
    MANAGEMENT_SERVER_TAG,
    SUPPORT_SERVER_TAG,
    SYNC_LOG_TAG,
    GET_INFO_TAG
};

