//
//  place_ablum.m
//  yydr
//
//  Created by liyi on 13-1-6.
//
//

#import "member_ablum.h"
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

@interface member_ablum ()

@end

@implementation member_ablum

@synthesize sv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=[UIColor blackColor];
        
    }
    return self;
}


-(void)loadUserPhotoList:(NSMutableArray*)up PageIndex:(int)pi
{
    
    photoList=[up mutableCopy];
    
    //NSLog(@"%@",photoList);
    
    
    photoCount=[photoList count];
    
    UserId = [[[up objectAtIndex:0] objectForKey:@"UserId"] integerValue];
    
    sv.contentSize=CGSizeMake(sv.frame.size.width*photoCount, sv.frame.size.height);
    sTag=50000;
    
    self.title=[NSString stringWithFormat:@"1/%d",photoCount];
    
    for(int i=0;i<photoCount;i++)
    {
        place_photo *p=[[place_photo alloc] initWithFrame:CGRectMake(sv.frame.size.width*i,
                                                                     0,
                                                                     sv.frame.size.width,
                                                                     sv.frame.size.height)];
        p.tag=sTag+i;
        [sv addSubview:p];
    }

    
    //加载当前页
    [self load:pi];
    
    //前一页
    if (pi>0) {
        [self load:pi-1];
    }
    
    //后一页
    if(pi<[photoList count]-1)
    {
       [self load:pi+1];
    }
    
    [sv setContentOffset:CGPointMake(sv.frame.size.width*pi, 0)];
    
}


//---------------------------------------------------------------------------------------------------------
//添加页
-(void) load:(int)i
{
    NSLog(@"加载图片");
    place_photo *p=(place_photo*)[sv viewWithTag:sTag+i];

    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,UserId,[[photoList objectAtIndex:i] objectForKey:@"Path"]]];

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


-(void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidUnload
{
    self.sv=nil;
    photoList=nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
