//
//  member.h
//  yydr
//
//  Created by 毅 李 on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "dbHelper.h"
#import "iTableViewController.h"

@interface member : iTableViewController<UIAlertViewDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *HUD;
    NSDictionary *userinfo;
    UIImageView *avatar;
    int UserId,RoleId;
    dbHelper *dh;
}
@end
