//
//  TSyncObject.h
//  Viewer
//
//  Created by anatolij on 16.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSyncObject : NSObject 

@property (nonatomic) NSInteger isDeleted;
@property (nonatomic, strong) NSString *creatorId;
@property (nonatomic) NSInteger creationDate;
@property (nonatomic, strong) NSString *modifierId;
@property (nonatomic) NSInteger modificationDate;

@end
