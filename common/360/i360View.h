//
//  page_ani.h
//  david
//
//  Created by liyi on 11-5-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPageView.h"


@protocol i360ViewDelegate;

@interface i360View : iPageView<UIScrollViewDelegate> {
    
    id<i360ViewDelegate> delegate;
    
    UIImageView *animationView;
    NSMutableArray *img_array;
    NSString *imageName;
    
    int rNum;
    int curFrame;
    int count;
    
    int sx;
    int xx;
    
    UIScrollView *v;
    
    NSMutableArray *postionArray;
    
    NSTimer *timer;
    
    int dir;
    int targetFrame;
    
    BOOL playLoop;
    BOOL dragLoop;
    
    int xOffset,yOffset;
    

}

@property (nonatomic,strong) id<i360ViewDelegate> delegate;
@property (nonatomic) BOOL dragLoop;
@property (nonatomic,strong) UIImageView *animationView;

-(UIButton*)addPoint:(UIView*)_u Image:(NSString*)fn Postion:(NSMutableArray*)ma;
-(void)loadImages:(NSString*)n Type:(NSString*)t;
-(void)gotoAndStop:(int)f;
-(void)playAnimation:(BOOL)loop Inverted:(BOOL)inverted;
-(void)setLastFrame;
-(void)setCurrentFrame:(int)cf;
-(int)getCurrentFrame;
-(void)setScrollEnable:(BOOL)e;
-(void)setImage:(NSString*)fn;
-(UIButton*)addPoint:(NSString*)fn Postion:(NSMutableArray*)ma Tag:(int)t;
@end

//-----
@protocol i360ViewDelegate <NSObject>

@optional
-(void)i360Down:(UIButton*)sender;
-(void)i360DidEndAnimation:(i360View*)page;
-(void)i360DidEndGotoAndStop:(i360View*)page;
-(void)i360DidDrag:(i360View*)page;
@end 


