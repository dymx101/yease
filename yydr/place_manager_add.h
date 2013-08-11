//
//  place_tel_add.h
//  yydr
//
//  Created by liyi on 13-2-16.
//
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
#import "MBProgressHUD.h"
@interface place_manager_add : UITableViewController<MBProgressHUDDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITextField *off,*tel,*qq;
    UIPlaceHolderTextView *body;
    MBProgressHUD *HUD;
    int PlaceId;
}
-(void)setPlaceId:(int)pid;
@end
