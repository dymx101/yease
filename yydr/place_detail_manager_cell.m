//
//  place_detail_manager_cell.m
//  yydr
//
//  Created by Li yi on 13-6-9.
//
//

#import "place_detail_manager_cell.h"

#import "UIView+iButtonManager.h"
#import "UIView+iImageManager.h"
#import "UIView+iTextManager.h"

@implementation place_detail_manager_cell
@synthesize off;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIButton *bt=[self addButton:self
                               image:@"place_row.png"
                            position:CGPointMake(0, 0)
                                 tag:1002
                              target:self.superview
                              action:@selector(onDown:)];
        
        bt.userInteractionEnabled=YES;
        bt.center=CGPointMake(160, bt.center.y);
        
        
        [self addImageViewWithCenter:self
                               image:@"place_arrow.png"
                            position:CGPointMake(290, bt.center.y)];
        
        [self addLabel:bt
                 frame:CGRectMake(18, 15, 200, 20)
                  font: [UIFont boldSystemFontOfSize:18]
                  text:@"经理订位"
                 color:[UIColor blackColor]
                   tag:0];
        
        off=[self addLabel:bt
                     frame:CGRectMake(18, 42, 250, 20)
                      font: [UIFont systemFontOfSize:14]
                      text:@"原价水磨890、报小夜减100"
                     color:[UIColor colorWithRed:178.f/255.f green:0 blue:0 alpha:1]
                       tag:0];

    }
    return self;
}

-(void)loadManager:(int)pid
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
