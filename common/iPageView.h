//
//  iPageView.h
//  test
//
//  Created by 毅 李 on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"
#import "UIView+iAnimationManager.h"



@interface iPageView : UIView


-(UIViewController*)getManager;
-(void)setManager:(UIViewController*) m;

//自定义初始化方法
-(void)initWithDirection:(int) direction;

//当前显示要执行得方法
-(void)loadCurrentPage:(int) cmd;
-(void)unloadCurrentPage;

//每一帧方法
-(void)enterFrame:(int) distance;

//dealloc前停止时间器
-(void)stopNSTimer;

-(void) loadpage:(int)cpage;


@end
