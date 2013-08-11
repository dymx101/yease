//
//  girl_list_cell.m
//  yydr
//
//  Created by liyi on 13-4-19.
//
//

#import "appointment_member_list_cell.h"

#import "UIView+iAnimationManager.h"
#import "UIView+iImageManager.h"
#import "UIView+iTextManager.h"


@implementation appointment_member_list_cell

@synthesize Avatar;
@synthesize Signature;
@synthesize UserName;
@synthesize Distance;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundView=[self addImageView:nil
                                         image:@"member_cell_bg.png"
                                      position:CGPointMake(0, 0)];
        
        


        
        //头像
        self.Avatar =[self addImageView:self.contentView
                                 image:@"noAvatar.png"
                              position:CGPointMake(10, 10)];

        self.Avatar.center=CGPointMake(self.Avatar.center.x, 50);
        self.Avatar.backgroundColor = [UIColor grayColor];
        self.Avatar.contentMode = UIViewContentModeScaleAspectFill;
        self.Avatar.clipsToBounds = YES;
        self.Avatar.frame=CGRectMake(10, 10, 60, 60);
        
        CALayer * ll = self.Avatar.layer;
        
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

        //签名
        self.Signature = [self addLabel:self.contentView
                                 frame:CGRectMake(80, 10, 200, 0)
                                  font:[UIFont systemFontOfSize:14]
                                  text:@"从不放弃从不放弃从不放弃从不放弃从不放弃从不放弃从不放弃从不放弃从不放弃从不放弃从不放弃从不放弃"
                                 color:[UIColor grayColor]
                                   tag:0];
        
        self.Signature.numberOfLines=2;

        //距离
        self.Distance=[self addLabel:self.contentView
                               frame:CGRectMake(242, 10, 70, 15)
                                font:[UIFont systemFontOfSize:12]
                                text:@"1000m"
                               color:[UIColor grayColor]
                                 tag:0];

        self.Distance.textAlignment = UITextAlignmentRight;
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end