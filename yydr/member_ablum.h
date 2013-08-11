//
//  place_ablum.h
//  yydr
//
//  Created by liyi on 13-1-6.
//
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "iViewController.h"

@interface member_ablum : iViewController<UIScrollViewDelegate>
{
    UIScrollView *sv;
    
    NSMutableArray *photoList;

    int photoCount;
    int currentPageNum;
    float lastContentOffset;
    int sTag;
    int UserId;

}
@property (nonatomic,strong) UIScrollView *sv;

-(void)loadUserPhotoList:(NSMutableArray*)up PageIndex:(int)pi;
@end
