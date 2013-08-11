//
//  iVScrollView.m
//  test
//
//  Created by 毅 李 on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iVScrollView.h"
#import "iPageView.h"
#import "iSVImagePage.h"


@implementation iVScrollView

@synthesize hsvdelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.contentSize = CGSizeMake(frame.size.width , frame.size.height);
        self.pagingEnabled=YES;
        self.bounces=NO;
        self.delegate=self;
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
        
        currentPageNum=0;
        
        pc=[[UIPageControl alloc] init];
        pc.center=CGPointMake(frame.size.width/2, -100);
        pc.currentPage=0;
        
        //默认
        maxScale=1;
        minScale=1;
        
        autoScale=NO;
    }
    return self;
}

-(void)setZoomAutoScale
{
    autoScale=YES;
}


-(void)showPageControl:(CGPoint)_p
{
    pc.center=_p;
    [self.superview addSubview:pc];
}


-(void)initWithArray:(NSMutableArray*)_a
{
    sTag=600;
    
    pageList=_a;
    self.contentSize=CGSizeMake(self.frame.size.width, self.frame.size.height*[pageList count]);
    
    pc.numberOfPages=[_a count];
}

//---------------------------------------------------------------------------------------------------------
//跳转页
-(void) jumpToPage:(int) cn command:(int) cmd
{
    NSLog(@"jumpToPage=%d currentPageNum=%d",cn,currentPageNum);
    
    currentPageNum=cn;//!!!importent
    [self setContentOffset:CGPointMake(0,cn*self.frame.size.height)];
    
    //是否正在看当前页
    // if (currentPageNum!=cn) 
    {
        
        for(int i=0;i<[pageList count];i++)
        {
            [self removePage:i];
        }
        
        //添加当前页
        [self addPage:cn direction:MIDDLE command:cmd];
        
        //添加前一页
        if(cn>0)
        {
            [self addPage:cn-1 direction:LEFT command:cmd];
        }
        //添加后一页
        if(cn<[pageList count]-1)
        {
            [self addPage:cn+1 direction:RIGHT command:cmd];
        }
        
    }      
    
}

//---------------------------------------------------------------------------------------------------------
//添加图片页
-(void) loadImage:(NSString*)fn type:(NSString*)t 
{
    sTag=700;
    
    pageList=[NSMutableArray new];
    
    for(int i=0;i<10000;i++)
    {
        UIImage *im=[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.%@",fn,i,t]];
        
        NSLog(@"%d",i);
        
        if(im==nil)
        {
            pc.numberOfPages=i;
            self.contentSize=CGSizeMake(self.frame.size.width, self.frame.size.height*i);
            break;
        }
        
        [pageList addObject:[NSString stringWithFormat:@"%@%d.%@",fn,i,t]];
    }
}

//---------------------------------------------------------------------------------------------------------
-(void) setZoomMaxScale:(float)ms MinScale:(float)ss
{
    maxScale=ms;
    minScale=ss;
}


//---------------------------------------------------------------------------------------------------------
//添加页
-(void) addPage:(int) i direction:(int) d command:(int) cmd
{	
	NSString *cn = [NSString stringWithFormat:@"%@",[pageList objectAtIndex:i]];
    NSLog(@"添加第%d页 方向:%d 哪一页:%@",i,d,cn);
      
    iPageView *p;
    
    if(sTag==600)
    {
        NSLog(@"添加page类");
        p=[[NSClassFromString(cn) alloc] initWithFrame:CGRectMake(0, self.frame.size.height*i, self.frame.size.width, self.frame.size.height)];
        [self insertSubview:p atIndex:0];
    }
    else 
    {
        NSLog(@"添加图片");
        p=[[iSVImagePage alloc] initWithFrame:CGRectMake(0, self.frame.size.height*i, self.frame.size.width, self.frame.size.height)];
        [self insertSubview:p atIndex:0];
        
        if(autoScale)
        {
            [(iSVImagePage*)p autoLoad:cn];
        }
        else
        {
            [(iSVImagePage*)p load:cn maxScale:maxScale minScale:minScale];
        }
    }
	
    p.tag=sTag+i;
    
    if(d==0)//是当前页
    {    
        NSLog(@"当前页:调用 loadCurrentPage");
        [p loadCurrentPage:cmd];
        
        //[p performSelector:@selector(loadCurrentPage:) withObject:[NSNumber numberWithInt:cmd] afterDelay:.3];
    }
    
	[p initWithDirection:d];
}


//---------------------------------------------------------------------------------------------------------
//滚动中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	int scrollDirection;
	int dragDirection;
    
    //NSLog(@"scrollViewDidScroll %d",(int)scrollView.contentOffset.x%1024);
    
    //判断拖动方向
    if (lastContentOffset > scrollView.contentOffset.y)
        dragDirection = RIGHT;
    else if (lastContentOffset < scrollView.contentOffset.y)
        dragDirection = LEFT;
    
    // NSLog(@"dragDirection=%d",dragDirection);
	
	scrollDirection=lastContentOffset-scrollView.contentOffset.y;
	lastContentOffset = scrollView.contentOffset.y;
	
    
	//调用enterFrame方法
	for(int i=0;i<[pageList count];i++)
	{
	    if((currentPageNum-i)==1||currentPageNum==i||(i-currentPageNum)==1)
		{
			iPageView *tv=(iPageView*)[self viewWithTag:sTag+i];
			[tv enterFrame:scrollDirection];
		}
	}
    
    //拖动到位
    if ((int)scrollView.contentOffset.y%(int)(self.frame.size.height)==0)
    {
        
		int co=(int)scrollView.contentOffset.y/self.frame.size.height;
        
        //NSLog(@"scrollViewDidScroll|当前第%d页",currentPageNum);
        
        if (co>currentPageNum) {
            
			currentPageNum=co;
				
            
            if (currentPageNum!=0) {
                [(iPageView*)[self viewWithTag:sTag + currentPageNum-1] unloadCurrentPage];
            }
            
            [(iPageView*)[self viewWithTag:sTag + currentPageNum] loadCurrentPage:0];
            
			//添加后一页
			if(currentPageNum+1<[pageList count])
			{
				[self addPage:currentPageNum+1 direction:1 command:0];	
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
            
            if (currentPageNum<[pageList count]) {
                
                [(iPageView*)[self viewWithTag:sTag + currentPageNum+1] unloadCurrentPage];
            }
			          
             [(iPageView*)[self viewWithTag:sTag + currentPageNum] loadCurrentPage:0];
            
			//添加前一页
			if(currentPageNum-1>=0)
			{
				[self addPage:currentPageNum-1 direction:-1 command:0];		
			}
			
			//删除后一页
			if(currentPageNum+2<[pageList count])
			{
				[self removePage:currentPageNum+2];
			}

		}
		
		NSLog(@"允许滚动");
		scrollView.scrollEnabled=YES;
        
        
        
        CGFloat pageWidth = scrollView.frame.size.height;
        int page = floor((scrollView.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
        
        pc.currentPage=page;

        
        if([hsvdelegate conformsToProtocol:@protocol(iVScrollViewDelegate)])
        {
            [hsvdelegate iVScrollViewDidScroll:self];
        }

	}
	
}

//---------------------------------------------------------------------------------------------------------
//滚动速度缓动开始
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView 
{ 
    if(scrollView.contentOffset.y/self.frame.size.height!=currentPageNum)
	{
	    scrollView.scrollEnabled=NO;
		NSLog(@"禁止滚动");
	}
}

//---------------------------------------------------------------------------------------------------------
//删除页
-(void) removePage:(int) i
{	
	NSLog(@"删除第%d页",i);
    
    iPageView *p=(iPageView*)[self viewWithTag:sTag+i];
    [p unloadCurrentPage];
    [p stopNSTimer];
    [p removeFromSuperview];
}

@end
