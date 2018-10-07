//
//  HTTPServerObserverInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 25.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

@protocol HTTPServerObserverInterface <NSObject>

@required
-(void)receivedRequest:(NSString*)path
                method:(NSString*)method
             ipAddress:(NSString*)ipAddress
           fingerprint:(NSString*)fingerprint
                 error:(NSString*)error;

@end
