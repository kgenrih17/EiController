//
//  AppDelegate.m
//  EiController
//
//  Created by admin on 2/12/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import "AppDelegate.h"
#import "AppInteractor.h"
#import "CentralConnectionData.h"
#import "Navigation.h"
#import "UserDefaultsKeys.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()
{
    Navigation *navigation;
    AppInteractor *appInteractor;
}
@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    NSLog(@"PATH TO DOCUMENTS: %@", [AppInfromation getPathToDocuments]);
    
    NSString *transferHttpBodyPath = [[AppInfromation getPathToDocuments] stringByAppendingPathComponent:TRANSFER_HTTP_BODY_FILE_NAME];
    if ([[NSFileManager defaultManager] fileExistsAtPath:transferHttpBodyPath])
        [[NSFileManager defaultManager] removeItemAtPath:transferHttpBodyPath error:nil];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:CENTRAL_SYNC_STATUS_KEY] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:SECONDS_IN_DAY forKey:CENTRAL_SYNC_TIMEOUT_KEY];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CENTRAL_AUTO_SYNC_KEY];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CENTRAL_SYNC_STATUS_KEY];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    appInteractor = [AppInteractor new];registrate:
    navigation = [[Navigation alloc] initWithInteractor:appInteractor];
    appInteractor.navigation = navigation;
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    
    [[Logger currentLog] setLogFormat:CSV_FORMAT];
    [[Logger currentLog] setLogLevel:DEBUG_L];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        [appInteractor start];
    });
    
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL isCanOpenApp = NO;
#warning TODO hvk: find out what data will come when opening the application by URL
/**
 Expected:
    - In URL address:
        - host;
        - token.
    - In query items:
        - scheme;
        - port;
        - company_id.
 **/
    if (url.absoluteString != nil && !url.absoluteString.isEmpty &&
        [url.absoluteString containsString:@"host"] && [url.absoluteString containsString:@"token"])
    {
        __block NSString *companyId = nil;
        NSURLComponents *components = [NSURLComponents componentsWithString:url.absoluteString];
        [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *queryItem, NSUInteger index, BOOL *stop)
        {
            if ([queryItem.name isEqualToString:@"scheme"])
                components.scheme = queryItem.value;
            else if ([queryItem.name isEqualToString:@"port"])
                components.port = @(queryItem.value.integerValue);
            else if ([queryItem.name isEqualToString:@"company_id"])
                companyId = queryItem.value;
        }];
        
        CentralConnectionData *connectionData = [self createCentralConnectionData:components
                                                                        companyId:companyId];
        if (connectionData != nil)
            [navigation showAuthScreen];
    }
    
    return isCanOpenApp;
}

-(CentralConnectionData*)createCentralConnectionData:(NSURLComponents*)components companyId:(NSString*)companyId
{
    CentralConnectionData *centralConnectionData = [CentralConnectionData createWithScheme:components.scheme
                                                                                      host:components.host
                                                                                      port:components.port.integerValue];
    
    if (![centralConnectionData isValid])
        centralConnectionData = nil;

    return centralConnectionData;
}

@end
