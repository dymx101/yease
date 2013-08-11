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

@interface place_ablum : iViewController<UIScrollViewDelegate>
{
    UIScrollView *sv;
    
    NSArray *photoList;
    
    int PlaceId;
    int photoCount;
    int currentPageNum;
    float lastContentOffset;
    int sTag;
    
    ASIFormDataRequest *request;
}
@property (nonatomic,strong) ASIFormDataRequest *request;
@property (nonatomic,strong) UIScrollView *sv;

-(void)setPlaceId:(int)pid;

@end
