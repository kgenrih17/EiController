//
//  ServerActionStatus.h
//  EiController
//
//  Created by Genrih Korenujenko on 21.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ActionStatusInterface.h"
#import "EActionType.h"

static const NSInteger SERVER_ACTIONS_COUNT = 5;

@interface ServerActionStatus : NSObject <ActionStatusInterface>

@property (nonatomic, readwrite) BOOL isProcessing;

@end
