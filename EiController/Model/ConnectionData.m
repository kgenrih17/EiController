//
//  ConnectionData.m
//  EiController
//
//  Created by Genrih Korenujenko on 12.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ConnectionData.h"

@implementation ConnectionData

#pragma mark - Public Init Methods
+(instancetype)createWithSSL:(BOOL)isSSL host:(NSString*)host port:(NSInteger)port
{
    NSMutableString *address = [NSMutableString new];
    
    if ([host rangeOfString:SCHEME_ADDITIONAL].location == NSNotFound)
        [address appendFormat:@"%@%@%@", isSSL ? HTTPS_KEY : HTTP_KEY, SCHEME_ADDITIONAL, host];
    else
        [address appendString:host];
    
    return [self createWithAddress:address port:port];
}

+(instancetype)createWithScheme:(NSString*)scheme host:(NSString*)host port:(NSInteger)port
{
    return [self createWithScheme:scheme host:host port:port path:nil];
}

+(instancetype)createWithScheme:(NSString*)scheme host:(NSString*)host port:(NSInteger)port path:(NSString*)path
{
    NSURLComponents *urlComponents = [NSURLComponents new];
    urlComponents.scheme = (scheme == nil || scheme.isEmpty) ? HTTP_KEY : scheme;
    urlComponents.host = host;
    urlComponents.port = (port > 0) ? @(port) : nil;
    if (path != nil)
    {
        urlComponents.path = path;
        urlComponents.query = @"";
    }
    return [self createWithComponents:urlComponents];
}

+(instancetype)createWithAddress:(NSString*)address port:(NSInteger)port
{
    if (address == nil || address.isEmpty || [address stringByReplacingOccurrencesOfString:@" " withString:@""].isEmpty)
        return nil;
    
    NSURLComponents *components = [NSURLComponents new];
    NSString *urlString = address.copy;
    NSRange schemeRange = [urlString rangeOfString:SCHEME_ADDITIONAL];
    
    if (schemeRange.location != NSNotFound)
    {
        components.scheme = [urlString substringToIndex:schemeRange.location];
        urlString = [urlString substringFromIndex:schemeRange.location + schemeRange.length];
    }
    else
        components.scheme = [self getDefaultScheme];
    
    NSRange colonRange = [urlString rangeOfString:@":"];
    
    if (colonRange.location != NSNotFound)
    {
        NSString *tempPort = [urlString substringFromIndex:colonRange.location + colonRange.length];
        NSCharacterSet *characterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSArray *characters = [tempPort componentsSeparatedByCharactersInSet:characterSet];
        tempPort = [characters componentsJoinedByString:@""];
        
        if (tempPort != nil && !tempPort.isEmpty)
        {
            components.port = @(tempPort.integerValue);
            urlString = [urlString substringToIndex:colonRange.location];
        }
    }
    else if (port > 0)
        components.port = @(port);
    
    components.host = urlString;
    
    return [self createWithComponents:components];
}

+(instancetype)createWithURL:(NSURL*)url
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    return [self createWithComponents:urlComponents];
}

+(instancetype)createWithComponents:(NSURLComponents*)components
{
    ConnectionData *item = [self new];
    item.components = components;
    return item;
}

#pragma mark - Override Property Methods
-(NSURLComponents*)components
{
    if (_components.port.integerValue == 0)
    {
        if ([_components.scheme isEqualToString:HTTP_KEY])
            _components.port = @(80);
        else if ([_components.scheme isEqualToString:HTTPS_KEY])
            _components.port = @(443);
    }
    
    return _components;
}

-(NSURL*)url
{
    return self.components.URL;
}

-(NSString*)urlString
{
    return self.url.absoluteString;
}

-(NSString*)scheme
{
    return self.components.scheme;
}

-(NSString*)host
{
    return self.components.host;
}

-(NSInteger)port
{
    return self.components.port.integerValue;
}

-(BOOL)isSupportSSL
{
    return [self.components.scheme isEqualToString:HTTPS_KEY];
}

#pragma mark - Override Methods
-(BOOL)isEqual:(id)object
{
    if (![[object class] isSubclassOfClass:[self class]])
        return NO;
    
    ConnectionData *temp = (ConnectionData*)object;
    
    if (![self.scheme isEqualToString:temp.scheme])
        return NO;
    
    if (![self.host isEqualToString:temp.host])
        return NO;
    
    if (self.port != temp.port)
        return NO;
    
    return YES;
}

#pragma mark - Public Methods
-(BOOL)isValid
{
    return (self.host != nil && !self.host.isEmpty);
}

+(NSString*)getDefaultScheme
{
    return HTTP_KEY;
}

@end
