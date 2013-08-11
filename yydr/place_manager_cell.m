//
//  place_tel_cell.m
//  yydr
//
//  Created by liyi on 13-2-15.
//
//

#import "place_manager_cell.h"
#import "UILabelStrikeThrough.h"

@implementation place_manager_cell


@synthesize tel;
@synthesize info;
@synthesize off;
@synthesize name;
@synthesize dbt;
@synthesize avatar;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        
        UIImageView *im=[self addImageView:self
                                     image:@"place_tel_bg.png"
                                  position:CGPointMake(0, 0)];
        
        im.center=CGPointMake(160, im.center.y);
        
        
        //头像

        
        avatar = [self addImageView:self
                              image:@"noAvatar.png"
                           position:CGPointMake(0, 0)];
        
        avatar.contentMode= UIViewContentModeScaleToFill;
        avatar.frame=CGRectMake(18, 21, 60, 60);
        
        //名字
        name=[self addLabel:self
                      frame:CGRectMake(90, 21, 150, 30)
                       font:[UIFont boldSystemFontOfSize:20]
                       text:@"暂无"
                      color:[UIColor blackColor]
                        tag:0];
        name.shadowColor=[UIColor whiteColor];
        name.shadowOffset=CGSizeMake(0, 1);
        
        
        
        off=[self addLabel:self
                     frame:CGRectMake(90, 55, 150, 22)
                      font:[UIFont boldSystemFontOfSize:14]
                      text:@""
                     color:[UIColor colorWithRed:178.f/255.f green:0 blue:0 alpha:1]
                       tag:0];
        
        /*
         //客户经理图标
         UIImageView *ke=[self addImageView:self.contentView
         image:@"ke_icon.png"
         position:CGPointMake(15, 52)];
         
         UILabel *ke_t= [self addLabel:ke
         frame:CGRectMake(0, 0, 10, 20)
         font:[UIFont boldSystemFontOfSize:12]
         text:@"经"
         color:[UIColor whiteColor]
         tag:0];
         [ke_t sizeToFit];
         ke_t.center=CGPointMake(ke.frame.size.width/2, ke.frame.size.height/2);
         */
        
        
        //拨号按钮
        dbt=[self addButton:self
                      image:@"place_tel_bt.png"
                   position:CGPointMake(250, 25)
                        tag:0
                     target:self.superview
                     action:@selector(onCallDown:)];
        
        
        info=[self addLabel:self
                      frame:CGRectMake(80, 68, 150, 30)
                       font:[UIFont systemFontOfSize:12]
                       text:@""
                      color:[UIColor blackColor]
                        tag:0];
        info.hidden=YES;
        info.numberOfLines=2;
    }
    return self;
}



@end
