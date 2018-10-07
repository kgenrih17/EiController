#import <Foundation/Foundation.h>

@interface NSData (Additions)

-(NSData*)AES256EncryptWithKey:(NSString*)key;
-(NSData*)AES256DecryptWithKey:(NSString*)key;

-(NSString*)md5;
-(id)json;

@end
