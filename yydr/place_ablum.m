//
//  place_ablum.m
//  yydr
//
//  Created by liyi on 13-1-6.
//
//

#import "place_ablum.h"
#import "place_photo.h"

#import "UIView+iImageManager.h"
#import "UIImageView+WebCache.h"
#import "global.h"
#import "iPageView.h"
#import "UIView+GetRequestCookie.h"
#import "login.h"

#define LEFT -1
#define RIGHT 1
#define MIDDLE 0

@interface place_ablum ()

@end

@implementation place_ablum

@synthesize request;
@synthesize sv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor=[UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    }
    return self;
}


-(void)setPlaceId:(int)pid
{
    PlaceId=pid;
}


-(void)loadPhoto
{
    //请求获得照片
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@PlacePhoto?pid=%d",ServerURL,PlaceId]];
    NSLog(@"%@",url);
    self.request=nil;
    self.request = [ASIFormDataRequest requestWithURL:url];
    self.request.timeOutSeconds=TIMEOUT;
    [self.request setDelegate:self];
    
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    
    if(ck!=nil)
    {
        [self.request setUseCookiePersistence:NO];
        [self.request setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    }
    
    [self.request setRequestMethod:@"GET"];
    [self.request startAsynchronous];
}

//请求回调 ---------------------------------------------------------------------------------------------------
- (void)requestFailed:(ASIHTTPRequest *)r
{
    
    NSLog(@"place_ablum:requestFailed:%@",r);
    
    int statusCode=[r responseStatusCode];
    switch (statusCode) {
        case 401:
        {
            [[NSUserDefaults standardUserDefaults] setObject:nil
                                                      forKey:@"Value"];
            //去登入
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
            break;
            
        default:
        {
            //跳出提示
            MBProgressHUD *AlertHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:AlertHUD];
            AlertHUD.labelText = ConnectionFailure;
            AlertHUD.mode = MBProgressHUDModeCustomView;
            AlertHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert"]];
            [AlertHUD show:YES];
            [AlertHUD hide:YES afterDelay:1.5];
        }
            break;
    }
    
    //停止查询
    [r clearDelegatesAndCancel];
    r=nil;
}



- (void)requestFinished:(ASIHTTPRequest *)r
{
    // Use when fetching text data
    NSString *responseString = [r responseString];
    
    // Use when fetching binary data
    NSData *jsonData = [r responseData];
        
    NSLog(@"%@",responseString);

    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];

    photoList=(NSArray*)jsonObject;

    photoCount=[photoList count];
    
    
    int off=0;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        off=20;
    }

    
    sv.contentSize=CGSizeMake(sv.frame.size.width*photoCount, sv.frame.size.height-off);
    sTag=50000;
    
    self.title=[NSString stringWithFormat:@"1/%d",photoCount];
    
    for(int i=0;i<photoCount;i++)
    {
        place_photo *p=[[place_photo alloc] initWithFrame:CGRectMake(sv.frame.size.width*i, 0, sv.frame.size.width, sv.frame.size.height)];
        p.tag=sTag+i;
        [sv addSubview:p];
    }
    
    [self load:0];
    
    if (photoCount>1) {
        [self load:1];
    }
    
}

//---------------------------------------------------------------------------------------------------------
//添加页
-(void) load:(int)i
{
    NSLog(@"加载图片");
    place_photo *p=(place_photo*)[sv viewWithTag:sTag+i];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",PlacePhotoURL,PlaceId,[[photoList objectAtIndex:i] objectForKey:@"Path"]]];

    [p loadPhoto:url];
}

//---------------------------------------------------------------------------------------------------------
//删除页
-(void) removePage:(int)i
{
	NSLog(@"删除第%d页",i);
    
    iPageView *p=(iPageView*)[sv viewWithTag:sTag+i];
    [p unloadCurrentPage];
}

//---------------------------------------------------------------------------------------------------------
//滚动中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	int scrollDirection;
	int dragDirection;
    
    //判断拖动方向
    if (lastContentOffset > scrollView.contentOffset.x)
        dragDirection = RIGHT;
    else if (lastContentOffset < scrollView.contentOffset.x)
        dragDirection = LEFT;
    
	scrollDirection=lastContentOffset-scrollView.contentOffset.x;
	lastContentOffset = scrollView.contentOffset.x;
    
    //拖动到位
    //if ((int)scrollView.contentOffset.x%(int)(sv.frame.size.width)==0)
    {
		int co=(int)scrollView.contentOffset.x/sv.frame.size.width;

        self.title=[NSString stringWithFormat:@"%d/%d",co+1,photoCount];
        
        //NSLog(@"scrollViewDidScroll|当前第%d页",currentPageNum);
        
        if (co>currentPageNum) {
            
			currentPageNum=co;

			//添加后一页
			if(currentPageNum+1<[photoList count])
			{
				[self load:currentPageNum+1];
			}
			
			//删除前一页
			if(currentPageNum-2>=0)
			{
				[self removePage:currentPageNum-2];
			}
		}
		
		if (co<currentPageNum)
		{
			currentPageNum=co;
            
			//添加前一页
			if(currentPageNum-1>=0)
			{
				[self load:currentPageNum-1];
			}
			
			//删除后一页
			if(currentPageNum+2<[photoList count])
			{
				[self removePage:currentPageNum+2];
			}
		}
	}
}


-(void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.navigationItem.leftBarButtonItem= [self.view add_back_button:@selector(onBack:)
                                                               target:self];
    
    self.sv=[self.view addScrollView:self.view
                            delegate:self
                               frame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44)
                             bounces:YES
                                page:YES
                               showH:NO
                               showV:NO];
    
    currentPageNum=0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadPhoto];
}


-(void)dealloc
{
    [self.request clearDelegatesAndCancel];
    self.request=nil;
}


-(void)viewDidUnload
{
    self.sv=nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
