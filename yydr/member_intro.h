//
//  member_signature.h
//  yydr
//
//  Created by Li yi on 13-5-26.
//
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "dbHelper.h"
#import "iTableViewController.h"
@interface member_intro : iTableViewController<UITextViewDelegate,MBProgressHUDDelegate>
{
    UIPlaceHolderTextView *body;
    ASIFormDataRequest *request;
    MBProgressHUD *HUD;
    
    dbHelper *dh;
    NSString *Signature;
}

@property (nonatomic,strong) ASIFormDataRequest *request;
@property (nonatomic,strong) MBProgressHUD *HUD;


-(void)loadSignature:(NSString*)signature;
@end
