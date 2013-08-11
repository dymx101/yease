//
//  change_password.h
//  yydr
//
//  Created by liyi on 12-12-13.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "global.h"
#import "iTableViewController.h"

@interface change_password : iTableViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    UITextField *OldPasswrod;
    UITextField *ConfirmPassword;
    UITextField *Password;
    MBProgressHUD *HUD;
}
@end
