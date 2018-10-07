

#import <Foundation/Foundation.h>

@interface SelectableObject : NSObject

@property(nonatomic, strong)NSObject *object;
@property(nonatomic) BOOL isSelected;

-(id)initWithObject:(NSObject*)_object;
+(id)selectableObject:(NSObject*)_object;
@end
