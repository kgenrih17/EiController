//
//  HTTPResponseInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 19.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDWebServerMultiPartFormRequest.h"

@protocol HTTPResponseInterface <NSObject>

@required
-(NSString*)processing:(id)params;

@end

