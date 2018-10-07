//
//  DataBaseStorage.h
//  EiController
//
//  Created by Genrih Korenujenko on 13.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <EvogenceLib/EvogenceLib.h>

typedef void(^CallBack)(FMResultSet*resultSet);

@interface DataBaseStorage : Database

-(void)transactionSQL:(NSString*)sql arguments:(NSArray*)arguments;
-(void)executeSQL:(NSString*)sql arguments:(NSArray*)arguments completion:(CallBack)completion;

@end
