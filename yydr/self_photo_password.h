//
//  self_photo_password.h
//  yydr
//
//  Created by liyi on 13-5-25.
//
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "dbHelper.h"
#import "iTableViewController.h"

@interface self_photo_password : iTableViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    int rowCount,password;
    ASIFormDataRequest *request;
    MBProgressHUD *HUD;
    UITextField *psTextField;
    dbHelper *dh;
    UISwitch *switchview;
    
}
@property (nonatomic,strong) ASIFormDataRequest *request;

@end
