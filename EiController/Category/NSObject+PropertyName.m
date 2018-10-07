//
//  NSObject+PropertyName.m
//  ASEnterprise
//
//  Created by Genrih Korenujenko on 28.09.17.
//  Copyright © 2017 Evogence. All rights reserved.
//

#import "NSObject+PropertyName.h"

@implementation NSObject (PropertyName)

+(instancetype)nullObjectForCheckingPropertyName { return nil; }
-(BOOL)isDictionary { return [[self class] isSubclassOfClass:[NSDictionary class]]; }
-(BOOL)isArray { return [[self class] isSubclassOfClass:[NSArray class]]; }
-(BOOL)isString { return [[self class] isSubclassOfClass:[NSString class]]; }
-(BOOL)isNumber { return [[self class] isSubclassOfClass:[NSNumber class]]; }

@end
