//
//  appointment_chat_view.m
//  yydr
//
//  Created by Li yi on 13-10-2.
//
//

#import "appointment_chat_view.h"

#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"
#import "UIImageView+WebCache.h"
#import "UIView+iTextManager.h"

#import "global.h"

@implementation appointment_chat_view

@synthesize AvatarImageView;
@synthesize msgDict;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.clipsToBounds=NO;
        
        self.backgroundColor=[UIColor clearColor];
        
        //对方泡泡
        bubble = [[UIImage imageNamed:@"messageBubbleGray"] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
        //自己得泡泡
        sbubble = [[UIImage imageNamed:@"messageBubbleBlue"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        
        self.AvatarImageView=[self addImageView:self
                                          image:@"temp_ava.jpg"
                                       position:CGPointMake(0, 0)];
        
        
        
        
        
    }
    return self;
}



-(void)loadMessage:(NSDictionary*)msg
{
    
    
    

    self.AvatarImageView.hidden=YES;
    
    msgDict=msg;
    
    type=[msgDict objectForKey:@"Type"];
    
    if([type isEqualToString:@"message"])
    {
        
        Msg=[msgDict objectForKey:@"Body"];
        Sender=[msgDict objectForKey:@"From"];
        sid=[[msgDict objectForKey:@"Sid"] integerValue];
        mid=[[msgDict objectForKey:@"Mid"] integerValue];
        
        //头像
        Avatar=[msgDict objectForKey:@"Avatar"];
        
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont systemFontOfSize:18.0], NSFontAttributeName,
                                                  nil];
            
            bubbleSize = [Msg boundingRectWithSize:CGSizeMake(ChatTextWidth, MAXFLOAT)
                                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                           attributes:attributesDictionary
                                              context:nil].size;
        }
        else
        {
            
            bubbleSize = [Msg sizeWithFont:[UIFont systemFontOfSize:18.f]
                         constrainedToSize:CGSizeMake(ChatTextWidth, MAXFLOAT)
                             lineBreakMode:NSLineBreakByWordWrapping];

        }
        

        //bubbleSize.height+=10;
        
        if(sid!=mid)
        {
            self.AvatarImageView.hidden=NO;
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,sid,Avatar]];
            [self.AvatarImageView setImageWithURL:url
                                 placeholderImage:[UIImage imageNamed:@"temp_ava.jpg"]];
            self.AvatarImageView.frame=CGRectMake(5,
                                                  bubbleSize.height-50+30,
                                                  self.AvatarImageView.frame.size.width,
                                                  self.AvatarImageView.frame.size.height);
        }
    }
    else
    {
        NSDate *nowDate=[NSDate date];
        NSDate *ld=[msg objectForKey:@"CreateDate"];
        
        NSTimeInterval seconds = [nowDate timeIntervalSinceDate:ld];
        
        //int hours=((int)seconds)%(3600*24)/3600;
        int days=((int)seconds)/(3600*24);
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if(days>1)
        {
            //n天以前
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            cdate = [dateFormatter stringFromDate:ld];
        }
        else if(days==1)
        {
            //昨天
            [dateFormatter setDateFormat:@"HH:mm"];
            cdate = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:ld]];
        }
        else
        {
            //今天
            [dateFormatter setDateFormat:@"HH:mm"];
            cdate = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:ld]];
        }
        
    }

    //fuck的地方
    self.frame=CGRectMake(0, 0, 320, bubbleSize.height+30+20);
    
    
    
    
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    iv.image=sbubble;
    
    [self addSubview:iv];
    
    
    
   // [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect
{
    
    if([type isEqualToString:@"message"])
    {
        int w = bubbleSize.width>10?bubbleSize.width:10;
        int h = bubbleSize.height>22?bubbleSize.height:22;
        
        if(sid==mid)
        {
            
        
            //自己发的～
            CGRect bubbleFrame=CGRectMake(320-w-ChatTextPaddingRight,
                                          0,
                                          w+ChatTextPaddingRight,
                                          h+ChatTextPaddingBottom);
            
            
            
            
            
            
            
            
            
            
            
            [sbubble drawInRect:bubbleFrame];
            
            CGRect textFrame = CGRectMake(320-w-ChatTextPaddingRight+10,
                                          8,
                                          w,
                                          h);
//            
//            [Msg drawInRect:textFrame
//                   withFont:[UIFont systemFontOfSize:18.f]
//              lineBreakMode:NSLineBreakByWordWrapping
//                  alignment:NSTextAlignmentLeft];
   
        }
        else
        {
            
            
            CGRect bubbleFrame=CGRectMake(ChatTextPaddingLeft,
                                          0,
                                          w+ChatTextPaddingRight,
                                          h+ChatTextPaddingBottom);
            
            [bubble drawInRect:bubbleFrame];
            
            CGRect textFrame = CGRectMake(ChatTextPaddingLeft+20,
                                          8,
                                          w,
                                          h);
            
            [Msg drawInRect:textFrame
                   withFont:[UIFont systemFontOfSize:18.f]
              lineBreakMode:NSLineBreakByWordWrapping
                  alignment:NSTextAlignmentLeft];
        }
        
    }
    else
    {
        //日期
        CGRect textFrame = CGRectMake(0,
                                      10,
                                      self.frame.size.width,
                                      self.frame.size.height);
        
        [cdate drawInRect:textFrame
                 withFont:[UIFont systemFontOfSize:12.f]
            lineBreakMode:NSLineBreakByWordWrapping
                alignment:NSTextAlignmentCenter];
    }
    
}


@end
