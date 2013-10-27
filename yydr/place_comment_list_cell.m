//
//  place_comment_list_cell.m
//  yydr
//
//  Created by liyi on 13-1-4.
//
//

#import "place_comment_list_cell.h"
#import "UIView+iImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIView+iTextManager.h"
#import <QuartzCore/QuartzCore.h>
#import "global.h"

@implementation place_comment_list_cell

@synthesize name;
@synthesize comment;
@synthesize price;
@synthesize recommend;
@synthesize date;

@synthesize Avatar;
@synthesize rating;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        //UIImage *bgIm = [UIImage imageNamed:@"place_cell_bg.jpg"];
        //UIImageView *bg = [[UIImageView alloc] initWithImage:[bgIm stretchableImageWithLeftCapWidth:20 topCapHeight:14]];
        //self.backgroundView=bg;
        
    
        
        
        
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        //头像
        self.Avatar =[self addImageView:self.contentView
                                  image:@"noAvatar.png"
                               position:CGPointMake(10, 10)];
        
        self.Avatar.center=CGPointMake(self.Avatar.center.x, 50);
        self.Avatar.backgroundColor = [UIColor grayColor];
        self.Avatar.contentMode = UIViewContentModeScaleAspectFill;
        self.Avatar.clipsToBounds = YES;
        self.Avatar.frame=CGRectMake(10, 7, 40, 40);
        
        CALayer * ll = self.Avatar.layer;
        
        [ll setMasksToBounds:YES];
        [ll setCornerRadius:6.0];

        
        //名字
        name = [self addLabel:self.contentView
                        frame:CGRectMake(10+50, 5, 200, 25)
                         font:[UIFont systemFontOfSize:16]
                         text:@""
                        color:[UIColor blackColor]
                          tag:0];
        
        name.textAlignment=UITextAlignmentLeft;


        
        rating=[self addImageView:self.contentView
                            image:@"star_1.png"
                         position:CGPointMake(10+50, 30)];
        
        
        
        UIColor *f=[UIColor blackColor];//[UIColor colorWithRed:0/255.0 green:105/255.0 blue:140/255.0 alpha:1];
               
        
        //花费
        price = [self addLabel:self.contentView
                         frame:CGRectMake(100+50, 26, 80, 25)
                          font:[UIFont systemFontOfSize:12]
                          text:@"¥99999"
                         color:f
                           tag:0];

        
        //推荐
        recommend = [self addLabel:self.contentView
                             frame:CGRectMake(200, 26, 200, 25)
                              font:[UIFont systemFontOfSize:12]
                              text:@"推荐：200"
                             color:f
                               tag:0];


        
        
        //评论内容
        comment = [self addLabel:self.contentView
                           frame:CGRectMake(0, 0, 300, 0)
                            font:[UIFont systemFontOfSize:15]
                            text:@""
                           color:[UIColor blackColor]
                             tag:0];

        comment.lineBreakMode = UILineBreakModeWordWrap;
        comment.numberOfLines = 0;
        
        
        //日期
        date = [self addLabel:self.contentView
                        frame:CGRectMake(10,0, 200, 25)
                         font:[UIFont systemFontOfSize:12]
                         text:@""
                        color:[UIColor grayColor]
                          tag:0];
        
        
        line=[self addImageView:self.contentView
                          image:@"place_comment_line.jpg"
                       position:CGPointMake(0, 0)];
        
    }
    return self;
}

-(void)loadCommentDetail:(NSDictionary*)cd Height:(int)height
{
    
    NSLog(@"place_detail_comment_cell:%@",cd);
    

    line.center=CGPointMake(160, height);
    
    
    NSString *FileName=[cd objectForKey:@"Avatar"];
    int uid= [[cd objectForKey:@"UserId"] integerValue];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,uid,FileName]];
    
    
    [self.Avatar setImageWithURL:url
                placeholderImage:[UIImage imageNamed:@"noAvatar.png"]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                      
                       }];
    
    //名字
    self.name.text=[cd objectForKey:@"UserName"];
    
    
    //花费
    self.price.text=[NSString stringWithFormat:@"¥%@",[cd objectForKey:@"Spend"]];
    
    
    //推荐
    id str=[cd objectForKey:@"Recommend"];
    
    if( [str isKindOfClass:[NSNull class]] || !str)
    {
        self.recommend.hidden = YES;
    }
    else
    {
        self.recommend.text=[NSString stringWithFormat:@"推荐：%@",str];
        self.recommend.hidden = NO;
    }

    //星星
    int star =[[cd objectForKey:@"Evaluation"] integerValue];
    self.rating.image=[UIImage imageNamed:[NSString stringWithFormat:@"star_%d.png",star]];

    //评论
    self.comment.frame=CGRectMake(10, 55, 300, 0);
    self.comment.text=[cd objectForKey:@"Comment"];
    [self.comment sizeToFit];
    
    //日期
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ss"];
    
    NSDate* cdate = [dateFormatter dateFromString:[[cd objectForKey:@"CreateDate"] substringToIndex:19]];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd HH:mm"];
    
    self.date.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:cdate]];
    self.date.center=CGPointMake(self.date.center.x,  height-10);
    

}

@end
