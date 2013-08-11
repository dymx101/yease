//
//  place_detail_comment_cell.m
//  yydr
//
//  Created by Li yi on 13-6-9.
//
//

#import "place_detail_comment_cell.h"
#import "UIView+iTextManager.h"
#import "UIView+iButtonManager.h"

@implementation place_detail_comment_cell
@synthesize commentcount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        commentcount= [self addLabel:self
                             frame:CGRectMake(10, 5, 300, 30)
                              font:[UIFont systemFontOfSize:20]
                              text:@""
                             color:[UIColor blackColor]
                               tag:1003];
        
        commentcount.center=CGPointMake(commentcount.center.x, 30);
        
        
        //添加评论按钮
        commentbt=[self addButton:self
                            image:@"place_comment_add.png"
                         position:CGPointMake(218, 5)
                              tag:2000
                           target:self.superview
                           action:@selector(onDown:)];
        
        commentbt.center=CGPointMake(commentbt.center.x, 30);
        
        UILabel *n=[self addLabel:commentbt
                            frame:CGRectMake(32, 0, 50, 25)
                             font:[UIFont boldSystemFontOfSize:12]
                             text:@"体验分享"
                            color:[UIColor blackColor] tag:0];
        
        n.center=CGPointMake(n.center.x, 15);
        
        //commentcount.shadowColor=[UIColor whiteColor];
        //commentcount.shadowOffset=CGSizeMake(0, 1);
        
    }
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
