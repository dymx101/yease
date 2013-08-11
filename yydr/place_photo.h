//
//  place_photo.h
//  yydr
//
//  Created by liyi on 13-1-9.
//
//

#import <UIKit/UIKit.h>
#import "iPageView.h"
#import "MBProgressHUD.h"

@interface place_photo : iPageView<MBProgressHUDDelegate>
{
    UIImageView *photo;
    MBProgressHUD *HUD;
}
@property (nonatomic,strong) UIImageView *photo;
@property (nonatomic,strong) MBProgressHUD *HUD;
-(void)loadPhoto:(NSURL*)url;
@end
