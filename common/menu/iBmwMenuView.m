//
//  iBmwMenuView.m
//  test
//
//  Created by jervis shenghao on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iBmwMenuView.h"
#import "UIView+iImageManager.h"
#import "mvc.h"
@implementation iBmwMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addImageView:self image:@"bmw_bg.jpg" position:CGPointMake(0, 0)];
        ///////////////////////
        w = 242;
        h = 166;
        totalid = 0;
        activedID = 0;
        isclick = NO;
        
        ///////////////////////
        bmwMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 242, 166)];
        bmwMenu.tag = 5000;
        bmwMenu.delegate = self;
        bmwMenu.clipsToBounds = NO;
        bmwMenu.pagingEnabled = YES;
        bmwMenu.center = CGPointMake(512, 284);
        
//        NSLog(@"%@" , NSStringFromCGRect(bmwMenu.frame));
        
        bmwMenu.showsHorizontalScrollIndicator = NO;
        bmwMenu.showsVerticalScrollIndicator = NO;
        [self addSubview:bmwMenu];
        
        [self buildsubScrollView:0 vtag:5001];
        [self buildsubScrollView:1 vtag:5002];
        [self buildsubScrollView:2 vtag:5003];
        [self buildsubScrollView:3 vtag:5004];
        [self buildsubScrollView:4 vtag:5005];
        [self buildsubScrollView:5 vtag:5006];
        [self buildsubScrollView:6 vtag:5007];
        [self buildsubScrollView:7 vtag:5008];
        [self buildsubScrollView:8 vtag:5009];
        
        //tap事件监听
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        [self addGestureRecognizer:tap];
        
        [self addImageView:self image:@"bmw_mask.png" position:CGPointMake(0, 0)];
        [self addImageView:self image:@"bmw_topFrame.jpg" position:CGPointMake(0, 0)];
    }
    return self;
}
//生成子菜单
-(void) buildsubScrollView:(int)id vtag:(int)viewtag{
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    scrollview.tag=viewtag;
   
    scrollview.pagingEnabled = YES;
    scrollview.clipsToBounds = NO;
    scrollview.directionalLockEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.delegate = self;
    
    //
    int i = 0;
    for(i=0;i<10;i++)
    {
        
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"bmw_%i_%i.png",id ,i]];
//        NSLog(@"%@",[NSString stringWithFormat:@"bmw_%i_%i.png"]); 
        if(img== nil){
            break;
        }

        scrollview.contentSize = CGSizeMake(w, h*(i+1));
        UIImageView*bt=[[UIImageView alloc]initWithFrame:CGRectMake(0,h,w, h)];
        bt.image= img;
        bt.center = CGPointMake(w/2, i * h + h/2);
        [scrollview addSubview:bt];
        
    }
    
    scrollview.center = CGPointMake(scrollview.frame.size.width/2 + w*id,scrollview.frame.size.height/2);
    bmwMenu.contentSize = CGSizeMake(w*(id+1), h);
    [bmwMenu addSubview:scrollview];
    totalid = id;
    
}

//检测位置
-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    //居中显示的能上下拉动
    //{{391, 201}, {242, 166}}
    if (CGRectContainsPoint(CGRectMake(391, 201, w, 768), point)) {
        UIScrollView *csv1 = (UIScrollView *) [self viewWithTag:5000 + activedID +1];
        return csv1;
    }
    //第一行左右拖动
    if(!CGRectContainsPoint(bmwMenu.frame, point)){
        return bmwMenu;
    }
    //返回默认点
    return [super hitTest:point	withEvent:event];
    
}


#pragma mark- ｜SCROLLVOEW 托管 ******
-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //这里需要打开
    if (isclick) {
        [self openPage:rowid sc:cowid];
    }
    
}

//拖动
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    //BMW煮菜单scrollview拖动停止需计算当前子scrollview的id
    if(scrollView.tag == 5000){
        int cpage = scrollView.contentOffset.x/w;
        activedID = cpage;
        return;
    }
}

//
-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 5000) {
        //需要把所有的子view复位
        for (int i= 5001; i<=5009; i+=1) {
            UIScrollView *sv = (UIScrollView *) [self viewWithTag:i];
            [sv setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

#pragma mark - | CLICK STAGE
-(void) tapHandler : (UITapGestureRecognizer *) gesture{
    
    CGPoint point = [gesture locationInView:bmwMenu];
    //确定横向ID
    int row = point.x/w;
    //取得子菜单ID row + 5001
    UIScrollView *sv = (UIScrollView *)[self viewWithTag:5001+row];
    if(sv){
        CGPoint pin = [gesture locationInView:sv] ;
        int cow = (pin.y )/h;
        int t = sv.contentSize.height/h;
        int svc = sv.contentOffset.y/h;
        if (cow < t && point.y > 0) {
            //需直接打开
            if (cow == svc) {
                [self moveToLoc:row v:cow sv:sv];
                [self openPage:rowid sc:cowid];
                return;
            }
            
            //移动后打开
            //需要把所有不是点击的子view复位
            for (int i= 5001; i<=5009; i+=1) {
                if(i!=5001+row){
                    UIScrollView *sv2 = (UIScrollView *) [self viewWithTag:i];
                    [sv2 setContentOffset:CGPointMake(0, 0) animated:YES];
                }
            }
            
            [self moveToLoc:row v:cow sv:sv];
        }
    }
}

#pragma mark- | MOVE TO OPEN BMWVIEW TO X SUBVIEW TO Y
-(void) moveToLoc:(int)wid v:(int)hid sv:(UIScrollView *)scrollview{
    
    [self removeGestureRecognizer:tap];
    bmwMenu.scrollEnabled = NO;
    //需要把所有不是点击的子view复位
    for (int i= 5001; i<=5009; i+=1) {
        UIScrollView *sv2 = (UIScrollView *) [self viewWithTag:i];
        sv2.scrollEnabled = NO;
    }
    
    rowid = wid;
    cowid = hid;
    
    isclick = YES;
    bmwMenu.userInteractionEnabled = NO;
    [bmwMenu setContentOffset:CGPointMake(wid *w, 0) animated:YES];
    //查找子菜单
    [scrollview setContentOffset:CGPointMake(0, h*hid) animated:YES];
}

//打开菜单需进行初始化
#pragma mark- | INIT SCROLLVIEW ID

-(void) loadPage:(int)cmd subid:(int)sb{
    //传入菜单ID
    [bmwMenu setContentOffset:CGPointMake(cmd*w, 0)];
    //子菜单ID
    UIScrollView *sbv = (UIScrollView *) [self viewWithTag:5001 + cmd];
    [sbv setContentOffset:CGPointMake(0, h*sb)];
    activedID   =cmd;
}


#pragma mark- ｜ 进入主菜单
-(void) openPage:(int)chapter sc:(int)subchapter{
   // NSLog(@"打开页面 章节: %i %i" , chapter , subchapter);
    if (isclick) {
       // [(mvc*)[self getManager] gotoPage:chapter sc:subchapter];
        isclick = NO;
        [self performSelector:@selector(gotoChapter) withObject:nil afterDelay:.5];
    }
}

-(void)gotoChapter
{
    [(mvc*)[self getManager] gotoPage:rowid sc:cowid];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
