//
//  member.h
//  yydr
//
//  Created by 毅 李 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "global.h"
#import <CoreLocation/CoreLocation.h>

@interface login : UITableViewController<CLLocationManagerDelegate,UIAlertViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
   
    UITextField *UserName;
    UITextField *Password;
    MBProgressHUD *HUD;
    
    CLLocationManager *locManager;
    
}

@end
