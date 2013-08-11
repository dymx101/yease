//
//  place_manager_list.m
//  yydr
//
//  Created by liyi on 13-4-4.
//
//

#import "place_manager_list.h"
#import "UIView+iImageManager.h"
#import "place_manager_cell.h"
#import "place_manager_add.h"
#import "place_manager_detail.h"
#import "global.h"
#import "login.h"
#import "UIView+GetRequestCookie.h"
#import "UIImageView+WebCache.h"
#import "member_info.h"


@interface place_manager_list ()

@end

@implementation place_manager_list

@synthesize HUD;
@synthesize ManageRequest;
@synthesize ManagerList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor=[UIColor blackColor];
        
        //变量初始化
        PageIndex=1;
        PageCount=1;
        canLoadMore=YES;
        
        
        //表格初始化
        tb=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44)
                                        style:UITableViewStylePlain];
        
        tb.backgroundView = [self.view addImageView:nil
                                              image:@"place_tel_bbg.png"
                                           position:CGPointMake(0, 0)];
        tb.separatorStyle = NO;
        tb.delegate=self;
        tb.dataSource=self;
        [self.view addSubview:tb];
        
        
        //表格脚标初始化
        fv=[[place_list_footview alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        tb.tableFooterView=fv;
        [fv hideAll];
        
    }
    return self;
}

#pragma mark –
#pragma mark 上一个页面需要调用
-(void)FirstLoad:(int)pid Tel:(int)t
{
    tel=t;
    Place_id=pid;
    
    self.ManagerList=nil;
    self.ManagerList=[NSMutableArray array];
    
    [self addItemsOnBottom:pid page_index:PageIndex];
}


#pragma mark –
#pragma mark 添加更多 addItemsOnBottom
- (void) addItemsOnBottom:(int)place_id
               page_index:(int)page_index
{
    PageIndex=page_index;
    
    NSString *sUrl=[NSString stringWithFormat:@"%@PlaceManager?page=%d&pid=%d",ServerURL,page_index,place_id];
    
    //请求
    NSURL *url = [NSURL URLWithString:sUrl];
    NSLog(@"%@",url);
    
    [self.ManageRequest clearDelegatesAndCancel];
    self.ManageRequest=nil;
    self.ManageRequest = [ASIFormDataRequest requestWithURL:url];
    self.ManageRequest.tag=1010;
    self.ManageRequest.timeOutSeconds=TIMEOUT;
    [self.ManageRequest setDelegate:self];
    [self.ManageRequest setRequestMethod:@"GET"];
    [self.ManageRequest startAsynchronous];
    
    [fv hideAll];
    [fv showLoading];
}

//拨号
-(void)onCallDown:(UIButton*)sender
{
    NSDictionary *ManagerDetail=[self.ManagerList objectAtIndex:sender.tag-1000];
    
    mid = [[ManagerDetail objectForKey:@"Id"] integerValue];
    mobile= [ManagerDetail objectForKey:@"ManagerMobile"];
    

    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"立即预约",nil];
    [menu showInView:self.view];
    
}


#pragma mark –
#pragma mark 真正开始拨号了
- (void)actionSheet:(UIActionSheet *)as didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
        if(ck==nil)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:MustLoginInfo
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"立即登入",nil];
            [alertView show];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",mobile]]];
            
            //拨打统计
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@PlaceManager?mid=%d&num=1",ServerURL,mid]];
            ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:url];
            req.timeOutSeconds=TIMEOUT;
            req.tag=1020;
            [req setRequestMethod:@"PUT"];
            [req setUseCookiePersistence:NO];
            [req setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
            [req setDelegate:self];
            [req startAsynchronous];
        }
    }
}


#pragma mark -
#pragma mark 表格回调函数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ManagerList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42;
}
 -(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 UIView * hView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
 
 UIImageView *im=[self.view addImageView:hView
 image:@"place_tel_mbg.png"
 position:CGPointMake(0, 0)];
 
 im.center=CGPointMake(160, im.center.y);
 
 UILabel *tt= [self.view addLabel:hView
 frame:CGRectMake(25, 12, 0, 0)
 font:[UIFont boldSystemFontOfSize:14]
 text:tel>0?[NSString stringWithFormat:@"座机：%d",tel]:@"座机：暂无"
 color:[UIColor grayColor]
 tag:0];
 
 [tt sizeToFit];
 tt.shadowColor=[UIColor whiteColor];
 tt.shadowOffset=CGSizeMake(0, 1);
 
 tt.center=CGPointMake(tt.center.x, 21);
 
 return hView;
 
 }
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cell";
    place_manager_cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *ManagerDetail=[self.ManagerList objectAtIndex:indexPath.row];
    
    if (cell == nil)
    {
        cell = [[place_manager_cell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CellIdentifier];
    }
    
    cell.name.text=[ManagerDetail objectForKey:@"UserName"];
    
    cell.off.text=[ManagerDetail objectForKey:@"Off"];
    
    cell.info.text=[ManagerDetail objectForKey:@"Description"];
    cell.dbt.tag=1000+indexPath.row;
    
    
    //头像
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",
                                     UserPhotoURL,
                                     [ManagerDetail objectForKey:@"UserId"],
                                     [ManagerDetail objectForKey:@"Avatar"]]];
    
    [cell.avatar setImageWithURL:url
                placeholderImage:[UIImage imageNamed:@"noAvatar.png"]];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *ManagerDetail=[self.ManagerList objectAtIndex:indexPath.row];
    
    place_manager_detail *mm = [[place_manager_detail alloc] init];
    [mm loadDetail:ManagerDetail];
    mm.title=@"详细";
    
    [self.navigationController pushViewController:mm
                                         animated:YES];
}


-(void)onRDown:(UIButton*)sender
{
    place_manager_add *mm = [[place_manager_add alloc] initWithStyle:UITableViewStyleGrouped];
    [mm setPlaceId:Place_id];
    mm.title=@"客户经理";
    [self.navigationController pushViewController:mm animated:YES];
}


#pragma mark –
#pragma mark 请求完成 requestFinished
- (void)requestFailed:(ASIHTTPRequest *)r
{
    
    [HUD hide:YES];
    
    int statusCode=[r responseStatusCode];
    switch (statusCode) {
            
        case 401:
        {
            [[NSUserDefaults standardUserDefaults] setObject:nil
                                                      forKey:@"Value"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:MustLoginInfo
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"立即登入",nil];
            [alertView show];
        }
            break;
            
            
        default:
        {
            //网络不好跳出提示
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
    
    [r clearDelegatesAndCancel];
    r=nil;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            login *mm = [[login alloc] initWithStyle:UITableViewStyleGrouped];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
            nav.navigationBar.tintColor=[UIColor blackColor];
            mm.title=@"登录";
            [self.navigationController presentModalViewController:nav animated:YES];
        }
            break;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)r
{
    switch (r.tag) {
        case 1020:
        {
          NSLog(@"拨号＋1 成功");  
        }
            break;
            
       case 1010:
        {
            NSData *jsonData = [r responseData];
            NSError *error = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
            
            
            NSArray *items=(NSArray*)jsonObject;
            NSLog(@"%@",items);
            
            if ([items count]!=0){
                
                if(PageIndex==1)
                {
                    //是第一页就滚动顶部
                    [tb scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                }
                
                [self.ManagerList addObjectsFromArray:items];
                [self.HUD hide:YES];
                
                PageIndex+=1;
            }
            
            if([items count]==0&&[self.ManagerList count]==0)
            {
                canLoadMore = NO;
                fv.completed.text=@"暂无经理";
            }
            else if ([items count]<10)
            {
                //全部加载完了，不要再load了。
                canLoadMore = NO;
                tb.tableFooterView=nil;
            }

            [tb reloadData];
            [self loadMoreCompleted];
            
            items=nil;
            r=nil;
        }
            break;
    }
}



#pragma mark -
#pragma mark load完毕
- (void) loadMoreCompleted
{
    [self.HUD hide:YES];
    
    if (canLoadMore==YES) {
        [fv hideAll];
        [fv showLoadButton];
    }
    else
    {
        [fv hideAll];
        [fv showCompleted];
    }
    
    NSLog(@"loadMoreCompleted");
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.ManageRequest clearDelegatesAndCancel];
    self.ManageRequest=nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onBack:)
                                                              target:self];
    
    self.navigationItem.rightBarButtonItem=[self.view add_manager_add_button:@selector(onRDown:)
                                                                      target:self];
}


-(void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
