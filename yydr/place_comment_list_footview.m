//
//  place_comment_list_footview.m
//  yydr
//
//  Created by liyi on 13-2-8.
//
//

#import "place_comment_list_footview.h"
#import "UIView+iTextManager.h"
#import "UIView+iButtonManager.h"

@implementation place_comment_list_footview

@synthesize activityIndicator;
@synthesize title;
@synthesize completed;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //加载中...
        title=[self addLabel:self
                       frame:CGRectMake(0, 0, 100, 25)
                        font:[UIFont systemFontOfSize:15]
                        text:@"正在载入..."
                       color:[UIColor grayColor]
                         tag:1000];
        
        
        title.textAlignment=UITextAlignmentCenter;
        title.center=CGPointMake(self.center.x,self.center.y);
        
        activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:activityIndicator];
        activityIndicator.center=CGPointMake(title.frame.origin.x,self.center.y);
        [activityIndicator stopAnimating];
        
        
        //加载更多按钮
        loadBt=[self addButton:self
                         image:@"place_list_ft_bg.png"
                      position:CGPointMake(0, 0)
                           tag:3030
                        target:self.superview
                        action:@selector(onDown:)];
        
        
        UILabel *lt=[self addLabel:loadBt
                             frame:CGRectMake(0, 0, 0, 0)
                              font:[UIFont systemFontOfSize:16]
                              text:@"点击查看更多"
                             color:[UIColor grayColor]
                               tag:0];
        
        [lt sizeToFit];
        lt.center=CGPointMake(loadBt.frame.size.width/2, loadBt.frame.size.height/2);
        
        completed=[self addLabel:self
                           frame:CGRectMake(0, 0, 0, 0)
                            font:[UIFont systemFontOfSize:16]
                            text:@"全部加载完毕"
                           color:[UIColor grayColor]
                             tag:0];
        completed.textAlignment=UITextAlignmentCenter;
        [completed sizeToFit];
        completed.center=CGPointMake(loadBt.frame.size.width/2, loadBt.frame.size.height/2);
        
    }
    return self;
}

-(void)showCompleted
{
    completed.hidden=NO;
}

-(void)showLoading
{
    title.hidden=NO;
    [activityIndicator startAnimating];
}

-(void)showLoadButton
{
    loadBt.hidden=NO;
}

-(void)hideAll
{
    completed.hidden=YES;
    title.hidden=YES;
    [activityIndicator stopAnimating];
    loadBt.hidden=YES;
}

@end
