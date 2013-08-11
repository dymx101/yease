//
//  setting.m
//  yydr
//
//  Created by 毅 李 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "setting.h"
#import "about_us.h"
#import "Harpy.h"
#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"
#import "ASIFormDataRequest.h"
#import "KeychainItemWrapper.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "AppDelegate.h"
#import "global.h"

@interface setting ()

@end

@implementation setting

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
    }
    return self;
}


//用户退出
-(void)onSignUpDown:(id*)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定要退出吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定退出",nil];
    [alertView show];
}


-(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(XMPPStream *)xmppStream{
    return [[self appDelegate] xmppStream];
}


//按钮事件 -----------------------------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"%d %d",buttonIndex,alertView.tag);
    
    switch (buttonIndex) {
        case 1:
        {
            if(alertView.tag==1001)
            {
                [SDWebImageManager.sharedManager.imageCache clearMemory];
                [SDWebImageManager.sharedManager.imageCache clearDisk];

            }
            else
            {
               
                //清除cookie
                [[NSUserDefaults standardUserDefaults] setObject:nil
                                                          forKey:@"Value"];
                //id
                [[NSUserDefaults standardUserDefaults] setObject:nil
                                                          forKey:@"UserId"];
                
                
                //////////////////////////////////////////
                //清除用户名与密码 聊天测试
                KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"yease"
                                                                                   accessGroup:nil];
                [wrapper resetKeychainItem];
                
                [[self appDelegate] disconnect];
                //////////////////////////////////////////
                
                
                
                //设备Token注销
                NSString *dt=   [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@user?DeviceToken=%@",ServerURL,dt]];
                
                NSLog(@"%@",url);
                
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                request.tag=3301;
                request.timeOutSeconds=TIMEOUT;
                [request setDelegate:nil];
                [request setRequestMethod:@"DELETE"];
                [request startAsynchronous];
                [request requestCookies];
                
                HUD.labelText = @"正在退出，请稍等...";
                HUD.delegate = self;
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
            }
        }
            break;
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popToRootViewControllerAnimated:NO];
}





//请求回调 ---------------------------------------------------------------------------------------------------
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
    //登入成功
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = @"退出成功";
    [HUD hide:YES afterDelay:1];
    
    request=nil;
      
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundView= [self.view addImageView:nil
                                                     image:@"place_tel_bbg.png"
                                                  position:CGPointMake(0, 0)];
    
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onLDown:)
                                                              target:self];
    
    self.navigationItem.rightBarButtonItem=[self.view add_logout_button:@selector(onSignUpDown:)
                                                                 target:self];
}

-(void)onLDown:(id*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }

    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"cell0"];
    }
    
    if(indexPath.section==0)
    {
        switch (indexPath.row) {
                
            case 0:
            {
                [[cell textLabel] setText:@"清除图片缓存"];
            }
                break;
                
            case 1:
            {
                [[cell textLabel] setText:@"检查新版本"];
            }
                break;
                
            case 2:
            {
                [[cell textLabel] setText:@"给夜色评分"];
            }
                break;
        }
    }
    else  if(indexPath.section==1)
    {
        [[cell textLabel] setText:@"关于我们"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section==1)
    {
        about_us *mm = [[about_us alloc] initWithStyle:UITableViewStyleGrouped];
        mm.title=@"关于我们";
        [self.navigationController pushViewController:mm animated:YES];
        return;
    }
    

    switch (indexPath.row) {
        case 0:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"确定要清除吗？"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定清除",nil];
            alertView.tag=1001;
            [alertView show];
        }
            break;
            
        case 1:
        {
            //检查版本
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [Harpy checkVersion:YES];
        }
            break;
            
        case 2:
        {
            //评分
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=604911738&type=Purple+Software"]];
        }
            break;
    }
}



@end
