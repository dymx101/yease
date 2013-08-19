//
//  place_manager_detail.m
//  yydr
//
//  Created by liyi on 13-4-2.
//
//

#import "place_manager_detail.h"
#import "place_manager_cell.h"

#import "UIView+iImageManager.h"
#import "UIView+GetRequestCookie.h"
#import "UIView+iButtonManager.h"

#import "ASIHTTPRequest.h"
#import "global.h"
#import "login.h"

#import "member_info.h"
#import "appointment_main.h"
#import "appointment_chat.h"

@interface place_manager_detail ()

@end

@implementation place_manager_detail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        tb=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)
                                        style:UITableViewStylePlain];
        tb.delegate=self;
        tb.dataSource=self;
        tb.separatorStyle = NO;
        tb.backgroundView = [self.view addImageView:nil
                                              image:@"place_tel_bbg.png"
                                           position:CGPointMake(0, 0)];
        [self.view addSubview:tb];
 
    }
    return self;
}

-(void)loadDetail:(NSDictionary*)d
{
    md=d;
    
    
    //计算服务介绍高度
    NSString *txt=[md objectForKey:@"Description"];
    CGSize titleSize = [txt sizeWithFont:[UIFont systemFontOfSize:15.f]
                       constrainedToSize:CGSizeMake(320, MAXFLOAT)
                           lineBreakMode:UILineBreakModeWordWrap];
    
    commentHeight=titleSize.height+20;
    
    [tb reloadData];
}




-(void)onDown:(UIButton*)sender
{

    switch (sender.tag) {
            
        case 1000:
        {
            //个人信息
            
            member_info *mm = [[member_info alloc] init];
            [mm loadInfo:md];
            mm.title=@"个人信息";
            [self.navigationController pushViewController:mm animated:YES];
        }
            break;
            
        case 1001:
        {
            //聊天
            
            
            
            //开始聊天
            appointment_chat *cc=[[appointment_chat alloc] init];
            
            [cc setRev:[[md objectForKey:@"UserId"] integerValue]
               revName:[md objectForKey:@"UserName"]
             revAvatar:[md objectForKey:@"Avatar"]];
            
            
            //从经理开始聊天
            [self.navigationController pushViewController:cc animated:YES];

            
            
            
            /*
            appointment_main *mm = [[appointment_main alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
            nav.navigationBar.tintColor=[UIColor blackColor];
            mm.title=@"约会";
            
            
            //开始聊天
            appointment_chat *cc=[[appointment_chat alloc] init];
            
            [cc setRev:[[md objectForKey:@"UserId"] integerValue]
               revName:[md objectForKey:@"UserName"]
             revAvatar:[md objectForKey:@"Avatar"]];
            
            
            //从经理开始聊天
            [nav pushViewController:cc animated:NO];
            
            
            [self presentModalViewController:nav animated:YES];
             */
            

        }
            break;
            
        case 1002:
        {
            //拨号
            mid = [[md objectForKey:@"Id"] integerValue];
            mobile = [md objectForKey:@"ManagerMobile"];
            
            
            UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"立即预约",nil];
            [menu showInView:self.view];

        }
            break;
    }
}


//真正开始拨号了
- (void)actionSheet:(UIActionSheet *)as didDismissWithButtonIndex:(NSInteger)buttonIndex
{    
    if(buttonIndex==1)
    {
        return;
    }
    
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    if(ck==nil)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }

    
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


- (void)requestFinished:(ASIHTTPRequest *)r
{
    //拨号了
    NSLog(@"拨号＋1");
    r=nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onBack:)
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    
       
    if(indexPath.row==0)
    {
        static NSString *CellIdentifier = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        
        if(cell==nil)
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"place_detail_cell_0"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            User_id=[[md objectForKey:@"UserId"] integerValue];
            uname=[md objectForKey:@"UserName"];
            cell.textLabel.text=uname;
            
            cell.textLabel.font=[UIFont systemFontOfSize:32];
            cell.textLabel.shadowColor=[UIColor whiteColor];
            cell.textLabel.shadowOffset=CGSizeMake(0, 1);
            
        }
    }
    
    
    if(indexPath.row==1)
    {
        static NSString *CellIdentifier = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if(cell==nil)
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"place_detail_cell_0"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
             [self.view addImageView:cell.contentView
                                                image:@"manager_bar.png"
                                             position:CGPointMake(0, 0)];
            
            cell.textLabel.text=[md objectForKey:@"Off"];
            cell.textLabel.font=[UIFont boldSystemFontOfSize:14];
            cell.textLabel.textColor=[UIColor colorWithRed:178.f/255.f green:0 blue:0 alpha:1];
            
        }
        
    }

    if(indexPath.row==2)
    {
        static NSString *CellIdentifier = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if(cell==nil)
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"place_detail_cell_0"];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
             [self.view addImageView:cell.contentView
                                                image:@"manager_bar_1.png"
                                             position:CGPointMake(0, 0)];
            
            
            
            
            [self.view addButton:cell.contentView
                           image:@"manager_info_bt.png"
                        position:CGPointMake(0, 0)
                             tag:1000
                          target:self
                          action:@selector(onDown:)];
            
            [self.view addButton:cell.contentView
                           image:@"manager_chat_bt.png"
                        position:CGPointMake(107, 0)
                             tag:1001
                          target:self
                          action:@selector(onDown:)];
            
            [self.view addButton:cell.contentView
                           image:@"manager_dial_bt.png"
                        position:CGPointMake(214, 0)
                             tag:1002
                          target:self
                          action:@selector(onDown:)];
                
        }
        
    }
    
    
    if(indexPath.row==3)
    {
        static NSString *CellIdentifier = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if(cell==nil)
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"place_detail_cell_0"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            /*
            cell.contentView.backgroundColor=[UIColor colorWithRed:(float)211/255
                                                             green:(float)211/255
                                                              blue:(float)211/255
                                                             alpha:1];
           */
           UILabel *intro= [self.view addLabel:cell.contentView
                     frame:CGRectMake(10, 10, 300, 0)
                      font:[UIFont systemFontOfSize:14]
                      text:[md objectForKey:@"Description"]
                     color:[UIColor blackColor]
                       tag:0];
            intro.lineBreakMode = UILineBreakModeWordWrap;
            intro.numberOfLines = 0;
            [intro sizeToFit];
        }
        
    }

    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
        return 80;

    if (indexPath.row==1) {
        return 50;
    }
    
    if (indexPath.row==2) {
        return 50;
    }
    
    if (indexPath.row==3) {
        return commentHeight;
    }

    return 0;
}





@end
