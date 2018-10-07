//
//  ApplicationFilesTable.h
//  EiController
//
//  Created by Genrih Korenujenko on 23.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "DatabaseTableInterface.h"
#import "FileInfoStorageInterface.h"
#import "ApplicationFile.h"

@interface ApplicationFilesTable : NSObject <DatabaseTableInterface, FileInfoStorageInterface>

-(void)remove:(ApplicationFile*)item;

@end
