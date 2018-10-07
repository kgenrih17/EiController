//
//  ScheduleFile.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "FileInfoInterface.h"

@interface ScheduleFile : NSObject <FileInfoInterface>

@property (nonatomic, readwrite, strong) NSString *md5;
@property (nonatomic, readwrite, strong) NSString *esID;

@end
