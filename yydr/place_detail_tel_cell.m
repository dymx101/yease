//
//  place_detail_tel_cell.m
//  yydr
//
//  Created by Li yi on 13-6-9.
//
//

#import "place_detail_tel_cell.h"
#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"
#import "UIView+iTextManager.h"

@implementation place_detail_tel_cell
@synthesize  tel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIButton *im=[self addButton:self
                          image:@"place_row_middle.png"
                       position:CGPointMake(0, 0)
                            tag:1000
                         target:self.superview
                         action:@selector(onDown:)];
        
        im.userInteractionEnabled=NO;
        
        im.center=CGPointMake(160, im.center.y);
        
        tel=  [self addLabel:im
                       frame:CGRectMake(40, 12, 250, 30)
                        font:[UIFont systemFontOfSize:14]
                        text:@"座机：暂无"
                       color:[UIColor blackColor]
                         tag:3001];
        
        tel.center=CGPointMake(tel.center.x, im.center.y);
        [self addImageViewWithCenter:im
                               image:@"tel_icon.png"
                            position:CGPointMake(25, im.center.y)];
        
        
        /*
        [self addImageViewWithCenter:self
                                    image:@"place_arrow.png"
                                 position:CGPointMake(290, im.center.y)];
        */
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
