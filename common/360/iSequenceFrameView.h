//
//  iSequenceFrameView.h
//  demo-crystal
//
//  Created by 毅 李 on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPageView.h"

@protocol iSequenceFrameViewDelegate;

@interface iSequenceFrameView : iPageView
{
    id<iSequenceFrameViewDelegate> delegate;
    
    UIImageView *animationView;
    NSArray *step_array;
    
    NSTimer *timer;
    int curFrame,dir;
    NSString *type;
    NSString *fileName;
    int curStep;
    BOOL playing;
    
    
    NSString *curPlace;//当前位置
    NSString *endPlace;//终点
    
    float time;

}

@property (nonatomic,strong) id<iSequenceFrameViewDelegate> delegate;
@property (nonatomic) float time;


-(void)stopAni;
-(void)setStepArray:(NSArray*)sa;

@property (nonatomic,strong) NSString *curPlace;
@property (nonatomic,strong) NSString *endPlace;
@property (nonatomic,strong) UIImageView *animationView;
@property (nonatomic) BOOL playing;

@end


@protocol iSequenceFrameViewDelegate <NSObject>

@optional
-(void)iSequenceFrameViewEndAnimation:(iSequenceFrameView*)sender;

@end