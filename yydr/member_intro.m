//
//  member_signature.m
//  yydr
//
//  Created by Li yi on 13-5-26.
//
//

#import "member_intro.h"
#import "global.h"
#import "UIView+GetRequestCookie.h"
#import "UIView+iButtonManager.h"


@interface member_intro ()

@end

@implementation member_intro

@synthesize request;

@synthesize HUD;

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
    
    
    self.navigationItem.rightBarButtonItem=[self.view add_ok_button:@selector(onSave:)
                                                             target:self];
    
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onLDown:)
                                                              target:self];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.labelText = @"正在提交，请稍等...";
    
    dh=[[dbHelper alloc]init];
 
}

-(void)onLDown:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)loadSignature:(NSString*)signature
{
    Signature=signature;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.request clearDelegatesAndCancel];
    self.request=nil;
}

//更新签名
- (void)onSave:(id)sender
{
     [HUD show:YES];
    
    //开始提交
    NSString *msg=@"ok";
    [body endEditing:YES];
    
    if(body.text.length>50)
    {
        msg=@"签名太长（50字内）";
    }
    
    if ([msg isEqualToString:@"ok"]) {
    
    NSString *sUrl=[NSString stringWithFormat:@"%@User?signature=%@",ServerURL,body.text];
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
    
    [dh updateSignature:uid Signatrue:body.text];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"保存成功";
    HUD.delegate=self;
    [HUD hide:YES afterDelay:1.5];

    r=nil;
    
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"cell1"];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        body=nil;
        body = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 5, 290, 190)];
        body.backgroundColor=[UIColor clearColor];
        //body.returnKeyType = UIReturnKeyDone;
        body.font = [UIFont systemFontOfSize:15.0f];
        //body.delegate=self;
        body.tag=1102;
        body.placeholder=@"50字内";
        
        [cell.contentView addSubview:body];
    }
    
    
    body.text=Signature;
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}


@end
