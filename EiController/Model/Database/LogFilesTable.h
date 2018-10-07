//
//  LogFilesTable.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DatabaseTableInterface.h"
#import "FileInfoStorageInterface.h"
#import "LogFile.h"

@interface LogFilesTable : NSObject <DatabaseTableInterface, FileInfoStorageInterface>

-(NSMutableArray<LogFile*>*)getAll;

@end
