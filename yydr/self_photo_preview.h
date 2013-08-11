//
//  member_photo_preview.h
//  yydr
//
//  Created by liyi on 13-4-21.
//
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

#import "iViewController.h"

@protocol UploadDelegate;


@interface self_photo_preview : iViewController<MBProgressHUDDelegate,ASIProgressDelegate>
{
    id<UploadDelegate> uploadDelegate;
    
    ASIFormDataRequest *uploadRequest;
    MBProgressHUD *HUD;
    UIImage *img;
    BOOL uploading;
}
@property (nonatomic,strong) id<UploadDelegate> uploadDelegate;
-(void)loadImage:(UIImage*)im;
@end


@protocol UploadDelegate <NSObject>

@optional
-(void)UploadFinished;

@end
