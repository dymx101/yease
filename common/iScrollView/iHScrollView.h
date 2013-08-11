//
//  iHScrollView.h
//  test
//
//  Created by 毅 李 on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#define LEFT -1
#define RIGHT 1
#define UP -2
#define DOWN 2
#define MIDDLE 0

#define ANIMATION_DURATION .2

@protocol iHScrollViewDelegate;

@interface iHScrollView : UIScrollView<UIScrollViewDelegate>
{
    id<iHScrollViewDelegate> hsvdelegate;
    
    NSMutableArray *pageList;
    int currentPageNum;
	float lastContentOffset;
    
    UIPageControl *pc;
    int sTag;
    
    float maxScale;
    float minScale;
    
    BOOL autoScale;
}

@property (nonatomic,strong) id<iHScrollViewDelegate> hsvdelegate;

-(void) setZoomAutoScale;
-(void) setZoomMaxScale:(float)ms MinScale:(float)ss;
-(void) showPageControl:(CGPoint)_p;
-(void)showPageControl:(CGPoint)_p color:(UIColor*)c highlightColor:(UIColor*)fc;
-(void) initWithArray:(NSMutableArray*)_a;
-(void) jumpToPage:(int) cn command:(int) cmd;
-(void) addPage:(int) i direction:(int) d command:(int) cmd;
-(void) removePage:(int) i;
-(void) loadImage:(NSString*)fn type:(NSString*)t;

@end

//
@protocol iHScrollViewDelegate <NSObject>

@optional

-(void)iHScrollViewDidScroll:(iHScrollView*)page;

@end