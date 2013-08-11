//
//  girl_chat.h
//  yydr
//
//  Created by liyi on 12-12-19.
//
//

#import <UIKit/UIKit.h>
#import "iViewController.h"

#import "HPGrowingTextView.h"

@interface appointment_chat : iViewController<chatDelegate,HPGrowingTextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *inputView;
    HPGrowingTextView *tv;
    UITableView *tb;
    NSMutableArray *messageArray;
    
    int did,mid;
    NSString *rname,*ravatar;
    
    NSString *dbPath;
}

-(void)setRev:(int)revId revName:(NSString*)revName revAvatar:(NSString*)revAvatar;

@property (nonatomic,strong) NSMutableArray *messageArray;
@end
