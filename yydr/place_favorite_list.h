//
//  place_favorite_list.h
//  yydr
//
//  Created by liyi on 13-4-6.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "place_list_footview.h"

@interface place_favorite_list : UIViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *FavoriteList;
    int PageIndex;
    int PageCount;
    
    NSIndexPath *deletRow;
    
    MBProgressHUD *HUD;
    
    ASIFormDataRequest *request,*deleteRequest;
    
    UITableView *tb;
    place_list_footview *fv;
    
    UIBarButtonItem *rbt;
    
    BOOL canLoadMore;
}

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NSMutableArray *FavoriteList;
@property (nonatomic,strong) ASIFormDataRequest *request;

- (void) addItemsOnBottom;

@end
