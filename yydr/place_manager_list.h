//
//  place_manager_list.h
//  yydr
//
//  Created by liyi on 13-4-4.
//
//

#import <UIKit/UIKit.h>
#import "place_list_footview.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "iViewController.h"

@interface place_manager_list : iViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *ManagerList;
    int PageIndex;
    int PageCount;
    int Place_id;
    int mid;
    int tel;
    
    NSString *mobile;
    
    BOOL canLoadMore;
    
    UITableView *tb;
    place_list_footview *fv;
    
    MBProgressHUD *HUD;
    
    ASIFormDataRequest *ManageRequest;
    
}

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NSMutableArray *ManagerList;
@property (nonatomic,strong) ASIFormDataRequest *ManageRequest;

-(void)FirstLoad:(int)pid Tel:(int)t;
-(void) addItemsOnBottom:(int)place_id
              page_index:(int)page_index;

@end
