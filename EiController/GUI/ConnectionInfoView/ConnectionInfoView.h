//
//  ConnectionInfoView.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionInfoView : UIView

+(instancetype)connectionInfo;
-(void)setAddress:(NSString*)address icon:(UIImage*)icon;

@end
