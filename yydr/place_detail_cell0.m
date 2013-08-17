//
//  place_detail_cell0.m
//  yydr
//
//  Created by Li yi on 13-6-9.
//
//

#import "place_detail_cell0.h"

#import "UIView+iImageManager.h"
#import "UIView+iTextManager.h"
#import "UIView+iButtonManager.h"

@implementation place_detail_cell0

@synthesize photo;
@synthesize placename;
@synthesize commentcount;
@synthesize star;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)loadPhoto:(int)h
{    
    //照片显示
    
    if(h>0)
    {
        
        photo=[self addImageView:self
                           image:@"noPhotoBig.png"
                        position:CGPointMake(0, 0)];
        
    
        photo.frame=CGRectMake(0, 0, 320, h);
        photo.contentMode=UIViewContentModeScaleAspectFill;
        photo.clipsToBounds=YES;
        
        photo.userInteractionEnabled=YES;
        
        
        //照片上黑条
        UIView *bi=[[UIView alloc] initWithFrame:CGRectMake(0, h-25, 320, 25)];
        bi.backgroundColor = [UIColor blackColor];
        bi.alpha=.6;
        [photo addSubview:bi];
        
        UILabel *tt=[self addLabel:photo
                             frame:CGRectMake(0, 0, 10, 25)
                              font:[UIFont systemFontOfSize:13]
                              text:@"点击查看更多"
                             color:[UIColor whiteColor]
                               tag:1111];
        [tt sizeToFit];
        tt.center=bi.center;

        
    }
    

    //内容
    UIImageView *bg=[self addImageView:self
                                 image:@"place_row_0.png"
                              position:CGPointMake(0, h)];
    
    bg.userInteractionEnabled=YES;
    
    placename=[self addLabel:bg
                       frame:CGRectMake(10, 5, 300, 30)
                        font:[UIFont systemFontOfSize:20]
                        text:@""
                       color:[UIColor blackColor]
                         tag:0];
    
    placename.shadowColor=[UIColor whiteColor];
    placename.shadowOffset=CGSizeMake(0, 1);
    
    
    //上传照片按钮
    UIButton *photobt=[self addButton:bg
                                image:@"place_photo_upload.png"
                             position:CGPointMake(218, 5)
                                  tag:2001
                               target:self.superview
                               action:@selector(onDown:)];
    
    photobt.center=CGPointMake(photobt.center.x, 37);
    
    UILabel *n=[self addLabel:photobt
                        frame:CGRectMake(32, 0, 50, 25)
                         font:[UIFont boldSystemFontOfSize:12]
                         text:@"上传照片"
                        color:[UIColor blackColor] tag:0];
    
    n.center=CGPointMake(n.center.x, 15);
    

    //星星
    star=[self addImageView:bg
                      image:@"star_0.png"
                   position:CGPointMake(10, 35)];
    
    commentcount=[self addLabel:bg
                          frame:CGRectMake(100, 31, 100, 25)
                           font:[UIFont systemFontOfSize:12]
                           text:@"0人体验"
                          color:[UIColor grayColor]
                            tag:1003];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
