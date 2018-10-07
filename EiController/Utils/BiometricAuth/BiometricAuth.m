//
//  VPBiometricAuthenticationFacade.m
//  VPBiometricAuthenticationFacade
//
//  Created by Uladzimir Papko (visput).
//

#import "BiometricAuth.h"
#import <CoreFoundation/CoreFoundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <sys/sysctl.h>

static NSString * const kVPFeaturesDictionaryKey = @"VPFeaturesDictionaryKey";
static NSString * const kVPAuthEnableKey         = @"authentication_enable_key";
static NSString * const kVPPinKey                = @"authentication_pin_key";
static NSString * const kVPLoginKey              = @"authentication_login_key";
static NSString * const kVPPasswordKey           = @"authentication_password_key";

@interface BiometricAuth ()

@property (nonatomic, strong) LAContext *authenticationContext;

@end

@implementation BiometricAuth

#pragma mark - Init
-(instancetype)init
{
    self = [super init];

    if (self)
        self.authenticationContext = [LAContext new];
    
    return self;
}

#pragma mark - Public Methods
-(BOOL)isAuthAvailable
{
    return [self.authenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL];
}

-(BOOL)isAuthOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kVPAuthEnableKey];
}

-(BOOL)isAuthEnabledForPin:(NSString*)pin
{
    return ([self isAuthAvailable] && [self isAuthenticationEnabledByValue:pin]);
}

-(BOOL)isAuthEnabledForLogin:(NSString*)login andPassword:(NSString*)password
{
    return ([self isAuthAvailable] && [self isAuthenticationEnabledByValue:@{kVPLoginKey : login, kVPPasswordKey : password}]);
}

-(NSString*)getAuthPin
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kVPPinKey];
}

-(NSString*)getAuthLogin
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kVPLoginKey];
}

-(NSString*)getAuthPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kVPPasswordKey];
}

-(BOOL)isAuthByPin
{
    return ([[NSUserDefaults standardUserDefaults] objectForKey:kVPPinKey] != nil);
}

-(BOOL)isAuthByLogin
{
    return ([[NSUserDefaults standardUserDefaults] objectForKey:kVPLoginKey] != nil);
}

-(void)enableAuthForPin:(NSString*)pin
            succesBlock:(void(^__strong)(void))successBlock
           failureBlock:(void(^)(NSError *error))failureBlock;
{
    if (![self isAuthenticationEnabledByValue:pin])
        [self saveAuthenticationEnabled:YES value:pin forKey:kVPPinKey];
    
    BLOCK_SAFE_RUN(successBlock);
}

-(void)disableAuthForPin:(NSString*)pin
             succesBlock:(void(^__strong)(void))successBlock
            failureBlock:(void(^)(NSError *error))failureBlock;
{
    [self passByBiometricsWithReason:@"Authentication" succesBlock:^
    {
        [self saveAuthenticationEnabled:NO value:pin forKey:kVPPinKey];
        BLOCK_SAFE_RUN(successBlock);
    } failureBlock:failureBlock];
}

-(void)enableAuthForLogin:(NSString*)login
              andPassword:(NSString*)password
              succesBlock:(void(^__strong)(void))successBlock
             failureBlock:(void(^)(NSError *error))failureBlock
{
    NSDictionary *value = @{kVPLoginKey : login, kVPPasswordKey : password};
    
    if (![self isAuthenticationEnabledByValue:value])
        [self saveAuthenticationEnabled:YES value:value forKey:kVPLoginKey];
    
    BLOCK_SAFE_RUN(successBlock);
}

-(void)disableAuthForLogin:(NSString*)login
               andPassword:(NSString*)password
               succesBlock:(void(^__strong)(void))successBlock
              failureBlock:(void(^)(NSError *error))failureBlock
{
    [self passByBiometricsWithReason:@"Authentication" succesBlock:^
    {
        NSDictionary *value = @{kVPLoginKey : login, kVPPasswordKey : password};
        [self saveAuthenticationEnabled:NO value:value forKey:kVPLoginKey];
        BLOCK_SAFE_RUN(successBlock);
    } failureBlock:failureBlock];
}


-(void)authenticateSuccesBlock:(void(^__strong)(void))successBlock
                     failureBlock:(void(^)(NSError *error))failureBlock
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if ([self isAuthAvailable])
        {
            [self passByBiometricsWithReason:@"Authentication"
                                 succesBlock:successBlock
                                failureBlock:failureBlock];
        }
        else
            BLOCK_SAFE_RUN(failureBlock, self.authenticationUnavailabilityError);
    });
}

#pragma mark - Biometric Methods
-(void)passByBiometricsWithReason:(NSString *)reason
                      succesBlock:(void(^__strong)(void))successBlock
                     failureBlock:(void(^)(NSError *error))failureBlock
{
    [self.authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reason reply:^(BOOL success, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            if (success)
                BLOCK_SAFE_RUN(successBlock);
            else
                BLOCK_SAFE_RUN(failureBlock, error);
        });
    }];
}

#pragma mark - Private Methods
-(void)saveAuthenticationEnabled:(BOOL)isEnabled value:(id)value forKey:(NSString*)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *featuresDictionary = [NSMutableDictionary new];
    [featuresDictionary addEntriesFromDictionary:[userDefaults valueForKey:kVPFeaturesDictionaryKey]];
    [featuresDictionary setValue:@(isEnabled) forKey:value];

    [userDefaults setValue:featuresDictionary forKey:kVPFeaturesDictionaryKey];
    [userDefaults setValue:value forKey:key];
    [userDefaults setObject:@(isEnabled) forKey:kVPAuthEnableKey];
}

-(BOOL)isAuthenticationEnabledByValue:(id)value
{
    NSDictionary *featuresDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:kVPFeaturesDictionaryKey];
    return [[featuresDictionary valueForKey:value] boolValue];
}

#pragma mark Error
-(NSError*)authenticationUnavailabilityError
{
    return [NSError errorWithDomain:@"VPBiometricsAuthenticationDomain"
                               code:1000
                           userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Authentication by Biometrics isn't available", nil)}];
}

@end
