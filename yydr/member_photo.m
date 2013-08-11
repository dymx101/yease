//
//  member_photo.m
//  yydr
//
//  Created by Li yi on 13-5-26.
//
//

#import "member_photo.h"

#import "UIView+iImageManager.h"
#import "UIImageView+WebCache.h"

@implementation member_photo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        im=[self addImageView:self
                              image:@"member_photo_lock.png"
                           position:CGPointMake(0, 0)];
        im.frame=CGRectMake(0, 0, 50, 50);
        im.contentMode = UIViewContentModeScaleAspectFill;
        im.clipsToBounds=YES;
        
        
        lock=[self addImageView:self
                          image:@"member_photo_lock.png"
                       position:CGPointMake(0, 0)];
        lock.hidden=YES;
        lock.frame=CGRectMake(0, 0, 50, 50);
    }
    return self;
}


-(void)loadImage:(NSURL*)url Lock:(int)l
{
    [im setImageWithURL:url
             placeholderImage:[UIImage imageNamed:@"noPhoto_ye.png"]
                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                        
                    }];
    
    if (l>0) {
        lock.hidden=NO;
    }
    
}

@end
