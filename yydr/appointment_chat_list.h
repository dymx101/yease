//
//  apointment_chat_list.h
//  yydr
//
//  Created by liyi on 13-5-13.
//
//

#import <UIKit/UIKit.h>
#import "iViewController.h"

@interface appointment_chat_list :iViewController <UITableViewDataSource,UITableViewDelegate,chatDelegate>
{
    UITableView *tb;
    NSMutableArray *dialogArray;
    int mid;
    NSString *dbPath;
}

-(void)updateNewMessageCount;

@end
