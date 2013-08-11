//
//  reg.h
//  yydr
//
//  Created by 毅 李 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

@interface reg : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UIActionSheetDelegate>
{
    UITextField *UserName;
    UITextField *Email;
    UITextField *Password;
    UITextField *ConfirmPassword;
    UITextField *Mobile;
    int sexNum;
    
    MBProgressHUD *HUD;
}

@end
