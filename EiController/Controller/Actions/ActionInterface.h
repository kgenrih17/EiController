//
//  ActionInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ActionResult.h"
#import "ActionListener.h"

static const NSInteger REQUEST_TIMEOUT = 1;
static const NSInteger WAITING_TIME = 10;
static const NSInteger MAX_TRY_COUNT = 3;

typedef void(^Completion)(ActionResult *result);

@protocol ActionInterface <NSObject>

@required

-(void)do:(Completion)completion;
-(void)cancel;

@end
