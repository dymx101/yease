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
#import "UIImageView+WebCache.h"

#import "global.h"
@implementation place_list_cell0
@synthesize advDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code    
         
    }
    return self;
}


-(void)loadPlaceAdv:(NSArray*)pl
{
    
    sv=[self addScrollView:self
                  delegate:self
                     frame:CGRectMake(0, 0, 320, 100)
                   bounces:NO
                      page:YES
                     showH:NO
                     showV:NO];
    
    sv.backgroundColor=[UIColor blackColor];
    
    
    for (int i=0; i<[pl count]; i++) {

        
        UIImageView *im=[self addImageView:sv
                                     image:@"adv_0.png"
                                  position:CGPointMake(0, 0)];
        
        NSString *path=[[pl objectAtIndex:i] objectForKey:@"BannerPath"];
        
     
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AdvPhotoURL,path]];
        
        [im setImageWithURL:url
           placeholderImage:[UIImage imageNamed:@"noPhoto.png"]];

        im.frame=CGRectMake(i*320, 0, 320, 100);
        im.contentMode=UIViewContentModeScaleAspectFit;
        

        [self addTapEvent:im
                   target:self
                   action:@selector(onTap:)];
        
    }
    
    
    pc = [self addPageControl:self point:CGPointMake(160, 90)];
    pc.numberOfPages=[pl count];
    pc.currentPage=0;
    
    sv.contentSize=CGSizeMake(320*[pl count], 0);
 
}


-(void)onTap:(id)sender
{
    [advDelegate AdvSelected:sv.contentOffset.x/320];
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
