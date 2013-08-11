//
//  iTableHeaderView.m
//  Demo
//
//  Created by Li yi on 13-6-17.
//
//

#import "iHeaderView.h"
#import "UIView+iImageManager.h"

@implementation iHeaderView

@synthesize infoLabel;
@synthesize activityIndicator;
@synthesize arrow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        infoLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        infoLabel.backgroundColor=[UIColor clearColor];
        infoLabel.textColor=[UIColor blackColor];
        
        infoLabel.textAlignment=UITextAlignmentCenter;
        infoLabel.center=CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
        infoLabel.text=@"下拉可以刷新...";
        
        [self addSubview:infoLabel];
        
        activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:activityIndicator];
        activityIndicator.center=CGPointMake(self.frame.size.width/2-60,self.frame.size.height/2);
        [activityIndicator stopAnimating];
        
        arrow=[self addImageView:self
                           image:@"place_refresh_arrow.png"
                        position:CGPointMake(0, 0)];
        
        arrow.center=CGPointMake(self.frame.size.width/2-100,self.frame.size.height/2);

        
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
