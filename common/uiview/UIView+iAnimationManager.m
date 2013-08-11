//
//  UIView+iAnimationManager.m
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+iAnimationManager.h"
#import "UIView+iImageManager.h"
#import "iPageView.h"
@implementation UIView (iAnimationManager)


-(void)setRoate:(UIView*)v dir:(int)d
{
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:.01*d*M_PI];
    spinAnimation.cumulative = YES;
    [spinAnimation setRepeatCount:HUGE_VALF];
    
    [v.layer addAnimation:spinAnimation forKey:@"animateLayer"];
}

-(void)setRoate:(UIView*)v speed:(float)s
{
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:s*M_PI];
    spinAnimation.cumulative = YES;
    [spinAnimation setRepeatCount:HUGE_VALF];
    
    [v.layer addAnimation:spinAnimation forKey:@"animateLayer"];
}



-(void) startAnimation:(UIView*) v
                  sPos:(CGPoint) sp
                  ePos:(CGPoint) ep
                sAlpha:(float) sa 
                eAlpha:(float) ea
                sScale:(CGPoint) ss
                eScale:(CGPoint) es 
              duration:(NSTimeInterval) t 
                 delay:(NSTimeInterval) d 
                option:(UIViewAnimationOptions) o
{
    //初始化
    [v setCenter:sp];
    [v setAlpha:sa];
    v.transform=CGAffineTransformMakeScale(ss.x, ss.y);
    
    //动画
    [UIView animateWithDuration:t 
                          delay:d 
                        options:o 
                     animations:^(void) {
                         
                         [v setCenter:ep];
                         [v setAlpha:ea];
                         v.transform=CGAffineTransformMakeScale(es.x, es.y);
                         
                     } completion:^(BOOL finished) {
                         //添加交互
                         v.userInteractionEnabled=YES;
                     }];    
}


-(void) fadeInView:(iPageView*) v1
       withNewView:(iPageView*) v2 
          duration:(float)d
{
    v2.alpha=0;
    [self addSubview:v2];
    v2.tag=v1.tag;

    [UIView animateWithDuration:d
                     animations:^{
                         v2.alpha=1;
                     } completion:^(BOOL finished) {
                         [v1 unloadCurrentPage];
                         [v1 removeFromSuperview];
                     }];
}

-(void)fadeOutView:(UIView*)v duration:(float)d
{
    
    [UIView animateWithDuration:d
                     animations:^{
                         v.alpha=0;
                     } completion:^(BOOL finished) {
                         [v removeFromSuperview];
                     }];
    
}


-(void)fadeInView:(UIView *)v1 
         duration:(float)d
{
    v1.alpha=0;
    [self addSubview:v1];
    
    [UIView animateWithDuration:d
                     animations:^{
                         v1.alpha=1;
                     }];
}

-(void)setMove:(UIView*)v start:(CGPoint)sp end:(CGPoint)ep time:(float)t
{
    //动画
       
    CGPoint startPt = sp;
    CGPoint endPt = ep;
    
    CABasicAnimation *posAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    posAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    posAnim.fromValue = [NSValue valueWithCGPoint:startPt];
    posAnim.toValue = [NSValue valueWithCGPoint:endPt];
    
    posAnim.repeatCount = HUGE_VALF;
    posAnim.duration = t;
    
    //透明动画
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1];
    opacityAnim.toValue = [NSNumber numberWithFloat:0];
    opacityAnim.removedOnCompletion = YES;
    
    
    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:posAnim,opacityAnim, nil];
    animGroup.duration = t;
    [animGroup setRepeatCount:HUGE_VALF];
    
    [[v layer] setAnchorPoint:CGPointMake(0.5, 0.5)]; 
    [[v layer] addAnimation:animGroup forKey:nil];  
    
    
}


-(void)setFlash:(UIView*)v time:(float)t
{
    //动画
    CAKeyframeAnimation *rock;
    rock = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [rock setDuration:t];
    [rock setRepeatCount:HUGE_VALF];
    [rock setFillMode:kCAFillModeForwards];
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSNumber numberWithFloat:0.0]];
    [values addObject:[NSNumber numberWithFloat:1.0]];
    [values addObject:[NSNumber numberWithFloat:0.0]];
    
    [rock setValues:values];
    
    [[v layer] addAnimation:rock forKey:@"alpha"];    
    
    
}


-(UIImageView*)setLight:(UIView*)sv
                   View:(UIImageView*)v
               startPos:(CGPoint)sp
                 endPos:(CGPoint)ep
                   Mask:(NSString*)m
                  Light:(NSString*)l
               duration:(NSTimeInterval) t
{
    UIImageView *flash= [self addImageViewWithCenter:sv
                                               image:m
                                            position:v.center];
    
    
    UIImage *im=[UIImage imageNamed:l];
    
    
    CALayer *l2 = [[CALayer alloc] init];
    [l2 setBounds:CGRectMake(0, 0, im.size.width, im.size.height)];
    [l2 setPosition:sp];
    [l2 setAnchorPoint:CGPointMake(0.5, 0.5)];
    [l2 setContents:(UIImage*)im.CGImage];
    [[flash layer] setMask:l2];
    
    CGPoint startPt = sp;
    CGPoint endPt = ep;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.fromValue = [NSValue valueWithCGPoint:startPt];
    anim.toValue = [NSValue valueWithCGPoint:endPt];
    anim.repeatCount = HUGE_VALF;
    anim.duration = t;
    
    [l2 addAnimation:anim forKey:@"position"];
    
    return flash;
}



-(UIImageView*)setLight:(UIView*)sv View:(UIImageView*)v Mask:(NSString*)m Light:(NSString*)l  duration:(NSTimeInterval) t 
{
    UIImageView *flash= [self addImageViewWithCenter:sv 
                                               image:m
                                            position:v.center];
    
    CALayer *l2 = [[CALayer alloc] init];
    [l2 setBounds:CGRectMake(0, 0, 400, 400)]; 
    [l2 setPosition:CGPointMake(-200,0)]; 
    [l2 setAnchorPoint:CGPointMake(0.5, 0.5)]; 
    [l2 setContents:(UIImage*)[UIImage imageNamed:l].CGImage];
    [[flash layer] setMask:l2];
    
    CGPoint startPt = CGPointMake(-200,0);
    CGPoint endPt = CGPointMake(1024,768);
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.fromValue = [NSValue valueWithCGPoint:startPt];
    anim.toValue = [NSValue valueWithCGPoint:endPt];
    anim.repeatCount = HUGE_VALF;
    anim.duration = t;
    
    [l2 addAnimation:anim forKey:@"position"]; 
    
    return flash;
}



-(UIImageView*)setShadowAnimtion:(UIView*)v Image:(NSString*)fn time:(float)t
{
    
    UIImage *i=[UIImage imageNamed:fn];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y, i.size.width, i.size.height)];
    iv.image=i;
    
    
    [v.superview insertSubview:iv  belowSubview:v];
    
    //缩放动画
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)];
    scaleAnim.removedOnCompletion = YES;
    
    
    //透明动画
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:.5];
    opacityAnim.toValue = [NSNumber numberWithFloat:0];
    opacityAnim.removedOnCompletion = YES;

    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:scaleAnim,opacityAnim, nil];
    animGroup.duration = t;
    [animGroup setRepeatCount:HUGE_VALF];
    
    [iv.layer addAnimation:animGroup forKey:nil]; 
    
    return iv;
}


-(void)setZoom:(UIView*)v0 from:(UIView*)v1 duration:(NSTimeInterval)t  completion:(void (^)(void))animations
{
    v0.alpha=0;
    v0.transform=CGAffineTransformMakeScale(.1,.1);
    v0.center=v1.center;
    
    [UIView animateWithDuration:t
                     animations:^{
                         v0.alpha=1;
                         v0.transform=CGAffineTransformMakeScale(1, 1);
                         v0.center=CGPointMake(512, 384);
                     } completion:^(BOOL finished) {
                         animations();
                     }];
}



@end
