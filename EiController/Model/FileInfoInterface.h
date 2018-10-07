//
//  FileInfoInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

@protocol FileInfoInterface <NSObject>

@property (nonatomic, readwrite) NSInteger fileSize;
@property (nonatomic, readwrite, strong) NSString *fingerprint;
@property (nonatomic, readwrite, strong) NSString *unique;
@property (nonatomic, readwrite, strong) NSString *fileUrl;
@property (nonatomic, readwrite, strong) NSString *localPath;

@end
