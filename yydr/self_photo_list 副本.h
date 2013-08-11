//
//  member_photo_list.h
//  yydr
//
//  Created by liyi on 13-4-21.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import <UIImageView+WebCache.h>
#import "self_ablum.h"
#import "self_photo_preview.h"

@interface self_photo_list : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UploadDelegate>
{    
    
    UITableView *tb;

    NSMutableArray *UserPhotoList;

    MBProgressHUD *HUD;
    ASIFormDataRequest *request,*deleteRequest;
    
    UIBarButtonItem *rbt;
    int UserId;
    
    int status,photo_row;
    
}
@property (nonatomic,strong) ASIFormDataRequest *request;
@property (nonatomic,strong) NSMutableArray *UserPhotoList;
-(void)loadAblum;

@end
