//
//  appointment_test.h
//  yydr
//
//  Created by Li yi on 13-6-20.
//
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "global.h"
#import "dbHelper.h"
#import "UIView+GetRequestCookie.h"
#import "UIImageView+WebCache.h"

#import "appointment_member_list_cell.h"



@interface appointment_member_list : STableViewController<CLLocationManagerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *UserList;
    

    int PageIndex;
    int PageCount;
    int SexNum;
    
    ASIHTTPRequest *userRequet;
    
    double glat,glng;
    
    CLLocationManager *locManager;
    
    BOOL locNow;
}
-(void)loadUserList:(int)pi Tag:(int)t;
@end
