//
//  IP6View.h
//  EiController
//
//  Created by Genrih Korenujenko on 28.03.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IP6View : UIView <UITextFieldDelegate>

@property (nonatomic, readonly, strong) IBOutlet UITextField *addressTextField;
@property (nonatomic, readonly, strong) IBOutlet UITextField *prefixLengthTextField;
@property (nonatomic, readonly, strong) IBOutlet UITextField *gatewayTextField;

+(instancetype)build:(NSString*)address
        prefixLength:(NSString*)prefixLength
             gateway:(NSString*)gateway;
-(void)load:(NSString*)address
prefixLength:(NSString*)prefixLength
    gateway:(NSString*)gateway;
-(BOOL)isFilled;

@end
