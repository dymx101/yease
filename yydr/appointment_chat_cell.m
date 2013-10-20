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
@synthesize chatText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        self.backgroundColor=[UIColor whiteColor];
        
        self.clipsToBounds=NO;

        
        //对方泡泡
        bubble = [[UIImage imageNamed:@"messageBubbleGray"] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
        bubbleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        bubbleView.image=bubble;
        [self.contentView addSubview:bubbleView];
        
        
        
        //自己得泡泡
        sbubble = [[UIImage imageNamed:@"messageBubbleBlue"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        sbubbleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        sbubbleView.image=sbubble;
        [self.contentView addSubview:sbubbleView];
        
        
        self.AvatarImageView=[self addImageView:self.contentView
                                          image:@"temp_ava.jpg"
                                       position:CGPointMake(0, 0)];
        
        
        self.chatText=[self addLabel:self.contentView
                               frame:CGRectMake(0, 0, 0, 0)
                                font:[UIFont systemFontOfSize:18.0]
                                text:@""
                               color:[UIColor whiteColor]
                                 tag:0];
        
        
    }
    return self;
}





-(void)loadMessage:(NSDictionary*)msg
{

    bubbleView.hidden=YES;
    sbubbleView.hidden=YES;

    self.AvatarImageView.hidden=YES;
    
    msgDict=msg;
    
    type=[msgDict objectForKey:@"Type"];
    
    if([type isEqualToString:@"message"])
    {
        
        Msg=[msgDict objectForKey:@"Body"];
        Sender=[msgDict objectForKey:@"From"];
        sid=[[msgDict objectForKey:@"Sid"] integerValue];
        mid=[[msgDict objectForKey:@"Mid"] integerValue];
        
    
        chatText.text=Msg;
        chatText.numberOfLines=0;
        chatText.textAlignment=NSTextAlignmentLeft;
        chatText.font=[UIFont systemFontOfSize:18.0];
        chatText.lineBreakMode = NSLineBreakByCharWrapping;
        
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


        float w = bubbleSize.width>10?bubbleSize.width:10;
        float h = bubbleSize.height>22?bubbleSize.height:22;

        
        
        
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
            
            CGRect bubbleFrame=CGRectMake(ChatTextPaddingLeft,
                                          0,
                                          w+ChatTextPaddingRight,
                                          h+ChatTextPaddingBottom);
            bubbleView.hidden=NO;
            bubbleView.frame=bubbleFrame;
            
            
            CGRect textFrame = CGRectMake(ChatTextPaddingLeft+20,
                                          8,
                                          w,
                                          h);

            chatText.frame=textFrame;
            chatText.textColor=[UIColor blackColor];
            

        }
        else
        {
            //自己发的～
            CGRect bubbleFrame=CGRectMake(320-w-ChatTextPaddingRight,
                                          0,
                                          w+ChatTextPaddingRight,
                                          h+ChatTextPaddingBottom);
            
            sbubbleView.hidden=NO;
            sbubbleView.frame=bubbleFrame;
         
            
            CGRect textFrame = CGRectMake(320-w-ChatTextPaddingRight+10,
                                          8,
                                          w,
                                          h);
            chatText.frame=textFrame;
            chatText.textColor=[UIColor whiteColor];
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

        
        self.chatText.text=cdate;
        self.chatText.numberOfLines=1;
        self.chatText.textAlignment=NSTextAlignmentCenter;
        self.chatText.textColor=[UIColor blackColor];
        self.chatText.font=[UIFont systemFontOfSize:12.0];
        self.chatText.frame=CGRectMake(0,0,320,30);
        
    }
    
    //fuck的地方
    //self.frame=CGRectMake(0, 0, 320, bubbleSize.height+30+20);
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
