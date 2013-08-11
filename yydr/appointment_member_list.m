//
//  appointment_test.m
//  yydr
//
//  Created by Li yi on 13-6-20.
//
//

#import "appointment_member_list.h"
#import "member_info.h"

@interface appointment_member_list ()

@end

@implementation appointment_member_list

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        PageIndex=1;
        PageCount=1;
        
        UserList = [NSMutableArray array];
        
        locManager = [[CLLocationManager alloc] init];
        locManager.delegate = self;
        locManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        
        int mid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];
        dbHelper *dh=[[dbHelper alloc] init];
        SexNum=[dh getUserSex:mid];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    locNow=NO;
    
   [self refresh];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// 开始定位

-(void)StartLoc
{
    if(locNow)
        return;
    
    if ([CLLocationManager locationServicesEnabled])
    {
        locNow=YES;
        locManager.delegate=self;
        [locManager startUpdatingLocation];
        NSLog(@"开始定位");
    }
    else
    {
        [self locFailed];
        [self refreshCompleted];
    }
}

#pragma mark –
#pragma mark 定位回调

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 停止更新
    [locManager stopUpdatingLocation];
    locManager.delegate=nil;
    
    glat=newLocation.coordinate.latitude;
    glng=newLocation.coordinate.longitude;
    
    locNow=NO;
    
    //重新请求
    [self reload];
}


-(void)reload
{
    PageIndex=1;
    
    [self loadUserList:PageIndex Tag:1010];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    locNow=NO;
    
    switch (error.code) {
        case kCLErrorLocationUnknown:
        {
            NSLog(@"The location manager was unable to obtain a location value right now.");
            break;
        }
        case kCLErrorDenied:
        {
            [self locFailed];
        }
            break;
        case kCLErrorNetwork:
        {
            NSLog(@"The network was unavailable or a network error occurred.");
        }
            break;
        default:
            NSLog(@"未定义错误");
            break;
    }
}

-(void)locFailed
{
    locNow=NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先开启定位功能"
                                                    message:@"设置->隐私->定位服务->开启定位"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 请求回调
- (void)requestFailed:(ASIHTTPRequest *)r
{
    int statusCode=[r responseStatusCode];

    switch (statusCode) {
        case 401:
        {
            [[NSUserDefaults standardUserDefaults] setObject:nil
                                                      forKey:@"Value"];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
            break;
            
        default:
        {
            
            NSError *error = [r error];
            
            NSLog(@"place_detail_requestFailed:%@",error);
            
            //跳出提示
            MBProgressHUD *AlertHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:AlertHUD];
            AlertHUD.labelText = ConnectionFailure;
            AlertHUD.mode = MBProgressHUDModeCustomView;
            AlertHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert"]];
            [AlertHUD show:YES];
            [AlertHUD hide:YES afterDelay:1.5];
            
            switch (r.tag) {
                case 1010:
                {
                    //刷新
                    [self refreshCompleted];
                }
                    break;
                case 1011:
                {
                    //加载更多
                    [self loadMoreCompleted];
                }
                    break;
            }

        }
            break;
    }
    
    //停止查询
    [r clearDelegatesAndCancel];
    r=nil;
}


- (void)requestFinished:(ASIHTTPRequest *)r
{
    NSData *jsonData = [r responseData];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSArray *items=(NSArray*)jsonObject;
    
    switch (r.tag) {
        case 1010:
        {
            //刷新
            [self addItemsOnTop:items];
        }
            break;
        case 1011:
        {
            //加载更多
            [self addItemsOnBottom:items];
        }
            break;
    }
    
    r=nil;
    items=nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
//
// 刷新列表
//
- (BOOL) refresh
{
    if (![super refresh])
        return NO;
    
    [self StartLoc];
    
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Load More

////////////////////////////////////////////////////////////////////////////////////////////////////
// 加载更多
- (BOOL) loadMore
{
    if (![super loadMore])
        return NO;
    
    NSLog(@"加载更多");

    [self loadUserList:PageIndex
                   Tag:1011];

    return YES;
}



#pragma mark 添加更多 addItemsOnBottom

-(void)loadUserList:(int)pi Tag:(int)t
{
    
    PageIndex=pi;

    self.canLoadMore=NO;
    
    //获取聊天用户
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@User?page=%d&sex=%d&glat=%f&glng=%f",ServerURL,pi,SexNum,glat,glng]];
    NSLog(@"%@",url);
    userRequet=[ASIHTTPRequest requestWithURL:url];
    userRequet.timeOutSeconds=TIMEOUT;
    [userRequet setRequestMethod:@"GET"];
    userRequet.tag=t;
    
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    
    if(ck!=nil)
    {
        [userRequet setUseCookiePersistence:NO];
        [userRequet setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    }
    
    [userRequet setDelegate:self];
    [userRequet startAsynchronous];
    
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Dummy data methods

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addItemsOnTop:(NSArray*)items
{
    
    //刷新
    UserList = nil;
    UserList = [NSMutableArray array];
    
    if ([items count]!=0){
        [UserList addObjectsFromArray:items];
    }
    
    NSLog(@"%d",[items count]);
    
    if ([items count]>=10)
    {
        //返回有10条，可以继续加载
        self.canLoadMore = YES;
        PageIndex+=1;
        [self setFooterViewVisibility:YES];
    }
    else
    {
        [self setFooterViewVisibility:NO];
    }
    
    [self.tableView reloadData];
    
    // Call this to indicate that we have finished "refreshing".
    // This will then result in the headerView being unpinned (-unpinHeaderView will be called).
    [self refreshCompleted];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addItemsOnBottom:(NSArray*)items
{
    
    if ([items count]!=0){
        [UserList addObjectsFromArray:items];
    }
    
    if ([items count]>=10)
    {
        //返回有10条，可以继续加载
        self.canLoadMore = YES;
        PageIndex+=1;
    }
    
    [self.tableView reloadData];
    
    // Inform STableViewController that we have finished loading more items
    [self loadMoreCompleted];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Standard TableView delegates


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [UserList count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"去个人信息");
    
    
    NSDictionary *UserDetail=[UserList objectAtIndex:indexPath.row];
    
    member_info *cc=[[member_info alloc] init];
    
    [cc loadInfo:UserDetail
     Appointment:YES];
    
    cc.title=@"个人信息";
    
    [self.navigationController pushViewController:cc
                                         animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"girl_list_cell";
    appointment_member_list_cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *UserDetail=[UserList objectAtIndex:indexPath.row];
    
    
    if (cell == nil)
    {
        cell = [[appointment_member_list_cell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:CellIdentifier];
    }
    
    cell.UserName.text=[UserDetail objectForKey:@"UserName"];
    
    int UserId=[[UserDetail objectForKey:@"UserId"] integerValue];
    
    
    NSString *FileName=[UserDetail objectForKey:@"Avatar"];
   
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,UserId,FileName]];
    [cell.Avatar setImageWithURL:url
                placeholderImage:[UIImage imageNamed:@"noAvatar.png"]];
    

    
    //签名
    id signature=[UserDetail objectForKey:@"Signature"];
    
    if( !signature || [signature isKindOfClass:[NSNull class]] )
    {
        signature=@"";
    }
    
    cell.Signature.text=signature;
    [cell.Signature sizeToFit];
    CGRect f=cell.Signature.frame;
    f.size.width=200;
    f.origin.y=35;
    cell.Signature.frame=f;
    
    //距离
    float ds=[[UserDetail objectForKey:@"Distance"] floatValue];
    
    if(ds<1)
    {
        int temp=ds*1000;
        
        cell.Distance.text=[NSString stringWithFormat:@"%dm",temp];
        
        /*
         if(temp<50)
         {
         cell.distance.text=@"<50m";
         }
         else if(temp<100)
         {
         cell.distance.text=@"<100m";
         }
         else
         {
         
         }
         */
        
    }
    else
    {
        int temp=(int)(ds*10);
        
        if(temp%10==0)
        {
            cell.Distance.text=[NSString stringWithFormat:@"%dkm",temp/10];
        }
        else
        {
            ds=(float)temp/10;
            cell.Distance.text=[NSString stringWithFormat:@"%.1fkm",ds];
        }
    }
    
    
    if(UserId==1420)
    {
        cell.Distance.hidden=YES;
    }
    else
    {
        cell.Distance.hidden=NO;
    }
    
    
    return cell;
}




@end
