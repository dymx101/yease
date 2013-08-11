//
//  iPanoramaView.h
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPageView.h"

@protocol iPanoramaViewDelegate;

@interface iPanoramaView : iPageView<UIWebViewDelegate>
{
    
    id<iPanoramaViewDelegate> delegate;
    
    UIWebView *WebView;
    NSString *skin_h,*skin;
    
}

@property (nonatomic,strong) id<iPanoramaViewDelegate> delegate;

-(void)loadXML:(NSString*)xml;
-(void)loadSkin:(NSString*)sk;
@end

//-----
@protocol iPanoramaViewDelegate <NSObject>

@optional
    -(void)onHotDown:(NSString*)flag;
@end

