//
//  iPageView.m
//  test
//
//  Created by 毅 李 on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iPageView.h"


static UIViewController *manager;

@implementation iPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIViewController*)getManager
{
    return manager;
}

- (void)setManager:(UIViewController*) m {
    manager=m; 
}

-(void)loadpage:(int)cpage
{
    
}

//----------------------------------------------------------------------------------------------------
-(void)initWithDirection:(int) direction
{
	//NSLog(@"page模版 initWithDirection %d",direction);
}

-(void)loadCurrentPage:(int) cmd
{
	//NSLog(@"page模版 loadCurrentPage");
}

-(void)unloadCurrentPage
{
	//NSLog(@"page模版 unloadCurrentPage");
}

-(void)stopNSTimer
{
    // NSLog(@"page模版 stopNSTimer");
}

-(void)enterFrame:(int) distance
{
	//NSLog(@"enterFrame %d",distance);
}

@end
