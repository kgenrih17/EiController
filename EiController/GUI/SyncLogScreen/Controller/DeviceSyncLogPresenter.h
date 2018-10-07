//
//  DeviceSyncLogPresenter.h
//  EiController
//
//  Created by Genrih Korenujenko on 08.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncLogPresenterInterface.h"

@interface DeviceSyncLogPresenter : NSObject <SyncLogPresenterInterface>
{
    NSString *fingerprint;
}
@end
