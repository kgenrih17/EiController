//
//  AboutView.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutView : UIView

+(instancetype)aboutEvogenceWithVersion:(NSString*)version;
+(instancetype)aboutWithCompany:(NSString*)company url:(NSString*)url version:(NSString*)version;

@end
