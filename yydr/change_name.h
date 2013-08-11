//
//  change_name.h
//  yydr
//
//  Created by liyi on 12-12-13.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "global.h"

@interface change_name : UITableViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    UITextField *UserName;
    MBProgressHUD *HUD;
}
@end
