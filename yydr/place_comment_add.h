//
//  place_comment.h
//  yydr
//
//  Created by 毅 李 on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "UIPlaceHolderTextView.h"
#import "iTableViewController.h"

@protocol CommentAddDelegate;

@interface place_comment_add : iTableViewController<UITextFieldDelegate,UITextViewDelegate,MBProgressHUDDelegate>
{
    id<CommentAddDelegate> delegate;
    
    MBProgressHUD *HUD;
    int PlaceId;
    
    UIPlaceHolderTextView *body;
    UITextField *recommend;
    UITextField *price;
    UISegmentedControl *segmentedControl;
    int rating;
    BOOL waiting;
    
}
@property (nonatomic,strong) id<CommentAddDelegate> delegate;
-(void)setPlaceId:(int)pid;
@end


@protocol CommentAddDelegate <NSObject>

@optional
-(void)CommentAddFinished;

@end