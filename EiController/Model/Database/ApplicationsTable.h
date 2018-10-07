//
//  ApplicationsTable.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DatabaseTableInterface.h"
#import "ApplicationStorageInterface.h"
#import "Application.h"

@interface ApplicationsTable : NSObject <DatabaseTableInterface, ApplicationStorageInterface>

-(NSMutableArray<Application*>*)getAll;
-(void)remove:(Application*)item;

@end
