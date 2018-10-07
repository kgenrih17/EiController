//
//  ActionListener.h
//  EiController
//
//  Created by Genrih Korenujenko on 28.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ActionResult.h"
#import "EActionType.h"

@protocol ActionListener <NSObject>

@required
-(void)actionReport:(CGFloat)progress error:(NSString*)error description:(NSString*)desc;

@end
