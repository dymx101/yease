//
//  place_comment_list.h
//  yydr
//
//  Created by 毅 李 on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "STableViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "global.h"

@interface place_comment_list : STableViewController<MBProgressHUDDelegate>
{
    int PageIndex;
    int PageCount;
    int pid;
    NSMutableArray *commentList;
    NSMutableArray *commentHightList;
    
    ASIFormDataRequest *request;
    MBProgressHUD *HUD;
    
    
    
}

@property (nonatomic,strong) MBProgressHUD *HUD;
@property(nonatomic,strong) ASIFormDataRequest *request;

- (void) addItemsOnBottom:(int)place_id;

@end
