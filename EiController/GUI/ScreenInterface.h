//
//  ScreenInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

@protocol ScreenInterface <NSObject, UITextFieldDelegate>

@required
-(void)showAlertWithTitle:(NSString*)title
                  message:(NSString*)message;
-(void)showAlert:(NSString*)title
         message:(NSString*)message
      acceptText:(NSString*)acceptText
     declineText:(NSString*)declinetext
      completion:(void (^)(BOOL isAccepted))completion;
-(void)showProgressWithMessage:(NSString*)message;
-(void)showProcessing;
-(void)hideProgress;

@end
