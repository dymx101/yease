//
//  iHSVImagePage.h
//  dalian
//
//  Created by 毅 李 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPageView.h"

@interface iSVImagePage : iPageView<UIScrollViewDelegate>
{
    UIScrollView *ssv;
    UIImageView *im;
    
    float maxScale;
    float minScale;
}
-(void)load:(NSString*)image maxScale:(float)m minScale:(float)s;
-(void)autoLoad:(NSString*)image;
@end
