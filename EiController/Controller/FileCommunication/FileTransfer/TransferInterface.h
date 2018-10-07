//
//  TransferInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

@protocol TransferInterface <NSObject>

@required
+(instancetype)build:(id<NSObject>)lisenger;
-(void)setSettingsInfo:(id)settingsInfo;
-(void)upload;
-(void)download;

@end
