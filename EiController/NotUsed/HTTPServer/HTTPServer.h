//
//  HTTPServer.h
//  EiController
//
//  Created by Genrih Korenujenko on 19.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPServerObserverInterface.h"

@interface HTTPServer : NSObject

-(void)start;
-(void)stop;

-(void)setObserver:(id<HTTPServerObserverInterface>)observer;

@end
