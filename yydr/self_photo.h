//
//  self_photo.h
//  yydr
//
//  Created by Li yi on 13-5-25.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "iViewController.h"

@protocol DeleteDelegate;

@interface self_photo : iViewController<UIAlertViewDelegate,MBProgressHUDDelegate,UIActionSheetDelegate>
{
    int UserId,pid;
    MBProgressHUD *HUD;
    ASIFormDataRequest *deleteRequest;
    BOOL deleting;
    
    id<DeleteDelegate> deleteDelegate;
}
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) id<DeleteDelegate> deleteDelegate;
-(void)loadUserPhoto:(NSDictionary*)up;
@end


@protocol DeleteDelegate <NSObject>

@optional
-(void)DeleteFinished;

@end
