//
//  iSequenceFrameView.m
//  demo-crystal
//
//  Created by 毅 李 on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iSequenceFrameView.h"

@implementation iSequenceFrameView

@synthesize delegate;

@synthesize curPlace;
@synthesize endPlace;
@synthesize animationView;
@synthesize playing;
@synthesize time;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
        animationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:animationView];
        
        step_array=[NSMutableArray array];
        curStep=0;
        
        self.playing=NO;
        
        time=1.0/60.0;
    }
    return self;
}


-(void)setStepArray:(NSArray*)sa
{
     curStep=0;
     step_array=nil;
     step_array=sa;
     [self play:[sa objectAtIndex:curStep]];
}


-(void)play:(NSDictionary*)dic                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
{
    
    fileName=[dic objectForKey:@"fileName"];
    curFrame=[[dic objectForKey:@"startFrame"] intValue];
    dir=[[dic objectForKey:@"dir"] intValue];
    type=[dic objectForKey:@"type"];
    endPlace=[dic objectForKey:@"endPlace"];
    
    //NSLog(@"%d",dir);
    

    self.playing=YES;
    
    timer=[NSTimer scheduledTimerWithTimeInterval:time
                                           target:self 
                                         selector:@selector(update) 
                                         userInfo:nil
                                          repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}



-(void)stopAni
{
    step_array=nil;
    [timer invalidate];
    timer=nil;
}

-(void)unloadCurrentPage
{
 
    delegate=nil;
    step_array=nil;
    
    [timer invalidate];
    timer=nil;
}


-(void)update
{
    curFrame=curFrame+dir;

    NSLog(@"%@",[NSString stringWithFormat:@"%@%d.%@",fileName,curFrame,type]);
    
    UIImage *im=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
                                                 pathForResource:[NSString stringWithFormat:@"%@%d.%@",fileName,curFrame,type]
                                                 ofType:nil]];
    
    if(im==nil)
    {
        [timer invalidate];
        timer=nil;
        
        self.playing=NO;
        
        if (curStep<[step_array count]-1) {
            curStep=curStep+1;
            [self play:[step_array objectAtIndex:curStep]];
        } 
        else
        {
            curPlace=endPlace;
            
            if([delegate conformsToProtocol:@protocol(iSequenceFrameViewDelegate)])
            {
                [delegate iSequenceFrameViewEndAnimation:self];
            }
        }
    }
    else {
         animationView.image=im;
    }
    
    
}

@end
