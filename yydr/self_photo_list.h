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
#import "member_ablum.h"
#import "self_photo_preview.h"
#import "self_photo.h"
#import "iViewController.h"

@interface self_photo_list : iViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UploadDelegate,DeleteDelegate>
{    
    
    UITableView *tb;

    NSMutableArray *UserPhotoList;

    MBProgressHUD *HUD;
    
    int UserId,status,photo_row,SelfId;
    
}
@property (nonatomic,strong) ASIFormDataRequest *request;
@property (nonatomic,strong) NSMutableArray *UserPhotoList;
-(void)setUid:(int)uid;

@end
