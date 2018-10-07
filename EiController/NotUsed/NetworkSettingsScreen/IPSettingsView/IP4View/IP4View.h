//
//  IP4View.h
//  EiController
//
//  Created by Genrih Korenujenko on 28.03.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IP4View : UIView <UITextFieldDelegate>
{
    IBOutletCollection(UITextField) NSArray *allFields;
}

@property (nonatomic, readonly, strong) IBOutletCollection(UITextField) NSArray *addressesArray;
@property (nonatomic, readonly, strong) IBOutletCollection(UITextField) NSArray *netmasksArray;
@property (nonatomic, readonly, strong) IBOutletCollection(UITextField) NSArray *gatewaysArray;

+(instancetype)build:(NSArray<NSString*>*)address
             netmask:(NSArray<NSString*>*)netmask
             gateway:(NSArray<NSString*>*)gateway;
-(void)load:(NSArray<NSString*>*)address
    netmask:(NSArray<NSString*>*)netmask
    gateway:(NSArray<NSString*>*)gateway;

@end
