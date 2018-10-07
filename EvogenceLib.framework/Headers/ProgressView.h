//
//  ProgressView.h
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
{
    UILabel *progressText;
    UIView *progressBackView;
    UIView *activityView;
    UIActivityIndicatorView *activityIndicator;

    UIView *parentView;

    BOOL isShowed;
}

-(instancetype)initWithParentView:(UIView*)view;

-(void)showWithTitle:(NSString*)_title;
-(void)hide;
-(BOOL)isShowed;

@end
