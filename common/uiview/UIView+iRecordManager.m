//
//  UIView+iRecordManager.m
//  olympic
//
//  Created by liyi on 13-3-15.
//  Copyright (c) 2013年 liyi. All rights reserved.
//

#import "UIView+iRecordManager.h"
#import "UIView+iButtonManager.h"

@implementation UIView (iRecordManager)


-(UIView*)addCheckBox:(UIView*)v Check:(NSString*)cc Checked:(NSString*)cd Label:(NSString*)l Color:(UIColor*)c Position:(CGPoint)p Tag:(int)t Target:(id)_d Action:(SEL)_a
{
    UIView *uv=[[UIView alloc] initWithFrame:CGRectMake(p.x, p.y, 30,30)];
    //uv.backgroundColor=[UIColor redColor];
    
    //按钮
    UIImage *btBg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                    pathForResource:cc ofType:nil]];
    
    UIImageView *bt=[[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  btBg.size.width,
                                                                  btBg.size.height)];
    bt.userInteractionEnabled=YES;
    bt.tag=t;
    bt.image=btBg;
    bt.highlightedImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                          pathForResource:cd ofType:nil]];
    
    //事件
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]
                                               initWithTarget:_d
                                               action:_a];
    [bt addGestureRecognizer:singleFingerTap];
    
    [uv addSubview:bt];
    
    
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(35, 0, 0, 0)];
    lb.backgroundColor=[UIColor clearColor];
    lb.text=l;
    lb.textColor=c;
    [lb sizeToFit];
    
    lb.center=CGPointMake(lb.center.x,bt.center.y);
    
    
    [uv addSubview:lb];
    [uv sizeToFit];
    
    [v addSubview:uv];
    return uv;
}



@end
