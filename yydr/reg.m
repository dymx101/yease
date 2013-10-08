//
//  reg.m
//  yydr
//
//  Created by 毅 李 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "reg.h"
#import "homepage.h"
#import "global.h"

#import "UIView+iTextManager.h"
#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"

@interface reg ()

@end

@implementation reg

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        sexNum=0;
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.tableView.backgroundView= [self.view addImageView:nil
//                                                     image:@"place_tel_bbg.png"
//                                                  position:CGPointMake(0, 0)];
//    

//    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onLDown:) target:self];
    
    
    
    UIBarButtonItem * backBtn1 = [[UIBarButtonItem alloc]initWithTitle:@"完成"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(onRegButtonDown:)];
    
    self.navigationItem.rightBarButtonItem = backBtn1;
    
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"正在提交，请稍等...";
    
    [self.view addTapEvent:self.view target:self action:@selector(onTap:)];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section==0)
        return 4;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"switchcell"];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"switchcell"];
            
           

            //Add a UITextField
            UITextField *textField=[self.view addTextField:nil
                                                     frame:CGRectMake(0, 0, 200, 28)
                                                      font:[UIFont systemFontOfSize:15]
                                                     color:[UIColor blackColor]
                                               placeholder:nil
                                                       tag:indexPath.row+1000];

            textField.delegate=self;
            //垂直居中
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            switch (indexPath.row) {
                case 0:
                {
                    [[cell textLabel] setText:@"用户名"];
                    textField.placeholder = @"2－30位中文、英文或数字";
                    textField.returnKeyType = UIReturnKeyNext;
                    UserName=textField;
                }
                    break;
                  
                 /*
                case 1:
                {
                    [[cell textLabel] setText:@"手机"];
                    
                    textField.placeholder = @"输入11位手机号码";
                    textField.returnKeyType = UIReturnKeyNext;
                    textField.keyboardType=UIKeyboardTypeNumberPad;
                    Mobile=textField;
                }
                    break;
                  */
                    
                case 1:
                {
                    [[cell textLabel] setText:@"性别"];
                    textField.placeholder = @"点击选择";

                    [self.view addTapEvent:textField
                                    target:self
                                    action:@selector(onSelectSex:)];
                    
                    
                }
                    break;
                    
                    
                case 2:
                {
                    [[cell textLabel] setText:@"密码"];
                    
                    textField.placeholder = @"6－10位";
                    textField.returnKeyType = UIReturnKeyNext;
                    textField.secureTextEntry = YES;
                    Password=textField;
                }
                    break;
                case 3:
                {
                    [[cell textLabel] setText:@"确认密码"];
                    
                    textField.placeholder = @"请再次输入密码";
                    textField.returnKeyType = UIReturnKeyDone;
                    textField.secureTextEntry = YES;
                    ConfirmPassword=textField;
                }
                    break;
            }
            
        cell.accessoryView=textField;

        }
    }
    
    return  cell;
}


-(void)onSelectSex:(id)sender
{
    [UserName endEditing:YES];
    [Mobile endEditing:YES];
    [Password endEditing:YES];
    [ConfirmPassword endEditing:YES];
    
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"男",@"女",nil];
    [menu showInView:self.view];
 
}





//排序
- (void)actionSheet:(UIActionSheet *)as didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    
      
    UITextField *sex=(UITextField*)[self.view viewWithTag:1001];
    
    switch (buttonIndex) {
        case 0:
        {
            sex.text=@"男";
            sexNum=1;
        }
            break;
            
        case 1:
        {
            sex.text=@"女";
            sexNum=2;
        }
            break;
    }
    
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



-(void)onTap:(UIGestureRecognizer*)sender
{
    [UserName endEditing:YES];
    [Email endEditing:YES];
    [Password endEditing:YES];
    [ConfirmPassword endEditing:YES];
    [Mobile endEditing:YES];
}




//footer -----------------------------------
-(void)onRegButtonDown:(id*)sender
{
    NSLog(@"注册");
    
    
    [HUD show:YES];
    
    //结束编辑
    [UserName endEditing:YES];
    [Mobile endEditing:YES];
    [Password endEditing:YES];
    [ConfirmPassword endEditing:YES];
    
    //开始提交
    NSString *msg=@"ok";
    
    if(UserName.text.length==0)
    {
        msg=@"请输入用户名";    
    }
    else if(sexNum==0)
    {
        msg=@"请选择性别";
    }
    else if(Password.text.length==0)
    {
        msg=@"请输入密码";    
    }
    else if([Password.text isEqualToString:ConfirmPassword.text]==NO)
    {
        msg=@"密码输入不一致";
    }
    /*
    else if(Mobile.text.length==0)
    {
        msg=@"请输入手机号码";    
    }
    */
    else if(Password.text.length<6||Password.text.length>20)
    {
        msg=@"请输入6－20位密码";
    }
    else if([self validUsername:UserName.text]==NO)
    {
        msg=@"请输入2－30位中文、英文或数字的用户名";
    }

    /*
    else if([self validMobile:Mobile.text]==NO)
    {
        msg=@"请输入正确的手机号码";
    }*/
    
    if ([msg isEqualToString:@"ok"]) {
        
        
        
        NSString *s=[NSString stringWithFormat:@"%@register?Sex=%d",ServerURL,sexNum];
        NSURL *url = [NSURL URLWithString:[s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"通过验证，可提交 url=%@",url);
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.timeOutSeconds=TIMEOUT;
        
        
        [request setPostValue:UserName.text forKey:@"UserName"];
        [request setPostValue:Password.text forKey:@"Password"];
        [request setPostValue:Password.text forKey:@"ConfimPassword"];
        
        [request setRequestMethod:@"POST"];
        
        
        [request setDelegate:self];
        [request startAsynchronous];
        
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



-(BOOL) validMobile:(NSString *)mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    // NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

-(BOOL) validUsername:(NSString *)un {
    NSString *regex3 = @"^[\\u4E00-\\u9FA5\\uF900-\\uFA2D\\w]{2,30}$";
    NSPredicate * pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex3];
    return [pred3 evaluateWithObject:un];
}

//验证email格式
-(BOOL) validEmail:(NSString*) emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    NSLog(@"%i", regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else
        return YES;
}

//请求回调 ---------------------------------------------------------------------------------------------------
- (void)requestFailed:(ASIHTTPRequest *)r
{
    NSError *error = [r error];
    NSLog(@"reg:%@",error);

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
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    // Use when fetching binary data
    NSData *jsonData = [request responseData];
    
    NSLog(@"%@",responseString);

    //解析JSon
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];

    if ([[jsonObject objectForKey:@"Message"] isEqualToString:@"ok"]){
        
            //注册成功
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.delegate = self;
            HUD.labelText = @"注册成功";
            [HUD hide:YES afterDelay:1];
        
        }
        else
        {
            [HUD hide:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[jsonObject objectForKey:@"Message"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
        }

    request=nil;
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    //返回到登入界面
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self disablesAutomaticKeyboardDismissal];
}



@end
