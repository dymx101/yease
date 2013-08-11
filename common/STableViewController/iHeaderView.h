//
//  iTableHeaderView.h
//  Demo
//
//  Created by Li yi on 13-6-17.
//
//

#import <UIKit/UIKit.h>

@interface iHeaderView : UIView
{
    UILabel *infoLabel;
    UIActivityIndicatorView *activityIndicator;
    UIImageView *arrow;
}
@property (nonatomic,strong) UILabel *infoLabel;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) UIImageView *arrow;
@end
