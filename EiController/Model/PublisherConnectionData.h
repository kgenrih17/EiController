//
//  PublisherConnectionData.h
//  EiController
//
//  Created by Genrih Korenujenko on 31.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "ConnectionData.h"

@interface PublisherConnectionData : ConnectionData

-(void)save;
+(instancetype)get;

@end
