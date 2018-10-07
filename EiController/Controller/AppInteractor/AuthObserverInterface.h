//
//  AuthObserverInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 25.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "CentralConnectionData.h"

@protocol AuthObserverInterface <NSObject>

@required
-(void)showAuthScreen;
-(void)showNodesListScreen;

@end

