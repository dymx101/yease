//
//  member.m
//  yydr
//
//  Created by 毅 李 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "login.h"
#import "reg.h"
#import "forget_password.h"
#import "UIView+iButtonManager.h"
#import "UIView+iImageManager.h"
#import "UIView+iTextManager.h"
#import "ASIHTTPRequestDelegate.h"
#import "KeychainItemWrapper.h"
#import "AppDelegate.h"
#import "dbHelper.h"

#import "homepage.h"

@interface login ()

@end

@implementation login

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    self.title=@"夜色";


    [self.view addTapEvent:self.view
                    target:self
                    action:@selector(onTap:)];
    
    
    //self.navigationController.navigationBar.tintColor = [UIColor redColor];
 
   // self.navigationController.navigationItem.backBarButtonItem.tintColor=[UIColor redColor];
    
    
    UIBarButtonItem * lb = [[UIBarButtonItem alloc]initWithTitle:@"注册"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(onRegDown:)];
    lb.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = lb;
    
    
    UIBarButtonItem * rb = [[UIBarButtonItem alloc]initWithTitle:@"登入"
                                                           style:UIBarButtonItemStyleDone
                                                          target:self
                                                          action:@selector(onLoginDown:)];
    rb.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rb;

}


-(void)onTap:(id)sender
{
    [UserName endEditing:YES];
    [Password endEditing:YES];
}


//定位
-(void)StartLoc
{
    HUD.mode=MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在定位，请稍等...";
    
    if ([CLLocationManager locationServicesEnabled])
    {
        locManager.delegate=self;
        [locManager startUpdatingLocation];
    }
    else
    {
        [self locFailed];
    }

}
#pragma mark –
#pragma mark 开始定位
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"loc");
    
    [locManager stopUpdatingLocation];
    locManager.delegate=nil;
    
    float glat=newLocation.coordinate.latitude;
    float glng=newLocation.coordinate.longitude;
    
    HUD.mode =MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在登入，请稍等...";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@User?glat=%f&glng=%f",ServerURL,glat,glng]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.timeOutSeconds=TIMEOUT;
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:UserName.text forKey:@"UserName"];
    [request setPostValue:Password.text forKey:@"PassWord"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"]
                   forKey:@"DeviceToken"];
    
    [request setPostValue:@"iPhone"
                   forKey:@"DeviceType"];
    
    [request setDelegate:self];
    [request startAsynchronous];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
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


//定位功能没打开
-(void)locFailed
{
    HUD.delegate=nil;
    [HUD hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先开启定位功能"
                                                    message:@"设置->隐私->定位服务->开启定位"
                                                   delegate:self
                                          cancelButtonTitle:@"确定" //NSLocalizedString( @"Close", @"Close" )
                                          otherButtonTitles:nil];
    [alert show];
}



- (void)viewWillAppear:(BOOL)animated
{
    
    
    id cookie =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"Value"];
    

    if( cookie && ![cookie isKindOfClass:[NSNull class]] )
    {
        homepage *p=[[homepage alloc] init];
        [self.navigationController pushViewController:p
                                             animated:NO];
        
        //特殊...
        [p showSearchBar];
    }
    
    
}



//-----------------------------------------------------------------------------------------------------------------------

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


-(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(XMPPStream *)xmppStream{
    return [[self appDelegate] xmppStream];
}


//按钮事件 -----------------------------------

-(void)onLDown:(id*)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


-(void)onRDown:(id*)sender
{
    //去忘记密码页面
    forget_password *mm = [[forget_password alloc] initWithStyle:UITableViewStyleGrouped];
    mm.title=@"找回密码";
    [self.navigationController pushViewController:mm animated:YES];
}



//------------------------------------------------------------------------------------------------
//去注册页面
//------------------------------------------------------------------------------------------------
-(void)onRegDown:(id)sender
{
     reg *mm = [[reg alloc] initWithStyle:UITableViewStyleGrouped];
     mm.title=@"注册";
     [self.navigationController pushViewController:mm
                                          animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag==1000)
    {
        [Password becomeFirstResponder];
    }
    
    if(textField.tag==1001)
    {
        [Password endEditing:YES];
    }
    
    return YES;
}

-(void)onLoginDown:(id)sender
{
    
    NSString *msg=@"ok";
    
    [UserName endEditing:YES];
    [Password endEditing:YES];
    
    [HUD show:YES];
    
    if(UserName.text.length==0)
    {
        msg=@"请输入用户名";
    }
    else if(Password.text.length==0)
    {
        msg=@"请输入密码";
    }
    
    if ([msg isEqualToString:@"ok"]) {
        [self StartLoc];
    }
    else
    {
        [HUD hide:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

//请求回调 ---------------------------------------------------------------------------------------------------
- (void)requestReceivedResponseHeaders:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request responseHeaders]);
}

- (void)requestFailed:(ASIHTTPRequest *)r
{
    [HUD hide:YES];
    

    //网络不好跳出提示
    MBProgressHUD *AlertHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:AlertHUD];
    AlertHUD.labelText = ConnectionFailure;
    AlertHUD.mode = MBProgressHUDModeCustomView;
    AlertHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert"]];
    [AlertHUD show:YES];
    [AlertHUD hide:YES afterDelay:1.5];
    
    [r clearDelegatesAndCancel];
    r=nil;
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    NSData *jsonData = [request responseData];

    int StatusCode=[request responseStatusCode];

    NSLog(@"StatusCode=%d %@",StatusCode,[request responseString]);
    
    if(StatusCode==200)
    {
        NSError *error = nil;
        NSDictionary *userinfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        
        NSLog(@"登入后返回信息:%@",userinfo);
        
        //记录登入信息
        
        int UserId=[[userinfo objectForKey:@"UserId"] integerValue];
        

        //UserId
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:UserId]
                                                  forKey:@"UserId"];


        //更新sqlite
        dbHelper *dh=[[dbHelper alloc] init];
        [dh updateUserInfo:userinfo];
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[userinfo objectForKey:@"City"]
                                                  forKey:@"City"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[userinfo objectForKey:@"CityId"]
                                                  forKey:@"CityId"];
        
        
          
        //经纬度
        [[NSUserDefaults standardUserDefaults] setObject:[userinfo objectForKey:@"Glat"]
                                                  forKey:@"Glat"];

        [[NSUserDefaults standardUserDefaults] setObject:[userinfo objectForKey:@"Glng"]
                                                  forKey:@"Glng"];
        
        
        
        NSArray *ck=[request responseCookies];
        NSLog(@"%@",ck);
        
        [[NSUserDefaults standardUserDefaults] setObject:[[ck objectAtIndex:0] valueForKey:@"value"]
                                                  forKey:@"Value"];

        //登入成功
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.labelText = @"登入成功";
        
        
        
        

        /////////////////////////////////////////
        //保存用户名/密码 聊天测试
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"yease"
                                                                           accessGroup:nil];
        [wrapper setObject:UserName.text forKey:(__bridge id)kSecAttrAccount];
        [wrapper setObject:Password.text forKey:(__bridge id)kSecValueData];
        
        /////////////////////////////////////////
        //连接xmpp服务器
        /////////////////////////////////////////
        
        //[[self appDelegate] disconnect];
        [[self appDelegate] connect:[NSString stringWithFormat:@"%@@%@",UserName.text,XMPPServer]
                           password:Password.text];
        
        
        [HUD hide:YES afterDelay:1];
    }
    else
    {
        HUD.delegate=nil;
        [HUD hide:YES];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"用户名或密码输入错误"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        request=nil;
    }
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    AppDelegate *ad=[self appDelegate];
    [ad.notifierView hide];
    
    
    UserName.text=@"";
    Password.text=@"";
    
    
    homepage *p=[[homepage alloc] init];
    [self.navigationController pushViewController:p
                                         animated:NO];
}




//-----------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"switchcell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"switchcell"];
    
    // Add a UITextField
    UITextField *textField = [self.view addTextField:nil
                                               frame:CGRectMake(0, 0, 210, 28)
                                                font:[UIFont systemFontOfSize:15]
                                               color:[UIColor blackColor]
                                         placeholder:nil
                                                 tag:indexPath.row+1000];
    
    textField.delegate=self;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
        {
            [[cell textLabel] setText:@"用户名"];
            textField.returnKeyType = UIReturnKeyNext;
            UserName=textField;
        }
            break;
            
        case 1:
        {
            [[cell textLabel] setText:@"密码"];
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            Password=textField;
        }
            break;
    }
    
    cell.accessoryView=textField;
    
    return cell;
}


@end
