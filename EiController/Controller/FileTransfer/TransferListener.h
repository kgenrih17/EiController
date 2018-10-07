//
//  TransferListener.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "TransferResult.h"

@protocol TransferListener <NSObject>

@optional
-(void)startOfTransmission;
-(void)transferProgress:(CGFloat)progress;

@end
