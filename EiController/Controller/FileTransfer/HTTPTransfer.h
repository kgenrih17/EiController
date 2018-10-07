//
//  HTTPTransfer.h
//  EiController
//
//  Created by Genrih Korenujenko on 29.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "TransferInterface.h"

@interface HTTPTransfer : NSObject <TransferInterface, NSURLSessionTaskDelegate>
{
    NSString *boundary;
    NSMutableURLRequest *request;
    NSFileHandle *fileHandle;
    NSString *pathToBody;
    NSURLSessionTask *task;
    CGFloat lastPercent;
}
@end
