//
//  UIView+iImageManager.m
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+iImageManager.h"

@implementation UIView (iImageManager)



-(BOOL)isHasImage:(NSString*)filename
{
    UIImage *im=[UIImage imageNamed:filename];
    
    if(im==nil)
        return NO;
    
    return YES;
}


-(UIImageView*)addImageView:(UIView*)_u
                      url:(NSString*)_n 
                   position:(CGPoint)_p
{
    UIImage *i=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_n]]];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(_p.x, _p.y, i.size.width, i.size.height)];
    iv.image=i;
    
    [_u addSubview:iv];
    return iv;
}


//左上角
-(UIImageView*)addImageView:(UIView*)_u
                      image:(NSString*)_n 
                   position:(CGPoint)_p
{
    
    UIImage *i=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
                                                 pathForResource:_n 
                                                 ofType:nil]];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(_p.x, _p.y, i.size.width, i.size.height)];
    iv.image=i;
    
    [_u addSubview:iv];
    return iv;
}

-(UIImageView*)addImageView:(UIView*)_u
                      image:(NSString*)_n 
                   position:(CGPoint)_p
                        tag:(int)_t
{ 

    UIImageView *iv = [self addImageView:_u image:_n position:_p];
    iv.tag=_t;

    return iv;
}

//----------------------------------------------------------------------------------------------------
//中点
-(UIImageView*)addImageViewWithCenter:(UIView*)_u
                                image:(NSString*)_n 
                             position:(CGPoint)_p
{ 
    UIImageView *iv = [self addImageView:_u
                                   image:_n
                                position:_p];
    
    iv.center=_p;
    return iv;
}

//----------------------------------------------------------------------------------------------------
//背景
-(UIImageView*)addBackground:(NSString*)_n
{
    return [self addImageView:self
                        image:_n
                     position:CGPointMake(0, 0)];
}


//----------------------------------------------------------------------------------------------------
#pragma mark- 添加UIScrollView
-(UIScrollView*)addScrollView:(UIView*)_u
                     delegate:(id)_s
                        frame:(CGRect)_r 
                      bounces:(BOOL)_b
                         page:(BOOL)_p
                        showH:(BOOL)_h 
                        showV:(BOOL)_v
{
    
    UIScrollView *sv=[[UIScrollView alloc] initWithFrame:_r];
    sv.delegate=_s;
	sv.bounces=_b;
	sv.pagingEnabled=_p;
    sv.showsHorizontalScrollIndicator=_h;
    sv.showsVerticalScrollIndicator=_v;
    [_u addSubview:sv];
    return sv;
}



-(UIPageControl*)addPageControl:(UIView*)_u
                          point:(CGPoint)_p
{
    UIPageControl *pc;
    pc=[[UIPageControl alloc] init];
    pc.center=_p;
    pc.currentPage=0;
    [_u addSubview:pc];
    return pc;
}
                            

-(int)addImageToScrollView:(UIScrollView*)sv fileName:(NSString *)fn type:(NSString*)t
{
    int count=0;
    
    for(int i=0;i<1000;i++)
    {
        UIImage *im=[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.%@",fn,i,t]];
        
        if(im==nil)
        {
            count=i;
            break;
        }
        sv.contentSize=CGSizeMake(im.size.width*(i+1), sv.frame.size.height);
        
        [self addImageView:sv
                     image:[NSString stringWithFormat:@"%@%d.%@",fn,i,t]
                  position:CGPointMake(i*im.size.width, 0)];
        
    }
    
    return count;
}


-(int)addImageToHScrollView:(UIScrollView*)sv fileName:(NSString *)fn type:(NSString*)t
{
    int count=0;
    
    for(int i=0;i<1000;i++)
    {
        UIImage *im=[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.%@",fn,i,t]];
        
        if(im==nil)
        {
            sv.contentSize=CGSizeMake(sv.frame.size.width, sv.frame.size.height*i);
            count=i;
            break;
        }
        
        [self addImageView:sv
                     image:[NSString stringWithFormat:@"%@%d.%@",fn,i,t]
                  position:CGPointMake(0, sv.frame.size.height*i)];
        
    }
    
    return count;
}



@end
