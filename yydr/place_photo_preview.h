//
//  place_photo_preview.h
//  yydr
//
//  Created by liyi on 13-3-13.
//
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "iViewController.h"

@interface place_photo_preview : iViewController<MBProgressHUDDelegate,ASIProgressDelegate>
{
    ASIFormDataRequest *uploadRequest;
    MBProgressHUD *HUD;
    UIImage *img;
    int PlaceId;
    BOOL uploading;
}
-(void)loadImage:(UIImage*)im pid:(int)p;
@end
