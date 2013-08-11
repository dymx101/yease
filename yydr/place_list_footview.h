//
//  place_list_footview.h
//  yydr
//
//  Created by liyi on 13-1-7.
//
//

#import <UIKit/UIKit.h>
@interface place_list_footview : UIView
{
    UIActivityIndicatorView *activityIndicator;
    UILabel *title,*completed;

    UIButton *addBt;
    UIButton *loadBt;
    
    
}

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIButton *addBt;
@property (nonatomic,strong) UILabel *completed;

-(void)showLoading;
-(void)showLoadButton;
-(void)hideAll;
-(void)showCompleted;

@end
