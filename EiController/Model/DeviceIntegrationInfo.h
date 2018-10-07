//
//  DeviceIntegrationInfo.h
//  EiController
//
//  Created by Genrih Korenujenko on 30.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceIntegrationInfo : NSObject

@property (nonatomic, readwrite, copy) NSString *host;
@property (nonatomic, readwrite, copy) NSString *registrationToken;
@property (nonatomic, readwrite) NSInteger httpPort;
@property (nonatomic, readwrite) NSInteger sshPort;
@property (nonatomic, readwrite) NSInteger esTaskCompletionTimeout;
@property (nonatomic, readwrite) NSInteger ftpPort;
@property (nonatomic, readwrite) BOOL isOn;
@property (nonatomic, readwrite) BOOL isUseUpdate;
@property (nonatomic, readwrite) BOOL isUseSFTP;
// for set echo
@property (nonatomic, readwrite, copy) NSString *secondaryHost;
@property (nonatomic, readwrite) NSInteger secondaryHTTPPort;
@property (nonatomic, readwrite) NSInteger secondarySSHPort;
@property (nonatomic, readwrite) NSInteger secondaryFTPPort;


+(instancetype)create:(NSDictionary*)_dict;

@end
