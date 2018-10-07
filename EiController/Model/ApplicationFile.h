//
//  ApplicationFile.h
//  EiController
//
//  Created by Genrih Korenujenko on 23.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "FileInfoInterface.h"

@interface ApplicationFile : NSObject <FileInfoInterface>

@property (nonatomic, readwrite, strong) NSString *fileName;

@end
