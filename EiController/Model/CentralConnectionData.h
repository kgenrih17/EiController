//
//  CentralConnectionData.h
//  EiController
//
//  Created by Genrih Korenujenko on 12.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ConnectionData.h"

@interface CentralConnectionData : ConnectionData

@property (nonatomic, readonly, copy) NSString *companyUniq;
@property (nonatomic, readonly, copy) NSString *token;

-(void)save;
+(instancetype)get;

@end
