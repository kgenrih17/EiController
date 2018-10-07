//
//  VPBiometricAuthenticationFacade.h
//  VPBiometricAuthenticationFacade
//
//  Created by Uladzimir Papko (visput).
//

#import <Foundation/Foundation.h>

static const NSInteger BIOMETRIC_AUTHORIZATION_CANCEL_CODE = -2;

@interface BiometricAuth : NSObject

-(BOOL)isAuthAvailable;
-(BOOL)isAuthOn;
-(BOOL)isAuthEnabledForPin:(NSString*)pin;
-(BOOL)isAuthEnabledForLogin:(NSString*)login andPassword:(NSString*)password;

-(NSString*)getAuthPin;
-(NSString*)getAuthLogin;
-(NSString*)getAuthPassword;

-(BOOL)isAuthByPin;
-(BOOL)isAuthByLogin;

-(void)enableAuthForPin:(NSString*)pin
            succesBlock:(void(^)(void))successBlock
           failureBlock:(void(^)(NSError *error))failureBlock;

-(void)disableAuthForPin:(NSString*)pin
             succesBlock:(void(^)(void))successBlock
            failureBlock:(void(^)(NSError *error))failureBlock;

-(void)enableAuthForLogin:(NSString*)login
              andPassword:(NSString*)password
              succesBlock:(void(^)(void))successBlock
             failureBlock:(void(^)(NSError *error))failureBlock;

-(void)disableAuthForLogin:(NSString*)login
               andPassword:(NSString*)password
               succesBlock:(void(^)(void))successBlock
              failureBlock:(void(^)(NSError *error))failureBlock;

-(void)authenticateSuccesBlock:(void(^)(void))successBlock
                 failureBlock:(void(^)(NSError *error))failureBlock;

@end
