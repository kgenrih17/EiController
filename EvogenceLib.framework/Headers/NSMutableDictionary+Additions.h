
#import <Foundation/Foundation.h>
#import "TBXML.h"
@interface NSMutableDictionary (Additions)

-(void)setStringObjWithName:(NSString*)_name fromNode:(TBXMLElement*)_parentElement;
-(void)setIntObjWithName:(NSString*)_name fromNode:(TBXMLElement*)_parentElement;
-(void)setFloatObjWithName:(NSString*)_name fromNode:(TBXMLElement*)_parentElement;
-(void)setDataObjWithName:(NSString*)_name fromNode:(TBXMLElement*)_parentElement;

@end
