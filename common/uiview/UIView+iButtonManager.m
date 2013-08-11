//
//  UIView+iButtonManager.m
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+iButtonManager.h"

@implementation UIView (iButtonManager)


-(UIBarButtonItem*)add_logout_button:(SEL)_a target:(id)_s
{
    UIButton *bt = [self addButton:nil
                             image:@"place_logout_bt.png"
                          position:CGPointMake(0, 0)
                               tag:0
                            target:_s
                            action:_a];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}

-(UIBarButtonItem*)add_manager_add_button:(SEL)_a target:(id)_s
{
    UIButton *bt = [self addButton:nil
                             image:@"place_manager_add_bt.png"
                          position:CGPointMake(0, 0)
                               tag:0
                            target:_s
                            action:_a];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}


-(UIBarButtonItem*)add_setting_button:(SEL)_a target:(id)_s
{
    UIButton *bt = [self addButton:nil
                             image:@"place_setting_bt.png"
                          position:CGPointMake(0, 0)
                               tag:0
                            target:_s
                            action:_a];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}



-(UIBarButtonItem*)add_nav_button:(SEL)_a target:(id)_s
{
    UIButton *bt = [self addButton:nil
                             image:@"place_nav_bt.png"
                          position:CGPointMake(0, 0)
                               tag:0
                            target:_s
                            action:_a];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}


-(UIBarButtonItem*)add_add_button:(SEL)_a target:(id)_s
{
    
    //place 新加按钮
    UIButton *bt = [self addButton:nil
                             image:@"place_add_bt.png"
                          position:CGPointMake(0, 0)
                               tag:0
                            target:_s
                            action:_a];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}


-(UIBarButtonItem*)add_reload_button:(SEL)_a target:(id)_s
{
    
    //place 刷新按钮
    UIButton *bt = [self addButton:nil
                             image:@"place_reload_bt.png"
                          position:CGPointMake(0, 0)
                               tag:0
                            target:_s
                            action:_a];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}

-(UIBarButtonItem*)add_back_button:(SEL)_a target:(id)_s
{
    

    UIButton *bt = [self addButton:nil
                             image:@"place_back_bt.png"
                          position:CGPointMake(0, 0)
                               tag:0
                            target:_s
                            action:_a];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}

-(UIBarButtonItem*)add_close_button:(SEL)_a target:(id)_s
{
    

    UIButton *bt = [self addButton:nil
                             image:@"place_close_bt.png"
                          position:CGPointMake(0, 0)
                               tag:0
                            target:_s
                            action:_a];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}

-(UIBarButtonItem*)add_upload_button:(SEL)_a target:(id)_s
{
    
    UIButton *bt = [self addButton:nil
                             image:@"place_upload_bt.png"
                          position:CGPointMake(0, 0)
                               tag:0
                            target:_s
                            action:_a];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}

-(UIBarButtonItem*)add_clear_button:(SEL)_a target:(id)_s
{
    
    UIButton *bt = [self addButton:nil
                             image:@"place_clear_bt.png"
                          position:CGPointMake(0, 0)
                               tag:0
                            target:_s
                            action:_a];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}


-(UIBarButtonItem*)add_ok_button:(SEL)_a target:(id)_s
{
    UIButton *bt = [self addButton:nil
                             image:@"place_ok_bt.png"
                          position:CGPointMake(0, 0)
                               tag:0
                            target:_s
                            action:_a];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}





-(UIButton*) addButton:(UIView*)_u
                 image:(NSString*)_n
              position:(CGPoint)_p 
                   tag:(int)_t  
                target:(id)_d
                action:(SEL)_a
{
    
    UIImage *btBg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_n 
                                                                                   ofType:nil]];
    UIButton *bt=[UIButton buttonWithType: UIButtonTypeCustom];
    if(_t!=0)
    {
        bt.tag=_t;
    }
    
    bt.frame=CGRectMake(_p.x,_p.y,btBg.size.width,btBg.size.height); 
    
    [bt setBackgroundImage:btBg forState:UIControlStateNormal];
    
    //添加事件
    [bt addTarget:_d action:_a forControlEvents:UIControlEventTouchUpInside];
    if(_u!=nil)
        [_u addSubview:bt];
    
    return bt;
}


-(UIButton*) addButtonWithCenter:(UIView*)_u 
                           image:(NSString*)_n 
                        position:(CGPoint) _p 
                             tag:(int)_t 
                          target:(id)_d
                          action:(SEL) _a
{
    UIButton *i=[self addButton:_u
                          image:_n
                       position:CGPointMake(0, 0)
                            tag:_t
                         target:_d
                         action:_a];
    i.center=_p;
    
    return i;
}

//----------------------------------------------------------------------------------------------------
#pragma mark- 添加ImageView按钮
- (UIImageView*) addButtonWithImageView:(UIView*)_u
                                  image:(NSString*)_n 
                              highlight:(NSString*)_hn 
                               position:(CGPoint)_p 
                                      t:(int)_t 
                                 action:(SEL)_a
{
    
    UIImage *btBg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
                                                    pathForResource:_n ofType:nil]];
    
    UIImageView *bt=[[UIImageView alloc] initWithFrame:CGRectMake(_p.x,
                                                                  _p.y, 
                                                                  btBg.size.width, 
                                                                  btBg.size.height)]; 
    bt.userInteractionEnabled=YES;
    bt.tag=_t;
    bt.image=btBg;
    
    if(_hn!=nil)
    {
        bt.highlightedImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
                                                              pathForResource:_hn ofType:nil]];
        
    }
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] 
                                               initWithTarget:self 
                                               action:_a];
    [bt addGestureRecognizer:singleFingerTap];
    
    [_u addSubview:bt];
    
    return bt;
}



- (UIImageView*) addButtonWithImageViewWithCenter:(UIView*)_u
                                            image:(NSString*)_n 
                                        highlight:(NSString*)_hn 
                                         position:(CGPoint)_p 
                                                t:(int)_t 
                                           action:(SEL)_a
{
    
    
    UIImageView *bt=[self addButtonWithImageView:_u
                                           image:_n
                                       highlight:_hn
                                        position:_p
                                               t:_t
                                          action:_a];
    
    bt.center=_p;
    
    return bt;
}


-(void) addTapEvent:(UIView*)_u
             target:(id)_d
             action:(SEL) _a
{
    
    _u.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] 
                                               initWithTarget:_d 
                                               action:_a];
    [_u addGestureRecognizer:singleFingerTap];
}

-(void) addDoubleTapEvent:(UIView*)_u
                   target:(id)_d
                   action:(SEL) _a
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                   initWithTarget:_d 
                                   action:_a];
    tap.numberOfTapsRequired=2;
    
    [_u addGestureRecognizer:tap];
}





@end
