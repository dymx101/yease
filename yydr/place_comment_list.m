//
//  place_comment_list0.m
//  yydr
//
//  Created by liyi on 13-2-20.
//
//

#import "place_comment_list.h"
#import "place_comment_list_cell.h"
#import "UIView+GetRequestCookie.h"
#import "global.h"
#import "login.h"

@interface place_comment_list ()

@end

@implementation place_comment_list

@synthesize HUD;
@synthesize request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        PageIndex=1;
        
        self.view.backgroundColor=[UIColor whiteColor];
        
        commentList = nil;
        commentList = [NSMutableArray array];
        
        commentHightList=nil;
        commentHightList=[NSMutableArray array];

        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.labelText = @"正在加载，请稍等...";
        [HUD show:YES];
        
        //表格
        tb=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44)];
        [self.view addSubview:tb];
        tb.separatorStyle = NO;
        tb.delegate=self;
        tb.dataSource=self;
        
        //设置表格脚标
        fv=[[place_comment_list_footview alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        tb.tableFooterView=fv;
        [fv hideAll];
        
        canLoadMore=YES;
        
    }
    return self;
}


-(void)setPlaceId:(int)pid
{
    PlaceId=pid;
}

#pragma mark –
#pragma mark 请求完成 requestFinished
- (void)requestFinished:(ASIHTTPRequest *)r
{
    [HUD hide:YES];
    
    // Use when fetching binary data
    NSData *jsonData = [r responseData];

    
    
    //解析JSon
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"%@",jsonObject);
    
    
    if (jsonObject != nil && error == nil){
        
        NSLog(@"place_list:Successfully deserialized...");
        
        NSArray *items=(NSArray*)jsonObject;
        
        
       if ([items count]!=0)
        {
            [commentList addObjectsFromArray:items];
            
            //计算每行高度
            for (int i=0; i<[items count]; i++) {
                NSDictionary *c=[items objectAtIndex:i];
                NSString *txt=[c objectForKey:@"Comment"];
                CGSize titleSize = [txt sizeWithFont:[UIFont systemFontOfSize:15.f]
                                   constrainedToSize:CGSizeMake(300, MAXFLOAT)
                                       lineBreakMode:UILineBreakModeWordWrap];
                
                [commentHightList addObject:[NSNumber numberWithFloat:(titleSize.height+90.f)]];
            }
            
            
            [self.HUD hide:YES];
            PageIndex+=1;
        }
        
        
        if ([items count]<10)
        {
            canLoadMore = NO;
        }
        
    }
    
    [tb reloadData];
    [self loadMoreCompleted];
     
    
}

- (void)requestFailed:(ASIHTTPRequest *)r
{
    [HUD hide:YES];
    
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

#pragma mark –
#pragma mark 添加更多 addItemsOnBottom
- (void) addItemsOnBottom:(int)pid
{
    PlaceId=pid;
    
    //请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@PlaceComment?page=%d&pid=%d",ServerURL,PageIndex,PlaceId]];
    
    NSLog(@"%@",url);
    
    self.request = [ASIFormDataRequest requestWithURL:url];
    [self.request setDelegate:self];
    [self.request setRequestMethod:@"GET"];
    
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    if(ck!=nil)
    {
        [request setUseCookiePersistence:NO];
        [request setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    }

    
    [self.request startAsynchronous];
    
    [fv hideAll];
    [fv showLoading];
    
}

#pragma mark –
#pragma mark 区域及排序事件
-(void)onDown:(UIButton*)sender
{
    [fv hideAll];
    [fv showLoading];
    [self addItemsOnBottom:PlaceId];
}


#pragma mark -
#pragma mark 表格回调
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"comment_list_cell";
    place_comment_list_cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[place_comment_list_cell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
    }
    

    NSDictionary *cd=[commentList objectAtIndex:indexPath.row];
    
    [cell loadCommentDetail:cd
                     Height:[[commentHightList objectAtIndex:indexPath.row] integerValue]];
       
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h=[[commentHightList objectAtIndex:indexPath.row] floatValue];
    return h;
}




#pragma mark -
#pragma mark 初始化及默认函数
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    commentList=nil;
    commentHightList=nil;
    self.request=nil;
    self.HUD=nil;
}


-(void)viewDidAppear:(BOOL)animated
{
    [self addItemsOnBottom:PlaceId];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.request clearDelegatesAndCancel];
    self.request=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
