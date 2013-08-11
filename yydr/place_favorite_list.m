//
//  place_favorite_list.m
//  yydr
//
//  Created by liyi on 13-4-6.
//
//

#import "place_favorite_list.h"
#import "place_list_cell.h"
#import "place_detail.h"
#import "global.h"
#import "UIView+GetRequestCookie.h"
#import "login.h"


@interface place_favorite_list ()

@end

@implementation place_favorite_list

@synthesize request;
@synthesize FavoriteList;
@synthesize HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        PageIndex=1;
        PageCount=1;
       
        self.view.backgroundColor=[UIColor blackColor];
        
        //表格
        tb=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44)];
        [self.view addSubview:tb];
        tb.separatorStyle = NO;
        tb.delegate=self;
        tb.dataSource=self;
        
        //设置表格脚标
        fv=[[place_list_footview alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        tb.tableFooterView=fv;
        [fv hideAll];
        
        canLoadMore=YES;

    }
    return self;
}


#pragma mark –
#pragma mark UIAlertView按钮事件／登入功能
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            login *mm = [[login alloc] initWithStyle:UITableViewStyleGrouped];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
            nav.navigationBar.tintColor=[UIColor blackColor];
            mm.title=@"登录";
            [self presentModalViewController:nav animated:YES];
        }
            break;
    }
}



#pragma mark –
#pragma mark 添加更多 addItemsOnBottom
- (void) addItemsOnBottom
{    
    //请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@placeFavorite",ServerURL]];
    
    [self.request clearDelegatesAndCancel];
    self.request=nil;
    self.request = [ASIFormDataRequest requestWithURL:url];
    self.request.tag=1010;
    self.request.timeOutSeconds=TIMEOUT;
    [self.request setDelegate:self];
    
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    
    if(ck!=nil)
    {
        [request setUseCookiePersistence:NO];
        [request setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    }
    
    [self.request setRequestMethod:@"GET"];
    [self.request startAsynchronous];
    
    [fv hideAll];
    [fv showLoading];
}


#pragma mark –
#pragma mark 请求完成 requestFinished
- (void)requestFailed:(ASIHTTPRequest *)r
{
    NSError *error = [r error];
    
    NSLog(@"place_detail_requestFailed:%@",error);
    
    [self loadMoreCompleted];
    
    //停止查询
    [r clearDelegatesAndCancel];
    r=nil;
    
    //跳出提示
    MBProgressHUD *AlertHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:AlertHUD];
    AlertHUD.labelText = ConnectionFailure;
    AlertHUD.mode = MBProgressHUDModeCustomView;
    AlertHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert"]];
    [AlertHUD show:YES];
    [AlertHUD hide:YES afterDelay:1.5];
    
}

- (void)requestFinished:(ASIHTTPRequest *)r
{
    switch (r.tag) {
        case 1010:
        {
            NSData *jsonData = [r responseData];
            
            NSError *error = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
            
            NSArray *items=(NSArray*)jsonObject;
            
            NSLog(@"count=======%d",[items count]);
            
            if ([items count]!=0){
                
                if(PageIndex==1)
                {
                    //是第一页就滚动顶部
                    [tb scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                }
                
                [self.FavoriteList addObjectsFromArray:items];
                [self.HUD hide:YES];
                
                PageIndex+=1;
            }
            
            
            if ([items count]<10)
            {
                //全部加载完了，不要再load了。
                canLoadMore = NO;
            }
            
            items=nil;
            
            [tb reloadData];
            [self loadMoreCompleted];

        }
            break;
        case 1011:
        {
            NSLog(@"responseStatusCode======%d",r.responseStatusCode);
            if(r.responseStatusCode==200)
            {
                [FavoriteList removeObjectAtIndex:deletRow.row];
                [tb deleteRowsAtIndexPaths:[NSArray arrayWithObject:deletRow]
                          withRowAnimation:UITableViewRowAnimationFade];
            }
        }
            break;
    }

    r=nil;
    
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


#pragma mark -
#pragma mark 数据判断
- (NSString*)isNull:(id)str
{
    if ([str isEqual:[NSNull null]]||str==nil||str==0) {
        return @"暂无";
    }
    else
    {
        return str;
    }
}



#pragma mark -
#pragma mark 表格回调函数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FavoriteList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"member_list_cell";
    place_list_cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *PlaceDetail=[self.FavoriteList objectAtIndex:indexPath.row];
    
    if (cell == nil)
    {
        cell = [[place_list_cell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    

    cell.distance.hidden=YES;
    [cell loadPlaceDetail:PlaceDetail];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    place_detail *mm = [[place_detail alloc] init];
    
    NSDictionary *d=[self.FavoriteList objectAtIndex:[indexPath row]];
    
    mm.title=[d objectForKey:@"Name"];
    //[mm load:d rbt:NO];
    
    [self.navigationController pushViewController:mm animated:YES];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.FavoriteList=nil;
    self.FavoriteList=[NSMutableArray array];
    
    
    //编辑按钮
    rbt=[[UIBarButtonItem alloc]initWithTitle:@"编辑"
                                        style:UIBarButtonItemStylePlain
                                       target:self action:@selector(onRDown:)];
    
    self.navigationItem.rightBarButtonItem=rbt;
    
}


-(void)onRDown:(UIButton*)sender
{
    
    if(tb.editing==YES)
    {
        rbt.title=@"编辑";
        [tb setEditing:NO animated:YES];
    }
    else
    {
         rbt.title=@"完成";
        [tb setEditing:YES animated:YES];
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        deletRow=indexPath;
        
        NSDictionary *Detail=[self.FavoriteList objectAtIndex:indexPath.row];

        
        int fid=[[Detail objectForKey:@"FavoriteId"] integerValue];
        
        //删除
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@placeFavorite/%d",ServerURL,fid]];
        
        NSLog(@"%@",url);
        
        [deleteRequest clearDelegatesAndCancel];
        deleteRequest=nil;
        deleteRequest = [ASIFormDataRequest requestWithURL:url];
        deleteRequest.tag=1011;
        deleteRequest.timeOutSeconds=TIMEOUT;
        [deleteRequest setDelegate:self];
        
        NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
        
        if(ck!=nil)
        {
            [deleteRequest setUseCookiePersistence:NO];
            [deleteRequest setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
        }
        
        [deleteRequest setRequestMethod:@"DELETE"];
        [deleteRequest startAsynchronous];
        
        
      
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
