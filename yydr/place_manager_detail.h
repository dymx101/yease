//
//  place_manager_detail.h
//  yydr
//
//  Created by liyi on 13-4-2.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "iViewController.h"

@interface place_manager_detail : iViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UIActionSheetDelegate>
{
    UITableView *tb;
    NSDictionary *md;
    
    int mid,commentHeight;
    NSString *mobile;
    MBProgressHUD *HUD;
    
    NSString *uname;
    int User_id;
    
}
-(void)loadDetail:(NSDictionary*)d;
@end
