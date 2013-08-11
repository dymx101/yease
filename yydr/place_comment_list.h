//
//  place_comment_list0.h
//  yydr
//
//  Created by liyi on 13-2-20.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "global.h"
#import "place_comment_list_footview.h"

@interface place_comment_list : UIViewController<MBProgressHUDDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    int PageIndex;
    int PageCount;
    int PlaceId;
    NSMutableArray *commentList;
    NSMutableArray *commentHightList;
    
    ASIFormDataRequest *request;
    MBProgressHUD *HUD;
    
    BOOL canLoadMore;
    
    UITableView *tb;
    place_comment_list_footview *fv;
    
}

@property (nonatomic,strong) MBProgressHUD *HUD;
@property(nonatomic,strong) ASIFormDataRequest *request;

- (void) setPlaceId:(int)pid;

@end