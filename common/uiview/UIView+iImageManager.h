//
//  UIView+iImageManager.h
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (iImageManager)


-(BOOL)isHasImage:(NSString*)filename;

-(UIImageView*)addBackground:(NSString*)_n;


-(UIImageView*)addImageView:(UIView*)_u
                      url:(NSString*)_n 
                   position:(CGPoint)_p;


-(UIImageView*)addImageView:(UIView*)_u
                      image:(NSString*)_n 
                   position:(CGPoint)_p;

-(UIImageView*)addImageView:(UIView*)_u
                      image:(NSString*)_n 
                   position:(CGPoint)_p
                        tag:(int)_t;

-(UIImageView*)addImageViewWithCenter:(UIView*)_u
                                image:(NSString*)_n 
                             position:(CGPoint)_p;


-(UIScrollView*)addScrollView:(UIView*)_u
                     delegate:(id)_s
                        frame:(CGRect)_r 
                      bounces:(BOOL)_b
                         page:(BOOL)_p
                        showH:(BOOL)_h 
                        showV:(BOOL)_v;

-(UIPageControl*)addPageControl:(UIView*)_u
                          point:(CGPoint)_p;

-(int)addImageToScrollView:(UIScrollView*)sv
                  fileName:(NSString *)fn
                      type:(NSString*)t;


-(int)addImageToHScrollView:(UIScrollView*)sv fileName:(NSString *)fn type:(NSString*)t;



@end
