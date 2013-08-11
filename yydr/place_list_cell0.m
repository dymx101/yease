//
//  place_list_cell0.m
//  yydr
//
//  Created by Li yi on 13-6-10.
//
//

#import "place_list_cell0.h"
#import "UIView+iButtonManager.h"
#import "UIView+iImageManager.h"
#import "UIView+iTextManager.h"

@implementation place_list_cell0

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        sv=[self addScrollView:self
                      delegate:self
                         frame:CGRectMake(0, 0, 320, 100)
                       bounces:NO
                          page:YES
                         showH:NO
                         showV:NO];
    
        sv.backgroundColor=[UIColor grayColor];
        
        
        
        
        for (int i=0; i<2; i++) {
            
            UIImageView *im=[self addImageView:sv
                                         image:@"adv_0.png"
                                      position:CGPointMake(0, 0)];
            
            im.frame=CGRectMake(i*320, 0, 320, 100);
            im.contentMode=UIViewContentModeScaleAspectFit;
        }
        
        
        pc = [self addPageControl:self point:CGPointMake(160, 90)];
        pc.numberOfPages=2;
        pc.currentPage=0;
        
        sv.contentSize=CGSizeMake(320*2, 0);
        
         
    }
    return self;
}





-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pc.currentPage=scrollView.contentOffset.x/320;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
