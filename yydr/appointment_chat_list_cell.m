//
//  appointment_chat_list_cell.m
//  yydr
//
//  Created by liyi on 13-5-13.
//
//

#import "appointment_chat_list_cell.h"

#import "UIView+iAnimationManager.h"
#import "UIView+iImageManager.h"
#import "UIView+iTextManager.h"

@implementation appointment_chat_list_cell

@synthesize cdate;
@synthesize UserName;
@synthesize photo;
@synthesize Msg;
@synthesize qNum;
@synthesize num;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
//        self.backgroundView=[self addImageView:nil
//                                         image:@"place_cell_bg.jpg"
//                                      position:CGPointMake(0, 0)];
        
        
        //头像
        
        self.photo =[self addImageView:self.contentView
                                  image:@"noAvatar.png"
                               position:CGPointMake(15, 10)];
        
        self.photo.center=CGPointMake(self.photo.center.x, 50);
        self.photo.backgroundColor = [UIColor grayColor];
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.clipsToBounds = YES;
        self.photo.frame=CGRectMake(15, 10, 60, 60);
        
        CALayer * ll = self.photo.layer;
        
        [ll setMasksToBounds:YES];
        [ll setCornerRadius:6.0];
        

        
        
        //名字
        self.UserName = [self addLabel:self.contentView
                                 frame:CGRectMake(80, 10, 200, 25)
                                  font:[UIFont systemFontOfSize:20]
                                  text:@""
                                 color:[UIColor blackColor]
                                   tag:0];
        
        self.UserName.shadowColor=[UIColor whiteColor];
        self.UserName.shadowOffset=CGSizeMake(0,1);
        

        //日期
        self.cdate = [self addLabel:self.contentView
                              frame:CGRectMake(212, 10, 100, 15)
                               font:[UIFont systemFontOfSize:12]
                               text:@"2013-05-06"
                              color:[UIColor grayColor]
                                tag:0];

        self.cdate.textAlignment=NSTextAlignmentRight;
        
        //最后得消息
        self.Msg = [self addLabel:self.contentView
                                 frame:CGRectMake(80, 30, 200, 30)
                                  font:[UIFont systemFontOfSize:14]
                                  text:@""
                                 color:[UIColor grayColor]
                                   tag:0];
        self.Msg.numberOfLines=2;


        
        //新消息数量图标
        self.qNum=[self addImageView:self.contentView
                               image:@"homePage_num.png"
                            position:CGPointMake(55, 5)];
        //self.qNum.hidden=YES;
        
        self.num=[self addLabel:qNum
                          frame:CGRectMake(0, 0, 0, 0)
                           font:[UIFont boldSystemFontOfSize:10]
                           text:@"0"
                          color:[UIColor whiteColor]
                            tag:1100];
        [self.num sizeToFit];
        
        
        CGRect f=self.qNum.frame;
        f=CGRectMake(f.origin.x,
                     f.origin.y,
                     22,
                     f.size.height);
        self.qNum.frame=f;
        
        self.num.center=CGPointMake(self.qNum.frame.size.width/2, self.qNum.frame.size.height/2-1);
    }
    return self;
}

-(void)setNewMessageNum:(int)n
{
    NSLog(@"setNewMessageNum:%d",n);
    
    n=n>99?99:n;
    
    if(n>0)
        self.qNum.hidden=NO;
    else
        self.qNum.hidden=YES;
    
    
    self.num.text=[NSString stringWithFormat:@"%d",n];
    
    [self.num sizeToFit];
    self.num.center=CGPointMake(self.qNum.frame.size.width/2, self.qNum.frame.size.height/2-1);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
