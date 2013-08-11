//
//  place_detail_test.h
//  yydr
//
//  Created by Li yi on 13-6-28.
//
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "global.h"

#import "UIView+GetRequestCookie.h"
#import "UIView+iImageManager.h"
#import "UIView+iTextManager.h"
#import "UIView+iButtonManager.h"
#import "UIImageView+WebCache.h"

#import "place_photo_preview.h"
#import "place_detail_cell0.h"
#import "place_detail_comment_cell.h"
#import "place_detail_tel_cell.h"
#import "place_detail_manager_cell.h"
#import "place_comment_list_cell.h"
#import "place_comment_add.h"
#import "place_manager_list.h"
#import "place_ablum.h"

#import "map.h"


@interface place_detail : STableViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ASIProgressDelegate,MBProgressHUDDelegate,CommentAddDelegate>
{
    MBProgressHUD *HUD;
    
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
    
    //照片高度
    int photoHeight;
    
    //照片文件名
    NSString *FileName;
    

    BOOL canLoadMore;
    
    ASIHTTPRequest *placeCommentRequest;
}

- (void)load:(NSDictionary*)dic;


@end
