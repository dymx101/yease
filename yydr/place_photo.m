//
//  place_photo.m
//  yydr
//
//  Created by liyi on 13-1-9.
//
//

#import "place_photo.h"
#import "UIImageView+WebCache.h"

@implementation place_photo
@synthesize photo;
@synthesize HUD;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.photo=[[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.photo];
        self.photo.contentMode= UIViewContentModeScaleAspectFit;
        
        HUD = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:HUD];

        HUD.mode = MBProgressHUDModeDeterminate;
        //HUD.labelText = @"图片加载中...";
    }
    return self;
}


-(void)loadPhoto:(NSURL*)url
{
    NSLog(@"loadPhoto:%@",url);
    
    [self.HUD show:YES];
    
    
    
    //弱引用
    __block place_photo *blockSelf = self;
    
    [self.photo setImageWithURL:url
               placeholderImage:nil
                        options:SDWebImageRetryFailed //SDWebImageProgressiveDownload
                       progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         [blockSelf HUD].progress = (float)receivedSize/expectedSize;
     }
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         NSLog(@"加载完毕");
         [[blockSelf HUD] hide:NO];
     }];

}

-(void)unloadCurrentPage
{
    [self.photo cancelCurrentImageLoad];
    self.photo.image=nil;
    [HUD hide:NO];
}

@end
