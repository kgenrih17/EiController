//
//  ScheduleFilesTable.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DatabaseTableInterface.h"
#import "FileInfoStorageInterface.h"
#import "ScheduleFile.h"

@interface ScheduleFilesTable : NSObject <DatabaseTableInterface, FileInfoStorageInterface>

-(NSMutableArray<ScheduleFile*>*)getAll;

@end

