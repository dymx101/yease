//
//  UIView+iButtonManager.h
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (iButtonManager)


-(UIBarButtonItem*)add_add_button:(SEL)_a target:(id)_s;
-(UIBarButtonItem*)add_reload_button:(SEL)_a target:(id)_s;
-(UIBarButtonItem*)add_back_button:(SEL)_a target:(id)_s;
-(UIBarButtonItem*)add_close_button:(SEL)_a target:(id)_s;
-(UIBarButtonItem*)add_clear_button:(SEL)_a target:(id)_s;
-(UIBarButtonItem*)add_upload_button:(SEL)_a target:(id)_s;
-(UIBarButtonItem*)add_ok_button:(SEL)_a target:(id)_s;
-(UIBarButtonItem*)add_nav_button:(SEL)_a target:(id)_s;
-(UIBarButtonItem*)add_setting_button:(SEL)_a target:(id)_s;
-(UIBarButtonItem*)add_manager_add_button:(SEL)_a target:(id)_s;
-(UIBarButtonItem*)add_logout_button:(SEL)_a target:(id)_s;

-(UIButton*) addButton:(UIView*)_u 
                 image:(NSString*)_n 
              position:(CGPoint)_p 
                   tag:(int)_t  
                target:(id)_d
                action:(SEL)_a; 

-(UIButton*) addButtonWithCenter:(UIView*)_u 
                           image:(NSString*)_n 
                        position:(CGPoint) _p 
                             tag:(int)_t 
                          target:(id)_d
                          action:(SEL) _a;

- (UIImageView*) addButtonWithImageView:(UIView*)_u 
                                  image:(NSString*)_n 
                              highlight:(NSString*)_hn 
                               position:(CGPoint) _p 
                                      t:(int)_t 
                                 action:(SEL)_a;


-(void) addTapEvent:(UIView*)_u
             target:(id)_d
             action:(SEL) _a;

-(void) addDoubleTapEvent:(UIView*)_u
                   target:(id)_d
                   action:(SEL) _a;

- (UIImageView*) addButtonWithImageViewWithCenter:(UIView*)_u
                                            image:(NSString*)_n 
                                        highlight:(NSString*)_hn 
                                         position:(CGPoint)_p 
                                                t:(int)_t 
                                           action:(SEL)_a;
@end
