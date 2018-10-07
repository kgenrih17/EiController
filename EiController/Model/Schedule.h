//
//  Schedule.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

@interface Schedule : NSObject

@property (nonatomic, readwrite, copy) NSString *fingerprint;
@property (nonatomic, readwrite, copy) NSString *details;
@property (nonatomic, readwrite, copy) NSString *md5;

@end
