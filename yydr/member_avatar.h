//
//  member_avatar.h
//  yydr
//
//  Created by liyi on 13-5-4.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"
#import "dbHelper.h"
#import "iViewController.h"
#import "MBProgressHUD.h"


@interface member_avatar : iViewController<UIScrollViewDelegate,MBProgressHUDDelegate>
{
    UIImage *orgImage;
    UIScrollView *sv;
    UIImageView *iv;
    
    ASIFormDataRequest *uploadRequest;
    MBProgressHUD *HUD;
    dbHelper *dh;

    BOOL uploading;
}

-(void)loadImage:(UIImage*)im;
@end
