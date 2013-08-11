
//
//  HPViewController.h
//  yydr
//
//  Created by 毅 李 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "global.h"
#import "chatDelegate.h"
#import "AppDelegate.h"

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"



#import <AudioToolbox/AudioToolbox.h>

@interface homepage : UITableViewController<UITableViewDataSource,UITableViewDelegate,chatDelegate>
{
    AppDelegate *ad;
    UILabel *num;
    UIImageView *qNum;
}

@end
