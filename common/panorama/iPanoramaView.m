//
//  iPanoramaView.m
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iPanoramaView.h"

@implementation iPanoramaView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor blackColor];
        
        WebView=[[UIWebView alloc] initWithFrame:frame];
        [WebView setUserInteractionEnabled:YES];
        [WebView setBackgroundColor:[UIColor blackColor]];
        
        [WebView setOpaque:YES];//使网页透明
        WebView.scalesPageToFit=YES;
        WebView.delegate=self;
        WebView.alpha=0;
        [self addSubview:WebView];
        
    
        
        skin=@"";
        skin_h=@"";
    }
    return self;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if([delegate conformsToProtocol:@protocol(iPanoramaViewDelegate)])
    {
         NSString *urlString = [[request URL] absoluteString];
        [delegate onHotDown:urlString];
    }
    return YES;
}



-(void)loadSkin:(NSString*)sk
{
    skin_h=[NSString stringWithFormat:@"<script type=\"text/javascript\" src=\"%@\"></script>",sk];
    skin=@"skin=new pano2vrSkin(pano);";
}


-(void)loadXML:(NSString*)xml
{

    NSString *html=[NSString stringWithFormat:@"<!DOCTYPE html><html>"\
                    "<head>"\
                    "<meta http-equiv=\"Content-Type\" content=\"text/html;charset=UTF-8\">"\
                    "<title></title>"\
                    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0\" />"\
                    "<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"\
                    "<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"\
                    "<script type=\"text/javascript\">"\
                    "function hideUrlBar() {"\
                    " if (window.pageYOffset==0) {window.scrollTo(0, 1);setTimeout(function() { hideUrlBar(); }, 3000);}}"\
                    "</script>"\
                    "</head>"\
                    "<style type=\"text/css\">"\
                    "body {"\
                    "background-color:#000000;"\
                    "margin-left: 0px;"\
                    "margin-top: 0px;"\
                    "margin-right: 0px;"\
                    "margin-bottom: 0px;}"\
                    "</style>"\
                    "<body onorientationchange=\"hideUrlBar();\">"\
                    //page
                    "<script type=\"text/javascript\" src=\"page.a\">"\
                    "</script>%@"\
                    
                    //skin
                    //"<script type=\"text/javascript\" src=\"skin.a\">"\
                    //"</script>"\
                    
                    "<script type=\"text/javascript\">"\
                    //宽 高
                    "document.writeln('<div id=\"container\" style=\"width:1024px;height:768px;\"></div>');"\
                    "pano=new pano2vrPlayer(\"container\");%@"\
                    
                    //提示:有热点 需加入 "skin=new pano2vrSkin(pano);" "skin=new ps(pano);"\
                    
                    //loadXML
                    "pano.readConfigUrl(\"%@\");"\
                    "hideUrlBar();"\
                    "</script>"\
                    "</body>"\
                    "</html>",skin_h,skin,xml];
    

    //从字符串导入
    [WebView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
 
     /*
    //从文件导入
     NSString *mainBundleDirectory = [[NSBundle mainBundle] bundlePath];
     NSString *path = [mainBundleDirectory  stringByAppendingPathComponent:@"1.html"];
     NSURL *url = [NSURL fileURLWithPath:path];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
     [WebView loadRequest:request];
     */
    
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
        WebView.alpha=0;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    [UIView animateWithDuration:.5
                     animations:^{
                         WebView.alpha=1;
                     }];
}


@end
