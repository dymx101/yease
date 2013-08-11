//
//  city_list.h
//  yydr
//
//  Created by liyi on 13-4-15.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "global.h"
#import "UIView+GetRequestCookie.h"
#import "MBProgressHUD.h"

@protocol CitySelectedDelegate;

@interface city_list : UITableViewController<MBProgressHUDDelegate>
{
    id<CitySelectedDelegate> delegate;
    
    MBProgressHUD *HUD;
    NSMutableDictionary *cityList;
}
@property (nonatomic,strong) id<CitySelectedDelegate> delegate;

@end


@protocol CitySelectedDelegate <NSObject>

@optional
-(void)onCitySelected;

@end