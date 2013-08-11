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

@interface member_avatar : iViewController<UIScrollViewDelegate>
{
    UIImage *orgImage;
    UIScrollView *sv;
    UIImageView *iv;
    
    ASIFormDataRequest *uploadRequest;
    
    dbHelper *dh;
}

-(void)loadImage:(UIImage*)im;
@end
