//
//  place_test.m
//  yydr
//
//  Created by Li yi on 13-6-19.
//
//

#import "place_list.h"
#import "place_detail.h"

#import "UIView+iButtonManager.h"

@interface place_list ()

@end

@implementation place_list

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
        locManager = [[CLLocationManager alloc] init];
        locManager.delegate = self;
        locManager.desiredAccuracy = kCLLocationAccuracyBest;
        

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.frame=CGRectMake(0, 40, 320, self.view.frame.size.height-40);
    
    PageIndex=1;
    order_by=0;
    category_id=0;
    area_id=0;
    city_id=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CityId"] integerValue];


    //*******************************************************
    UIButton *bt0=[self.view addButton:self.view
                                 image:@"place_lbt.png"
                              position:CGPointMake(0, 0)
                                   tag:1000
                                target:self
                                action:@selector(onDown:)];
    
    
    UIButton *bt1=[self.view addButton:self.view
                                 image:@"place_mbt.png"
                              position:CGPointMake(106, 0)
                                   tag:1001
                                target:self
                                action:@selector(onDown:)];
    
    
    UIButton *bt2=[self.view addButton:self.view
                                 image:@"place_rbt.png"
                              position:CGPointMake(214, 0)
                                   tag:1002
                                target:self
                                action:@selector(onDown:)];
    
    
    areaLabel=[self.view addLabel:bt0
                            frame:CGRectMake(10, 5, 100, 30)
                             font:[UIFont systemFontOfSize:16]
                             text:@""
                            color:[UIColor blackColor]
                              tag:0];
    areaLabel.shadowColor=[UIColor whiteColor];
    areaLabel.shadowOffset=CGSizeMake(0, 1);
    
    
    categoryLabel=[self.view addLabel:bt1
                                frame:CGRectMake(10, 5, 100, 30)
                                 font:[UIFont systemFontOfSize:16]
                                 text:@""
                                color:[UIColor blackColor]
                                  tag:0];
    categoryLabel.shadowColor=[UIColor whiteColor];
    categoryLabel.shadowOffset=CGSizeMake(0, 1);
    
    
    orderLabel=[self.view addLabel:bt2
                             frame:CGRectMake(10, 5, 100, 30)
                              font:[UIFont systemFontOfSize:16]
                              text:@""
                             color:[UIColor blackColor]
                               tag:0];
    orderLabel.shadowColor=[UIColor whiteColor];
    orderLabel.shadowOffset=CGSizeMake(0, 1);
    //*******************************************************
    
    
    areaLabel.text=@"全部区域";
    categoryLabel.text=@"全部场所";
    orderLabel.text=@"默认排序";
    

    //初始化数组
    PlaceList = [NSMutableArray array];
    //[PlaceList addObject:@"adv"];

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
    
    [self loadPlaceList:category_id
                area_id:area_id
                city_id:city_id
             page_index:PageIndex
               order_by:order_by
                   glat:glat
                   glng:glng
                    tag:1010];
}


//恢复到初始load
-(void)reloadWithInit
{
    
    NSLog(@"reloadWithInit");
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
    }
    

    PageIndex=1;
    order_by=0;
    category_id=0;
    area_id=0;
    city_id=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CityId"] integerValue];
    
    curAreaRow=0;
    
    areaLabel.text=@"全部区域";
    categoryLabel.text=@"全部场所";
    orderLabel.text=@"默认排序";

    [self loadPlaceList:category_id
                area_id:area_id
                city_id:city_id
             page_index:PageIndex
               order_by:order_by
                   glat:glat
                   glng:glng
                    tag:1010];
    
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
    
    [self loadPlaceList:category_id
                area_id:area_id
                city_id:city_id
             page_index:PageIndex
               order_by:order_by
                   glat:glat
                   glng:glng
                    tag:1011];
    return YES;
}



#pragma mark 添加更多 addItemsOnBottom
- (void)loadPlaceList:(int)cid
              area_id:(int)aid
              city_id:(int)cityid
           page_index:(int)pid
             order_by:(int)ob
                 glat:(double)lat
                 glng:(double)lng
                  tag:(int)t
{
    PageIndex=pid;
    category_id=cid;
    
    self.canLoadMore=NO;
    
    NSString *sUrl=[NSString stringWithFormat:@"%@place?page=%d&oid=%d&cid=%d&aid=%d&cityid=%d&glat=%f&glng=%f",ServerURL,pid,ob,cid,aid,cityid,lat,lng];
    
    //请求
    NSURL *url = [NSURL URLWithString:sUrl];
    NSLog(@"%@",url);
    
    [PlaceRequest clearDelegatesAndCancel];
    PlaceRequest=nil;
    PlaceRequest = [ASIFormDataRequest requestWithURL:url];
    PlaceRequest.tag=t;
    PlaceRequest.timeOutSeconds=TIMEOUT;
    [PlaceRequest setDelegate:self];
    [PlaceRequest setRequestMethod:@"GET"];
    [PlaceRequest startAsynchronous];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Dummy data methods

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addItemsOnTop:(NSArray*)items
{
   
    //刷新
    PlaceList = nil;
    PlaceList = [NSMutableArray array];
    
    if ([items count]!=0){
        [PlaceList addObjectsFromArray:items];
        
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
        [PlaceList addObjectsFromArray:items];
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
    return [PlaceList count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 区域及排序事件
-(void)onDown:(UIButton*)sender
{
    switch (sender.tag) {
            //选择区域
        case 1000:
        {
            place_area_list *actionSheet = [[place_area_list alloc] initWithTitle:@"选择区域"
                                                                         delegate:nil
                                                                cancelButtonTitle:nil
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:nil];
            [actionSheet loadAreaWithAll:YES Selected:curAreaRow];
            actionSheet.areaDelegate=self;
            [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
            [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
        }
            break;
            
        case 1001:
        {
            UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"全部场所",@"桑拿会所",@"指压推油",@"夜总会",nil];
            menu.tag=2000;
            [menu showInView:[[UIApplication sharedApplication] keyWindow]];
        }
            break;
            
            //排序
        case 1002:
        {
            UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"默认排序",@"评价最高",@"价格最高",@"离我最近",nil];
            menu.tag=2001;
            [menu showInView:[[UIApplication sharedApplication] keyWindow]];
        }
            break;
    }
}

//选择区域
-(void) AreaSelected:(NSString *)at Area_id:(int)aid SelectRow:(int)csr
{
    NSLog(@"%@:%d",at,aid);
    
    if(aid!=area_id)
    {
        areaLabel.text=at;
        
        //不一样说明要刷新了
        area_id=aid;
        PageIndex=1;
        curAreaRow=csr;
        
        [self reload];
    }
}


//排序
- (void)actionSheet:(UIActionSheet *)as didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d,%d,%d",as.tag,buttonIndex,category_id);
    
    
    switch (as.tag) {
        case 2000:
        {
            if ([categoryLabel.text isEqualToString:[as buttonTitleAtIndex:buttonIndex]]||buttonIndex==4) {
                return;
            }
            
            NSString *categoryText=[as buttonTitleAtIndex:buttonIndex];
            
            categoryLabel.text=categoryText;

            if([categoryText isEqualToString:@"全部场所"])
            {
                 category_id=0;
            }
            else if([categoryText isEqualToString:@"桑拿会所"])
            {
                 category_id=3;
            }
            else if([categoryText isEqualToString:@"指压推油"])
            {
                 category_id=1;
            }
            else if([categoryText isEqualToString:@"夜总会"])
            {
                 category_id=5;
            }

            PageIndex=1;
            
            [self reload];
        }
            break;
            
        case 2001:
        {
            if (buttonIndex==order_by||buttonIndex==4) {
                return;
            }
            
            order_by=buttonIndex;
            orderLabel.text=[as buttonTitleAtIndex:buttonIndex];
            
            PageIndex=1;
            
            [self reload];
        }
            break;
    }    
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *d=[PlaceList objectAtIndex:[indexPath row]];
    
    switch (indexPath.row) {
        case 0:
        {
            
            if([d objectForKey:@"advType"])
            {
                //有广告
                
                return;
            }
        }
            
        default:
        {
            place_detail *mm = [[place_detail alloc] init];
            
            [mm load:d];
            
            [self.navigationController pushViewController:mm animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
            break;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *PlaceDetail=[PlaceList objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
        case 0:
        {
            
            if([PlaceDetail objectForKey:@"advType"])
            {
                place_list_cell0 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
                
                if (cell == nil)
                {
                    cell = [[place_list_cell0 alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"cell0"];
                }
                return cell;
            }
        }
            
        default:
        {
            place_list_cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            
          
            
            if (cell == nil)
            {
                cell = [[place_list_cell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"cell1"];
            }
            
            [cell loadPlaceDetail:PlaceDetail];
            
            return cell;
        }
            break;
    }
}


@end