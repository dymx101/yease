//
//  change_name.m
//  yydr
//
//  Created by liyi on 12-12-13.
//
//

#import "change_name.h"
#import "ASIFormDataRequest.h"
#import "UIView+GetRequestCookie.h"

@interface change_name ()

@end

@implementation change_name

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
    [UserName endEditing:YES];
    
    if(UserName.text.length>0)
    {
        NSString *str= [NSString stringWithFormat:@"%@User?UserName=%@",
                        ServerURL,
                        UserName.text];
        
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.timeOutSeconds=TIMEOUT;
        
        NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
        
        if(ck!=nil)
        {
            [request setUseCookiePersistence:NO];
            [request setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
        }

        [request setDelegate:self];
        [request setRequestMethod:@"PUT"];
        [request startAsynchronous];
        
    }
    else
    {
        [HUD hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入新用户名"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    
    
    
    
    int StatusCode=[request responseStatusCode];
    
    if(StatusCode==200)
    {
        //更新记录用户名
        [[NSUserDefaults standardUserDefaults] setObject:UserName.text
                                                  forKey:@"UserName"];
        
        //登入成功
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.labelText = @"登入成功";
        [HUD hide:YES afterDelay:1];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"用户名已存在"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }

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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"switchcell"];
            
            //Add a UITextField
            UITextField *textField = [[UITextField alloc] init];
            textField.tag = 1000 + indexPath.row;
            //Add general UITextAttributes if necessary
            textField.enablesReturnKeyAutomatically = YES;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.frame = CGRectMake(0, 0, 280, 28);
            textField.clearButtonMode=UITextFieldViewModeWhileEditing;
            textField.font= [UIFont systemFontOfSize:15];
            textField.delegate=self;
            //垂直居中
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            //垂直居中
            textField.returnKeyType = UIReturnKeyDone;
            textField.placeholder=@"点击输入新用户名";
            UserName=textField;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryView=textField;
            
        }
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UserName endEditing:YES];
    return YES;
}

@end
