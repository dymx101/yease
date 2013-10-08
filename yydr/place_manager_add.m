//
//  place_tel_add.m
//  yydr
//
//  Created by liyi on 13-2-16.
//
//

#import "place_manager_add.h"
#import "UIView+iTextManager.h"
#import "UIView+iButtonManager.h"
#import "UIView+iImageManager.h"
#import "UIView+GetRequestCookie.h"
#import "ASIFormDataRequest.h"
#import "global.h"
#import "login.h"

@interface place_manager_add ()

@end

@implementation place_manager_add

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    


    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onBack:)
                                                              target:self];
    
    
    self.navigationItem.rightBarButtonItem=[self.view add_ok_button:@selector(onRDown:)
                                                              target:self];
    
    
    [self.view addTapEvent:self.view
                    target:self
                    action:@selector(onTap:)];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"正在提交，请稍等...";
    
    waiting=NO;
    
}

-(void)onBack:(id)sender
{
    if(waiting)
        return;
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


//提交请求
-(void)onRDown:(id*)sender
{
    if(waiting)
        return;
    
    NSLog(@"添加新场馆");
    
    [HUD show:YES];
    
    //结束编辑
    [tel endEditing:YES];
    [qq endEditing:YES];
    [off endEditing:YES];
    [body endEditing:YES];
    
    //开始提交
    NSString *msg=@"ok";
    
    if(tel.text.length==0)
    {
        msg=@"请输入手机号码";
    }
    else if(qq.text.length==0)
    {
        msg=@"请输入QQ号";
    }
    else if(off.text.length==0)
    {
        msg=@"请输入优惠信息";
    }
//    else if(body.text.length==0)
//    {
//        msg=@"请输入服务介绍";
//    }
//    else if(body.text.length<10)
//    {
//        msg=@"服务内容太少啦～多写点吧（10字以上）";
//    }
    else if(off.text.length>15)
    {
        msg=@"优惠信息太长（15字内）";
    }
    else if(tel.text.length>15)
    {
        msg=@"请输入正确的手机";
    }
    else if(tel.text.length>15)
    {
        msg=@"请输入正确的QQ";
    }
    
    if ([msg isEqualToString:@"ok"]) {
        
        NSLog(@"通过验证，可提交");
        
        NSString *s=[NSString stringWithFormat:@"%@PlaceManager",ServerURL];
        NSURL *url = [NSURL URLWithString:s];
        NSLog(@"%@",url);
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.timeOutSeconds=TIMEOUT;
        [request setRequestMethod:@"POST"];
        
        
        
        //手机
        [request setPostValue:tel.text
                       forKey:@"ManagerMobile"];
        
        //qq号码
        [request setPostValue:qq.text
                       forKey:@"ManagerQQ"];
        
        //优惠
        [request setPostValue:off.text
                       forKey:@"Off"];
        
        //描述
       [request setPostValue:@"无内容"
                      forKey:@"Description"];
        
        
        //PlaceId
        [request setPostValue:[NSNumber numberWithInt:PlaceId]
                       forKey:@"PlaceId"];
        
        
        NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
        
        if(ck!=nil)
        {
            [request setUseCookiePersistence:NO];
            [request setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
        }
 
        
        [request setDelegate:self];
        [request startAsynchronous];
        
        waiting=YES;
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


-(void)setPlaceId:(int)pid
{
    PlaceId=pid;
}


//请求回调 ---------------------------------------------------------------------------------------------------
- (void)requestFailed:(ASIHTTPRequest *)r
{
    waiting=NO;
    
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
            //跳出提示
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
    
    //停止查询
    [r clearDelegatesAndCancel];
    r=nil;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    int StatusCode=[request responseStatusCode];

    NSLog(@"%d",StatusCode);
    
    
    
    
    switch (StatusCode) {
        case 201:
        {
            //注册成功
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.delegate = self;
            HUD.labelText = @"添加成功,我们将会尽快审核";
            [HUD hide:YES afterDelay:1.5];
        }
            break;
            
        case 302:
        {
            //注册成功
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"无法加入,你已是其他场所的经理";
            [HUD hide:YES afterDelay:1.5];
            waiting=NO;
        }
            break;
        default:
        {
            [HUD hide:YES];
            //注册失败
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[request responseString]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            waiting=NO;
        }
            break;
    }
    
        
    request=nil;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onTap:(UIGestureRecognizer*)sender
{
    [off endEditing:YES];
    [tel endEditing:YES];
    [qq endEditing:YES];
    [body endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 2;

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section==0)
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"cell0"];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            switch (indexPath.row) {                    
                case 0:
                {
                    tel=[self.view addTextField:nil
                                          frame:CGRectMake(0, 0, 220, 28)
                                           font:[UIFont systemFontOfSize:15]
                                          color:[UIColor blackColor]
                                    placeholder:nil
                                            tag:indexPath.row+1000];
                    
                    tel.placeholder=@"必填";
                    cell.accessoryView=tel;
                    [[cell textLabel] setText:@"手机"];
                    
                    tel.returnKeyType = UIReturnKeyNext;
                    [tel setKeyboardType:UIKeyboardTypeNumberPad];
                    tel.delegate=self;
                    
                }
                    break;
                case 1:
                {
                    qq=[self.view addTextField:nil
                                          frame:CGRectMake(0, 0, 220, 28)
                                           font:[UIFont systemFontOfSize:15]
                                          color:[UIColor blackColor]
                                   placeholder:nil
                                            tag:indexPath.row+1000];
                    qq.placeholder=@"必填";
                    qq.returnKeyType = UIReturnKeyNext;
                    [qq setKeyboardType:UIKeyboardTypeNumberPad];
                    qq.delegate=self;

                    
                    cell.accessoryView=qq;
                    [[cell textLabel] setText:@"QQ号"];
                }
                    break;    
            }
        }
        
    }
    else if(indexPath.section==1)
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"cell1"];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
            off=[self.view addTextField:nil
                                  frame:CGRectMake(0, 0, 220, 28)
                                   font:[UIFont systemFontOfSize:15]
                                  color:[UIColor blackColor]
                            placeholder:nil
                                    tag:1101];
            
            off.placeholder=@"15字内";
            cell.accessoryView=off;
            [[cell textLabel] setText:@"优惠"];
            off.returnKeyType = UIReturnKeyNext;
            off.delegate=self;
            
            
        }
        
    }
    
    else if(indexPath.section==2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"cell2"];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            body=nil;
            body = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 5, 290, 150)];
            body.backgroundColor=[UIColor clearColor];
            body.font = [UIFont systemFontOfSize:15.0f];
            body.delegate=self;
            body.tag=1102;
            body.placeholder=@"介绍内容请遵守各项有关《国家法律法规》";
            
            [cell.contentView addSubview:body];
            
        }
        
    }
    
    return cell;

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSLog(@"%d",textField.tag);
    
    
    if(textField.tag==1101)
    {
        [body becomeFirstResponder];
    }
    
    else if(textField.tag==1102)
    {
        [body endEditing:YES];
    }
    return YES;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==2)
    {
         return 30;
    }
    return 0;
}


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        return 165;
    }
    return 50;
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * hView;
    
    hView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, 300, 30)];
    
    switch (section) {
        case 2:
        {
            UILabel *l=[[UILabel alloc] initWithFrame:hView.frame];
            l.backgroundColor=[UIColor clearColor];
            l.text=@"服务介绍(10字以上):";
            l.font=[UIFont boldSystemFontOfSize:16];
            [hView addSubview:l];
        }
            break;
            
    }
    
    return hView;
}

@end
