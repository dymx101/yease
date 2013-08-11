//
//  iBmwMenuView.h
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPageView.h"

@interface iBmwMenuView : iPageView<UIScrollViewDelegate>
{
    UIScrollView *bmwMenu;
    
    int totalid;        //一级菜单数量
    
    int rowid;          //点击打开页面的一级菜单
    int cowid;          //点击打开页面的二级菜单
    
    //居中显示的子scrollview的id
    int activedID;      //当前激活的二级菜单 （ 可上下拖动）
    
    float w;            //菜单内按钮宽度
    float h;            //菜单内按钮高度
    
    //
    BOOL isclick;       //是否点击，滚动停止后打开页面
    
    UITapGestureRecognizer *tap;    //stage 的点击事件
    
}


-(void) buildsubScrollView:(int) id vtag :(int) viewtag;
-(void) moveToLoc:(int)wid v:(int)hid sv:(UIScrollView *) scrollview;

-(void) openPage : (int) chapter sc :(int) subchapter;
-(void) loadPage:(int)cmd subid:(int)sb;

@end
