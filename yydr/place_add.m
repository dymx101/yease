//
//  place_add.m
//  yydr
//
//  Created by liyi on 13-2-13.
//
//

#import "place_add.h"
#import "place_add_map.h"
#import "login.h"
#import "global.h"

#import "UIView+GetRequestCookie.h"
#import "UIView+iImageManager.h"
#import "UIView+iTextManager.h"
#import "UIView+iButtonManager.h"



@interface place_add ()

@end

@implementation place_add

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0"
                                                  forKey:@"lat"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0"
                                                  forKey:@"lng"];

        waiting=NO;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    lat=[[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"] doubleValue];
    lng=[[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"] doubleValue];
    
    if(lat>0)
    {
        loc.text=[NSString stringWithFormat:@"%.4f，%.4f",lat,lng];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundView= [self.view addImageView:nil
                                                     image:@"place_tel_bbg.png"
                                                  position:CGPointMake(0, 0)];

    
    //返回按钮
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onLDown:) target:self];

    //确认
    self.navigationItem.rightBarButtonItem=[self.view add_ok_button:@selector(onRDown:) target:self];

    /*
    UIView *fv=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.tableView.tableFooterView=fv;

    UILabel *explain=[self.view addLabel:fv
                                   frame:CGRectMake(15, 0, 300, 20)
                                    font:[UIFont systemFontOfSize:14]
                                    text:@"目前仅限上海，其他地区业务合作请联系客服。"
                                   color:[UIColor blackColor]
                                     tag:0];
    explain.shadowColor=[UIColor whiteColor];
    explain.shadowOffset=CGSizeMake(0, 1);
    */
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在提交，请稍等...";

}

-(void)onLDown:(id*)sender
{
    if(waiting)
        return;
    
    [self.navigationController popViewControllerAnimated:YES];
}


//提交请求
-(void)onRDown:(id*)sender
{
    if(waiting)
    {
        return;
    }
    
    
    
    NSLog(@"添加新场馆");
    
    [HUD show:YES];
    
    //结束编辑
    [name endEditing:YES];
    [address endEditing:YES];
    [price endEditing:YES];
    [contact endEditing:YES];
    
    //开始提交
    NSString *msg=@"ok";
    
    if(name.text.length==0)
    {
        msg=@"请输入场所名称";
    }
    else if(category.text.length==0)
    {
        msg=@"请选择分类";
    }
    else if(area.text.length==0)
    {
        msg=@"请选择区域";
    }
    else if(address.text.length==0)
    {
        msg=@"请输入地址";
    }
    else if(price.text.length==0)
    {
        msg=@"请输入人均";
    }
    else if(lat==0||lng==0)
    {
        msg=@"请定位场所";
    }
    else if(contact.text.length==0)
    {
        msg=@"请留下您的QQ号方便我们及时确认信息";
    }

    if ([msg isEqualToString:@"ok"]) {
        
        NSLog(@"通过验证，可提交");
       
        NSString *s=[NSString stringWithFormat:@"%@Place",ServerURL];
        NSURL *url = [NSURL URLWithString:[s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.timeOutSeconds=TIMEOUT;
        [request setRequestMethod:@"POST"];
        
        [request setPostValue:name.text
                       forKey:@"Name"];
        
        [request setPostValue:address.text
                       forKey:@"Address"];
        
        [request setPostValue:[NSString stringWithFormat:@"%d",area_id]
                       forKey:@"AreaId"];

        [request setPostValue:[NSString stringWithFormat:@"%d",category_id]
                       forKey:@"CategoryId"];
        
        [request setPostValue:price.text
                       forKey:@"Price"];
        //新
        [request setPostValue:[NSString stringWithFormat:@"%f",lat]
                       forKey:@"Glat"];
        
        [request setPostValue:[NSString stringWithFormat:@"%f",lng]
                       forKey:@"Glng"];
        
        
        //发布者QQ
        [request setPostValue:contact.text
                       forKey:@"CreatorQQ"];
        
        
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

//请求回调 ---------------------------------------------------------------------------------------------------
- (void)requestFailed:(ASIHTTPRequest *)r
{
    [HUD hide:YES];
    waiting=NO;
    
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
    
    waiting=NO;
    
    if(StatusCode==201)
    {
        //注册成功
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.labelText = @"添加成功,我们将会尽快审核";
        [HUD hide:YES afterDelay:1.5];
    }
    else
    {
        [HUD hide:YES];
        //注册失败
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[request responseString]
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        return 7;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    
    if (cell == nil)
    {        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"cell0"];

        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
     
        
        if(indexPath.section==0)
        {
            switch (indexPath.row) {
                case 0:
                {
                    [[cell textLabel] setText:@"名称"];
                    
                    name =[self.view addTextField:nil
                                       frame:CGRectMake(0, 0, 230, 28)
                                        font:[UIFont systemFontOfSize:15]
                                       color:[UIColor blackColor]
                                      placeholder:@"请输入完整的场所名称"
                                         tag:indexPath.row+1000];
                    name.returnKeyType = UIReturnKeyNext;
                    name.delegate=self;
                    cell.accessoryView=name;
                }
                    break;
                    
                case 1:
                {
                    [[cell textLabel] setText:@"分类"];
                    
                    category=[self.view addLabel:cell.contentView
                                           frame:CGRectMake(0, 0, 150, 28)
                                            font:[UIFont systemFontOfSize:15]
                                            text:@""
                                           color:[UIColor blackColor]
                                             tag:1001];
                    category.center=CGPointMake(137, cell.contentView.center.y-1);
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                
                    
                case 2:
                {
                    [[cell textLabel] setText:@"城市"];
                    
                    UILabel *city=[self.view addLabel:cell.contentView
                                  frame:CGRectMake(0, 0, 150, 28)
                                   font:[UIFont systemFontOfSize:15]
                                   text:[[NSUserDefaults standardUserDefaults] objectForKey:@"City"]
                                  color:[UIColor blackColor]
                                    tag:0];
                     city.center=CGPointMake(137, cell.contentView.center.y-1);
                }
                    break;
                    
                    
                case 3:
                {
                    [[cell textLabel] setText:@"区域"];
                    
                    area=[self.view addLabel:cell.contentView
                                       frame:CGRectMake(0, 0, 150, 28)
                                        font:[UIFont systemFontOfSize:15]
                                        text:@""
                                       color:[UIColor blackColor]
                                         tag:1002];
                    area.center=CGPointMake(137, cell.contentView.center.y-1);
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                    
                case 4:
                {
                    [[cell textLabel] setText:@"地址"];
                    address=[self.view addTextField:nil
                                              frame:CGRectMake(0, 0, 230, 28)
                                               font:[UIFont systemFontOfSize:15]
                                              color:[UIColor blackColor]
                                        placeholder:@"请输入非常详细的地址"
                                                tag:indexPath.row+1000];
                    address.returnKeyType = UIReturnKeyNext;
                    address.delegate=self;
                
                    cell.accessoryView=address;
                }
                    break;
                    
                case 5:
                {
                    [[cell textLabel] setText:@"定位"];
                    loc=[self.view addLabel:cell.contentView
                                       frame:CGRectMake(0, 0, 150, 28)
                                        font:[UIFont systemFontOfSize:15]
                                        text:@""
                                       color:[UIColor blackColor]
                                         tag:1002];
                    loc.center=CGPointMake(137, cell.contentView.center.y-1);
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                    
                case 6:
                {
                    [[cell textLabel] setText:@"人均"];
                    
                    
              
                    price=[self.view addTextField:nil
                                            frame:CGRectMake(0, 0, 230, 28)
                                             font:[UIFont systemFontOfSize:15]
                                            color:[UIColor blackColor]
                                      placeholder:nil
                                              tag:indexPath.row+1000];
             
                    
                    cell.accessoryView=price;
                    price.returnKeyType = UIReturnKeyDone;
                    price.delegate=self;

                    price.keyboardType=UIKeyboardTypeNumberPad;
                }
                    break;
            }
        }
        else
        {
            [[cell textLabel] setText:@"QQ"];
            contact=[self.view addTextField:nil
                                      frame:CGRectMake(0, 0, 230, 28)
                                       font:[UIFont systemFontOfSize:15]
                                      color:[UIColor blackColor]
                                placeholder:nil
                                        tag:2000];
            contact.keyboardType=UIKeyboardTypeNumberPad;
            contact.placeholder=@"请输入您的QQ号";
            cell.accessoryView=contact;
        }
    }
    
    return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField.tag==1000)
    {
        [address becomeFirstResponder];
    }
    
    if(textField.tag==1003)
    {
        [price becomeFirstResponder];
    }
    
    if(textField.tag==1004)
    {
        [price endEditing:YES];
    }
    
    
    return YES;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [name endEditing:YES];
    [address endEditing:YES];
    [price endEditing:YES];
    
    switch (indexPath.row) {
        
        case 1:
        {
            place_category_list *actionSheet = [[place_category_list alloc] initWithTitle:@"选择分类"
                                                                         delegate:nil
                                                                cancelButtonTitle:nil
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:nil];
            
            [actionSheet loadCategoryWithAll:NO Selected:currentCategorySelectRow];
            
            actionSheet.categoryDelegate=self;
            [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
            [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
        }
            break;
            
        case 3:
        {
            place_area_list *actionSheet = [[place_area_list alloc] initWithTitle:@"选择区域"
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];
            
            [actionSheet loadAreaWithAll:NO Selected:currentAreaSelectRow];
            
            actionSheet.areaDelegate=self;
            [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
            [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
        }
            break;
            
        case 5:
        {
            //签名
            place_add_map *mm = [[place_add_map alloc] init];
            mm.title=@"定位";
            [self.navigationController pushViewController:mm animated:YES];
        }
            break;
    }
}

-(void)CategorySelected:(NSString *)at Category_id:(int)cid SelectRow:(int)csr
{
    NSLog(@"%@:%d",at,cid);
    category.text=at;
    category_id=cid;
    currentCategorySelectRow=csr;
}

-(void) AreaSelected:(NSString *)at Area_id:(int)aid SelectRow:(int)csr
{
    NSLog(@"%@:%d",at,aid);
    area.text=at;
    area_id=aid;
    currentAreaSelectRow=csr;
}


@end
