//
//  place_detail.h
//  yydr
//
//  Created by liyi on 13-1-6.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

#import "ASIFormDataRequest.h"
#import "place_comment_list_footview.h"
#import "iViewController.h"

@interface place_detail : iViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ASIProgressDelegate,MBProgressHUDDelegate>
{
    UITableView *tb;
    MBProgressHUD *HUD;
    UIToolbar *toolBar;
    
    //场馆详细信息
    NSDictionary *pd;
    
    int PlaceId;
    int PageIndex;
    int PageCount;
    
    //评论数组
    NSMutableArray *commentList;
    NSMutableArray *commentHightList;
    
    //评论总数
    int comment_count;
    int star_count;

    //经理总数
    int manager_count;
    
    //相册高度
    int photoHeight;
    
    //照片文件名
    NSString *FileName;
    
    //脚标
    place_comment_list_footview *fv;
    
    BOOL canLoadMore;
    
    ASIHTTPRequest *placeCommentRequest;
    
}

- (void)load:(NSDictionary*)dic;
@end
