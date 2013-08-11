//
//  UIView+iAnimationManager.h
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (iAnimationManager)

-(void) startAnimation:(UIView*) v
                  sPos:(CGPoint) sp
                  ePos:(CGPoint) ep
                sAlpha:(float) sa 
                eAlpha:(float) ea
                sScale:(CGPoint) ss
                eScale:(CGPoint) es 
              duration:(NSTimeInterval) t 
                 delay:(NSTimeInterval) d 
                option:(UIViewAnimationOptions) o;


-(void)setRoate:(UIView*)v dir:(int)d;
-(void)setRoate:(UIView*)v speed:(float)s;

-(void) fadeInView:(UIView*) v1 
       withNewView:(UIView*) v2 
          duration:(float)d;


-(void)fadeInView:(UIView *)v1 
         duration:(float)d;

-(void)fadeOutView:(UIView*)v duration:(float)d;
-(void)setMove:(UIView*)v start:(CGPoint)sp end:(CGPoint)ep time:(float)t;
-(void)setFlash:(UIView*)v time:(float)t;

-(UIImageView*)setLight:(UIView*)sv
                   View:(UIImageView*)v
               startPos:(CGPoint)sp
                 endPos:(CGPoint)ep
                   Mask:(NSString*)m
                  Light:(NSString*)l
               duration:(NSTimeInterval) t;


-(UIImageView*)setShadowAnimtion:(UIView*)v Image:(NSString*)fn time:(float)t;
-(UIImageView*)setLight:(UIView*)sv View:(UIImageView*)v Mask:(NSString*)m Light:(NSString*)l  duration:(NSTimeInterval) t;
-(void)setZoom:(UIView*)v0 from:(UIView*)v1 duration:(NSTimeInterval)t  completion:(void (^)(void))animations;
@end
