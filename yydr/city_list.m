//
//  city_list.m
//  yydr
//
//  Created by liyi on 13-4-15.
//
//

#import "city_list.h"
#import "UIView+iButtonManager.h"
@interface city_list ()

@end

@implementation city_list

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"正在切换，请稍等...";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    
    self.title=[NSString stringWithFormat:@"当前城市-%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"City"]];

//    UIBarButtonItem *lbt=[self.view add_close_button:@selector(onLDown:)
//                                              target:self];
//    self.navigationItem.leftBarButtonItem=lbt;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    cityList = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
 
    NSLog(@"%@",[cityList objectForKey:@"item0"] );

}


- (void)onLDown:(UIButton*)sender
{
     [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cityList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"member_list_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    
    
    cell.textLabel.text=[[cityList objectForKey:[NSString stringWithFormat:@"item%d",indexPath.row]] objectForKey:@"city"];

    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [HUD show:YES];
    
    NSString *city=[[cityList objectForKey:[NSString stringWithFormat:@"item%d",indexPath.row]] objectForKey:@"city"];
    NSString *cid=[[cityList objectForKey:[NSString stringWithFormat:@"item%d",indexPath.row]] objectForKey:@"id"];
    
    NSLog(@"city=%@ id=%@",city,cid);
    
    [[NSUserDefaults standardUserDefaults] setObject:city
                                              forKey:@"City"];
    
    [[NSUserDefaults standardUserDefaults] setObject:cid
                                              forKey:@"CityId"];
    
    
    //拨打统计
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@user?cid=%@",ServerURL,cid]];
    ASIHTTPRequest *cityRequest=[ASIHTTPRequest requestWithURL:url];
    cityRequest.timeOutSeconds=TIMEOUT;
    [cityRequest setRequestMethod:@"PUT"];
    [cityRequest setUseCookiePersistence:NO];
    
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    [cityRequest setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    
    [cityRequest setDelegate:self];
    [cityRequest startAsynchronous];

    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - 请求回调
- (void)requestFailed:(ASIHTTPRequest *)r
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

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [delegate onCitySelected];
    [self dismissModalViewControllerAnimated:YES];
}



- (void)requestFinished:(ASIHTTPRequest *)r
{
    HUD.delegate=self;
    [HUD hide:YES afterDelay:.5];
}

@end
