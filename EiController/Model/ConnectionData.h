//
//  ConnectionData.h
//  EiController
//
//  Created by Genrih Korenujenko on 12.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const HTTP_KEY = @"http";
static NSString * const HTTPS_KEY = @"https";
static NSString * const SCHEME_ADDITIONAL = @"://";

@interface ConnectionData : NSObject

@property (nonatomic, readwrite, strong) NSURLComponents *components;
@property (nonatomic, readonly, copy) NSURL *url;
@property (nonatomic, readonly, copy) NSString *urlString;
@property (nonatomic, readonly, copy) NSString *scheme;
@property (nonatomic, readonly, copy) NSString *host;
@property (nonatomic, readonly) NSInteger port;
@property (nonatomic, readonly) BOOL isSupportSSL;

+(instancetype)createWithSSL:(BOOL)isSSL host:(NSString*)host port:(NSInteger)port;
+(instancetype)createWithScheme:(NSString*)scheme host:(NSString*)host port:(NSInteger)port;
+(instancetype)createWithScheme:(NSString*)scheme host:(NSString*)host port:(NSInteger)port path:(NSString*)path;
+(instancetype)createWithAddress:(NSString*)address port:(NSInteger)port;
+(instancetype)createWithURL:(NSURL*)url;
+(instancetype)createWithComponents:(NSURLComponents*)components;

-(BOOL)isValid;

@end
