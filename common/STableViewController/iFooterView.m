//
//  iTableFooterView.m
//  Demo
//
//  Created by Li yi on 13-6-17.
//
//

#import "iFooterView.h"

@implementation iFooterView

@synthesize infoLabel;
@synthesize activityIndicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        infoLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        infoLabel.backgroundColor=[UIColor clearColor];
        infoLabel.textColor=[UIColor blackColor];

        
        infoLabel.textAlignment=UITextAlignmentCenter;
        infoLabel.center=CGPointMake(self.center.x,self.center.y);
        infoLabel.text=@"加载中...";
        [self addSubview:infoLabel];
        
        
        activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:activityIndicator];
        activityIndicator.center=CGPointMake(self.center.x-60,self.center.y);
        [activityIndicator stopAnimating];
  
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
