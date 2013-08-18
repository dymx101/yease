//
//  place_test.h
//  yydr
//
//  Created by Li yi on 13-6-19.
//
//

#import <UIKit/UIKit.h>
#import "global.h"
#import "STableViewController.h"
#import "iHeaderView.h"
#import "iFooterView.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"

#import "place_list_cell.h"
#import "place_list_cell0.h"

#import "place_area_list.h"

#import <CoreLocation/CoreLocation.h>

@interface place_list : STableViewController<CLLocationManagerDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,AreaDelegate,UITableViewDataSource,UITableViewDelegate,AdvDelegate>
{

    
    NSMutableArray *PlaceList;
    NSMutableArray *PlaceAdvList;
    
    int PageIndex;
    int PageCount;
    
    
    int area_id;
    int city_id;
    int curAreaRow,curCategoryRow;
    int category_id;
    int order_by;

    
    MBProgressHUD *HUD;
    ASIFormDataRequest *PlaceRequest;

    UILabel *areaLabel;
    UILabel *orderLabel;
    UILabel *categoryLabel;
    
    
    
    double glat,glng;
    
    
    CLLocationManager *locManager;
    BOOL locNow;
    
}
-(void)reload;
-(void)reloadWithInit;
-(void)StartLoc;
-(void)loadPlaceList:(int)cid
             area_id:(int)aid
             city_id:(int)cityid
          page_index:(int)pid
            order_by:(int)ob
                glat:(double)lat
                glng:(double)lng
                 tag:(int)t;

@end
