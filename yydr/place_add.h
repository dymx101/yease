//
//  place_add.h
//  yydr
//
//  Created by liyi on 13-2-13.
//
//

#import <UIKit/UIKit.h>
#import "place_area_list.h"
#import "place_category_list.h"
#import "MBProgressHUD.h"
#import "UIPlaceHolderTextView.h"
#import "iTableViewController.h"

@interface place_add : iTableViewController<UITextFieldDelegate,UIActionSheetDelegate,AreaDelegate,CategoryDelegate,MBProgressHUDDelegate>
{
    UITextField *name,*address,*price,*contact;
    UILabel *category,*area,*loc;
    int category_id,area_id,currentAreaSelectRow,currentCategorySelectRow;
    MBProgressHUD *HUD;
    double lat,lng;
}


@end
