//
//  NSObject+PropertyName.h
//  ASEnterprise
//
//  Created by Genrih Korenujenko on 28.09.17.
//  Copyright © 2017 Evogence. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Get property name for the class (C string or NSSting). */
#define keypathForClass(Klass, PropertyName) \
(((void)(NO && ((void)[Klass nullObjectForCheckingPropertyName].PropertyName, NO)), # PropertyName))
#define pNameForClass(Klass, PropertyName) \
@keypathForClass(Klass, PropertyName)

/* Get property name for the protocol (C string or NSSting). */
#define keypathForProtocol(Protocol, PropertyName) \
(((void)(NO && ((void)((NSObject<Protocol> *)[NSObject nullObjectForCheckingPropertyName]).PropertyName, NO)), # PropertyName))
#define pNameForProtocol(Protocol, PropertyName) \
@keypathForProtocol(Protocol, PropertyName)

@interface NSObject (PropertyName)

+(instancetype)nullObjectForCheckingPropertyName;
-(BOOL)isDictionary;
-(BOOL)isArray;
-(BOOL)isString;
-(BOOL)isNumber;

@end
