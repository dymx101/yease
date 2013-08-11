//
//  setting.h
//  yydr
//
//  Created by 毅 李 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "iTableViewController.h"

@interface setting : iTableViewController<MBProgressHUDDelegate>
{
     MBProgressHUD *HUD;
}
@end
