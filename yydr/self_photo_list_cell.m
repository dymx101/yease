//
//  self_photo_list_cell.m
//  yydr
//
//  Created by liyi on 13-5-23.
//
//

#import "self_photo_list_cell.h"
#import "global.h"

#import "member_ablum.h"

#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"

#import "UIButton+WebCache.h"



@implementation self_photo_list_cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        pf=[UIImage imageNamed:@"member_photoframe.png"];
        
        
        
        for(int i=0;i<3;i++)
        {
            UIButton *bt=[self addButton:self
                                   image:@"member_photo_loading.png"
                                position:CGPointMake(10+105*i, 10)
                                     tag:1000+i
                                  target:self.superview
                                  action:@selector(onTap:)];
            
            bt.imageView.contentMode = UIViewContentModeScaleAspectFill;
            bt.imageView.clipsToBounds=YES;
            bt.hidden=YES;
        }
        
    }
    return self;
}



-(void)loadPhoto:(NSMutableArray*)pg StartTag:(int)t
{
    PhotoGroup=pg;

    for(int i=0;i<[PhotoGroup count];i++)
    {
        NSDictionary *pd=[PhotoGroup objectAtIndex:i];
        
        int UserId=[[pd objectForKey:@"UserId"] integerValue];
        NSString *FileName=[pd objectForKey:@"Path"];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/thumb_%@",UserPhotoURL,UserId,FileName]];

        UIButton *bt=(UIButton*)[self viewWithTag:1000+i];
       
        
        [bt setImageWithURL:url
                   forState:UIControlStateNormal
           placeholderImage:[UIImage imageNamed:@"noPhoto_ye.png"]];
        
        bt.tag=bt.tag+t;
         
        bt.hidden=NO;
        
    }
}


-(void)drawRect:(CGRect)rect
{
    
    for(int i=0;i<[PhotoGroup count];i++)
    {
        CGRect photoFrame=CGRectMake(5+105*i,
                                     5,
                                     100,
                                     100);
        [pf drawInRect:photoFrame];
    }
    
}


@end
