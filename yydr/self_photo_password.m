//
//  self_photo_password.m
//  yydr
//
//  Created by liyi on 13-5-25.
//
//

#import "self_photo_password.h"
#import "UIView+iImageManager.h"
#import "UIView+iTextManager.h"
#import "dbHelper.h"
#import "global.h"
#import "UIView+GetRequestCookie.h"
#import "UIView+iButtonManager.h"



@interface self_photo_password ()

@end

@implementation self_photo_password
@synthesize request;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        rowCount=1;
        password=0;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title=@"访问限制";
    

    
    self.navigationItem.rightBarButtonItem=[self.view add_ok_button:@selector(onRDown:)
                                                             target:self];
    
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onLDown:)
                                                              target:self];
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在提交，请稍等...";

        
}


-(void)onLDown:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    int userid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];
    
    dh=[[dbHelper alloc] init];
    password=[dh getAlbumPassword:userid];
    
    NSLog(@"pppp===%d",password);
    
    switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    [switchview addTarget:self
                   action:@selector(switchChanged:)
         forControlEvents:UIControlEventValueChanged];
    
    
    
    psTextField=[self.view addTextField:nil
                                  frame:CGRectMake(0, 0, 170, 28)
                                   font:[UIFont systemFontOfSize:15]
                                  color:[UIColor blackColor]
                            placeholder:nil
                                    tag:1000];
    psTextField.delegate=self;
    
    psTextField.placeholder = @"4位数字";
    psTextField.returnKeyType = UIReturnKeyNext;
    psTextField.keyboardType=UIKeyboardTypeNumberPad;

    
    
    if (password>0) {
        
        psTextField.text=[NSString stringWithFormat:@"%d",password];
        rowCount=2;
        switchview.on=YES;
        
        [self.tableView reloadData];
    }

}



-(void)onRDown:(UIButton*)sender
{
    
    [HUD show:YES];
    
    //开始提交
    NSString *msg=@"ok";
    [psTextField endEditing:YES];
    
    if(psTextField.text.length<4&&switchview.on==YES)
    {
        msg=@"请输入4位数字密码";
    }
    
    if ([msg isEqualToString:@"ok"]) {
        
        NSString *sUrl=[NSString stringWithFormat:@"%@UserPhoto?Password=%@",ServerURL,psTextField.text];
        
        
        if (switchview.on==NO) {
            sUrl=[NSString stringWithFormat:@"%@UserPhoto?Password=0",ServerURL];
        }

        
        NSURL *url = [NSURL URLWithString:[sUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"url=%@",sUrl);
        
        [self.request clearDelegatesAndCancel];
        self.request=nil;
        self.request = [ASIFormDataRequest requestWithURL:url];
        self.request.tag=1010;
        self.request.timeOutSeconds=TIMEOUT;
        [self.request setDelegate:self];
        
        NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
        
        if(ck!=nil)
        {
            [self.request setUseCookiePersistence:NO];
            [self.request setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
        }
        
        [self.request setRequestMethod:@"PUT"];
        [self.request startAsynchronous];
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



#pragma mark –
#pragma mark 请求完成 requestFinished
- (void)requestFailed:(ASIHTTPRequest *)r
{
    [HUD hide:YES];
    NSError *error = [r error];
    
    NSLog(@"member_info:%@",error);
}

- (void)requestFinished:(ASIHTTPRequest *)r
{
    int uid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];
    
    
    if (switchview.on==NO)
    {
       [dh updateAlbumPassword:uid
                       Password:0];
    }
    else
    {
        [dh updateAlbumPassword:uid
                       Password:[psTextField.text integerValue]];
    }
    
    
    
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"保存成功";
    HUD.delegate=self;
    [HUD hide:YES afterDelay:1.5];
    
    r=nil;
}


-(void)dealloc
{
    [self.request clearDelegatesAndCancel];
    self.request=nil;
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
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        
        switch (indexPath.row) {
            case 0:
            {
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"switchcell"];
                }
                
                cell.accessoryView = switchview;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                [[cell textLabel] setText:@"访问限制"];
            }
                break;
                
            case 1:
            {
                
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"switchcell"];
                }
                
                
                cell.accessoryView=psTextField;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                [[cell textLabel] setText:@"访问密码"];
                
            }
                break;
        }
        
    }
    
    return cell;
}






- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    if(switchControl.on)
    {
        rowCount=2;
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        rowCount=1;
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 4) ? NO : YES;
    return YES;
}




@end
