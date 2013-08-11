//
//  girl_chat_cell.m
//  yydr
//
//  Created by liyi on 13-4-25.
//
//

#import "appointment_chat_cell.h"

#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"
#import "UIImageView+WebCache.h"
#import "UIView+iTextManager.h"

#import "global.h"

@implementation appointment_chat_cell

@synthesize AvatarImageView;
@synthesize msgDict;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor grayColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
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
        
        bubbleSize = [Msg sizeWithFont:[UIFont systemFontOfSize:18.f]
                     constrainedToSize:CGSizeMake(ChatTextWidth, MAXFLOAT)
                         lineBreakMode:UILineBreakModeWordWrap];
        
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
    
    [self setNeedsDisplay];
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
            
            [Msg drawInRect:textFrame
                   withFont:[UIFont systemFontOfSize:18.f]
              lineBreakMode:NSLineBreakByWordWrapping
                  alignment:NSTextAlignmentLeft];
            
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
                                      self.contentView.frame.size.width,
                                      self.contentView.frame.size.height);
        
        [cdate drawInRect:textFrame
                 withFont:[UIFont systemFontOfSize:12.f]
            lineBreakMode:NSLineBreakByWordWrapping
                alignment:NSTextAlignmentCenter];
    }
    
}

-(void)onDown:(UIButton*)sender
{
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
