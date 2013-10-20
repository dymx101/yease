//
//  title.m
//  yydr
//
//  Created by Li yi on 13-6-20.
//
//

#import "title.h"
#import "UIView+iTextManager.h"
#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"

@implementation title

@synthesize titleText;
@synthesize cityText;
@synthesize cityId;
@synthesize cityDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        titleText= [self addLabel:self
                            frame:CGRectMake(0, 0, 200, 40)
                             font:[UIFont boldSystemFontOfSize:20]
                             text:@"场所"
                            color:[UIColor whiteColor]
                              tag:1000];

        titleText.textAlignment=UITextAlignmentCenter;
        
        
        
        /*
        cityText= [self addLabel:self
                           frame:CGRectMake(150, 0, 100, 40)
                            font:[UIFont systemFontOfSize:12]
                            text:[[NSUserDefaults standardUserDefaults] objectForKey:@"City"]
                           color:[UIColor whiteColor]
                             tag:1000];
        
        cityText.textAlignment=UITextAlignmentLeft;
        [cityText sizeToFit];
        cityText.center=CGPointMake(0, titleText.center.y);
        
        CGRect f=cityText.frame;
        f.origin.x=120;
        cityText.frame=f;
        
        arrow= [self addImageViewWithCenter:self
                                      image:@"city_down_bt.png"
                                   position:CGPointMake(cityText.frame.size.width+cityText.frame.origin.x+10,
                                                        cityText.center.y)];
        [self addTapEvent:self
                   target:self
                   action:@selector(onDown:)];
        */
        
        
        
      
        
        
        
        
        
    }
    return self;
}

-(void)onDown:(UIGestureRecognizer*)sender
{
    [cityDelegate onCityDown];
}


-(void)showPlace
{

    
    titleText.center=CGPointMake(90, titleText.center.y);
    cityText.hidden=NO;
    arrow.hidden=NO;
    [cityText sizeToFit];
    arrow.center=CGPointMake(cityText.frame.size.width+cityText.frame.origin.x+10,
                                         cityText.center.y);
}

-(void)showOther
{
    titleText.center=CGPointMake(100, titleText.center.y);
    cityText.hidden=YES;
    arrow.hidden=YES;
}



@end
