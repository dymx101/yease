//
//  member_info.h
//  yydr
//
//  Created by liyi on 13-4-19.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "iViewController.h"
#import "chatDelegate.h"
#import <AudioToolbox/AudioToolbox.h>


@interface member_info : iViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,chatDelegate,FDStatusBarNotifierViewDelegate>
{
    UITableView *tb;
    NSDictionary *md;
    
    int mid,commentHeight;
    NSString *mobile;
    MBProgressHUD *HUD;
    ASIFormDataRequest *request;
    int UserId;
    
    id signature,intro;
    NSMutableArray *UserPhotoList;
    NSDictionary *MemberInfo;
    UIImageView *pre1,*pre2,*pre3;
    
    int AlbumPassword;

    BOOL isApp;
    
    
    BOOL isOpen;
    int orgHeight;
    
}
@property (nonatomic,strong) ASIFormDataRequest *request;
-(void)loadAblum:(int)uid;
-(void)loadInfo:(NSDictionary*)info Appointment:(BOOL)app;

@end
