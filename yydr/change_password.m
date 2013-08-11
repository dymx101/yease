//
//  change_password.m
//  yydr
//
//  Created by liyi on 12-12-13.
//
//

#import "change_password.h"
#import "ASIFormDataRequest.h"
#import "UIView+iTextManager.h"
#import "UIView+GetRequestCookie.h" 
#import "KeychainItemWrapper.h"

@interface change_password ()

@end

@implementation change_password

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.labelText = @"正在提交，请稍等...";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    UIBarButtonItem *rbt=[[UIBarButtonItem alloc]initWithTitle:@"确认修改" style:UIBarButtonItemStylePlain target:self action:@selector(onRDown:)];
    self.navigationItem.rightBarButtonItem=rbt;

}


//按钮事件 -----------------------------------

-(void)onRDown:(id*)sender
{
    NSString *msg=@"ok";
    
    [OldPasswrod endEditing:YES];
    [ConfirmPassword endEditing:YES];
    [Password endEditing:YES];
    
    [HUD show:YES];
    
    if(OldPasswrod.text.length==0)
    {
        msg=@"请输入旧密码";
    }
    else if(Password.text.length==0)
    {
        msg=@"请输入新密码";
    }
    else if(Password.text.length<6||Password.text.length>10)
    {
        msg=@"请输入6－10位密码";
    }
    else if(![ConfirmPassword.text isEqualToString:Password.text])
    {
        msg=@"密码输入不一致";
    }

    
    if ([msg isEqualToString:@"ok"]) {

        NSString *str= [NSString stringWithFormat:@"%@Password",ServerURL];
     
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.timeOutSeconds=TIMEOUT;

        
        [request setPostValue:OldPasswrod.text forKey:@"OldPassword"];
        [request setPostValue:Password.text forKey:@"NewPassword"];
        [request setPostValue:ConfirmPassword.text forKey:@"ConfirmPassword"];
        
        [request setDelegate:self];
        
        NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
        if(ck!=nil)
        {
            [request setUseCookiePersistence:NO];
            [request setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
        }
        
        [request setRequestMethod:@"POST"];
        [request startAsynchronous];
        
    }
    else {
        
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

- (void)requestFailed:(ASIHTTPRequest *)r
{
    NSError *error = [r error];
    NSLog(@"change_password:%@",error);
    [HUD hide:YES];
    
    
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


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"修改");

    
    NSLog(@"%@",[request responseString]);
    
    int StatusCode=[request responseStatusCode];

    if(StatusCode==200)
    {
        //修改成功
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"yease"
                                                                           accessGroup:nil];
        [wrapper setObject:Password.text forKey:(__bridge id)kSecValueData];
        
        
       	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.labelText = @"修改成功";
        [HUD hide:YES afterDelay:1.5];
   
    }
    else
    {
        [HUD hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"当前密码错误"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    request=nil;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"switchcell"];
            
            //Add a UITextField
            UITextField *textField=[self.view addTextField:nil
                                                     frame:CGRectMake(0, 0, 170, 28)
                                                      font:[UIFont systemFontOfSize:15]
                                                     color:[UIColor blackColor]
                                               placeholder:nil
                                                       tag:indexPath.row+1000];
            
            textField.delegate=self;
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            switch (indexPath.row) {
                case 0:
                {
                    [[cell textLabel] setText:@"旧密码"];
                    textField.placeholder = @"请输入密码";
                    textField.returnKeyType = UIReturnKeyNext;
                    textField.secureTextEntry = YES;
                    OldPasswrod=textField;
                }
                    break;
                    
                case 1:
                {
                    [[cell textLabel] setText:@"新密码"];
                    textField.placeholder = @"6－10位";
                    textField.returnKeyType = UIReturnKeyNext;
                    textField.secureTextEntry = YES;
                    Password=textField;
                }
                    break;
                    
                case 2:
                {
                    [[cell textLabel] setText:@"确认新密码"];
                    textField.placeholder = @"请再次输入新密码";
                    textField.returnKeyType = UIReturnKeyDone;
                    textField.secureTextEntry = YES;
                    ConfirmPassword=textField;
                }
                    break;
            }
            
            cell.accessoryView=textField;
            
        }
        
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField.tag==1000)
    {
        [Password becomeFirstResponder];
    }
    
    if(textField.tag==1001)
    {
        [ConfirmPassword becomeFirstResponder];
    }
    
    if(textField.tag==1002)
    {
        [ConfirmPassword endEditing:YES];
    }
    
    return YES;
}

@end
