#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)

-(BOOL)containsKey:(NSString*)key;
-(BOOL)containsKeys:(NSArray<NSString*>*)_keys;

-(NSString*)stringForKey:(NSString*)_key;
-(NSArray*)arrayForKey:(NSString*)_key;
-(NSDictionary*)dictionaryForKey:(NSString*)_key;
-(NSNumber*)numberForKey:(NSString*)_key;
-(NSInteger)integerForKey:(NSString*)_key;
-(double)doubleForKey:(NSString*)_key;
-(BOOL)boolForKey:(NSString*)_key;

-(NSString*)dataAsBase64StringForKey:(NSString*)_key;
-(NSString*)json;

-(BOOL)isEmpty;

@end
