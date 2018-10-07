//
//  NSData+CRC32.h
//  NufernOpticalFibers
//
//  Created by Anatolij on 1/21/13.
//  Copyright (c) 2013 Anatolij. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CRC32)
- (uint32_t)CRC32Value;
@end
