//
//  PublisherAPI.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "PublisherAPIInterface.h"

@interface PublisherAPI : NSObject <PublisherAPIInterface>
{
    RequestSender *requestSender;
    
    NSInteger code;
    NSString *message;
    BOOL isResendDownloadRequest;
}

@property (nonatomic, readwrite, strong) ConnectionData *connectionData;

+(instancetype)build:(ConnectionData*)connectionData;

@end
