//
//  place_comment.m
//  yydr
//
//  Created by 毅 李 on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "place_comment_add.h"
#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"
#import "UIView+iTextManager.h"
#import "global.h"
#import "UIView+GetRequestCookie.h"
#import "login.h"

@interface place_comment_add ()

@end

@implementation place_comment_add
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.separatorStyle = NO;
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"正在提交，请稍等...";
        
        rating=-1;

        waiting=NO;
    }
    return self;
}

-(void)setPlaceId:(int)pid
{
    PlaceId=pid;
}


#pragma mark –
#pragma mark 顶部按钮事件
-(void)onRDown:(id*)sender
{
    if(waiting)
        return;
    
    
    [HUD show:YES];
    
    //结束编辑
    [body endEditing:YES];
    [price endEditing:YES];
    [recommend endEditing:YES];
    
    
    //开始提交
    NSString *msg=@"ok";
    
    if(rating<0)
    {
        msg=@"请评价";
    }
    else if(price.text.length==0)
    {
        msg=@"请输入花费";
    }
    else if(body.text.length<10)
    {
        msg=@"分享内容太少啦～多写点吧";
    }
    
    
    if ([msg isEqualToString:@"ok"]) {
        
        NSURL *url = [NSURL URLWithString:[NSString  stringWithFormat:@"%@PlaceComment?ver=1.5",ServerURL]];
        
        ASIFormDataRequest *request;
        request = nil;
        request = [ASIFormDataRequest requestWithURL:url];
        request.timeOutSeconds=TIMEOUT;
        request.delegate=self;
        
        [request setPostValue:[NSString stringWithFormat:@"%d",PlaceId] forKey:@"PlaceId"];
        [request setPostValue:body.text forKey:@"Comment"];
        [request setPostValue:[NSNumber numberWithInt:rating] forKey:@"Evaluation"];
        [request setPostValue:price.text forKey:@"Spend"];
        [request setPostValue:recommend.text forKey:@"Recommend"];
        
        
        NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
        if(ck!=nil)
        {
            [request setUseCookiePersistence:NO];
            [request setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
        }
        
        
        [request setRequestMethod:@"POST"];
        
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



- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"%@",[request responseString]);
    
    int StatusCode=[request responseStatusCode];
    
    if(StatusCode==200)
    {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.labelText = @"分享成功";
        [HUD hide:YES afterDelay:1.5];
    }
    else
    {
        [HUD hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"未知错误"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    waiting=NO;
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
    [delegate CommentAddFinished];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onBack:)
                                                              target:self];
    
    self.navigationItem.rightBarButtonItem=[self.view add_ok_button:@selector(onRDown:)
                                                              target:self];
    
    
    [self.view addTapEvent:self.view target:self action:@selector(onTap:)];
}


-(void)onBack:(id)sender
{
    if(waiting)
        return;
    
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


-(void)onStarDown:(UIGestureRecognizer*)sender
{
    
    rating=sender.view.tag-2100;
    
    for (int i=0;i<5;i++)
    {
        
        UIImageView *bt=(UIImageView*)[self.view viewWithTag:2100+i];
        
        if(i>rating)
            bt.highlighted=NO;
        else
            bt.highlighted=YES;   
    }
 
}



#pragma mark - Table view 设置

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * hView;
    
    hView=[[UIView alloc] initWithFrame:CGRectMake(20, 0, 300, 30)];
    
    switch (section) {
        case 0:
        {
            for (int i=0; i<5; i++) {
                
                UIImageView *bt=[self.view addImageView:hView
                                                  image:@"place_big_star.png"
                                               position:CGPointMake(42*i+60, 18)];
                bt.tag=2100+i;
                bt.highlightedImage=[UIImage imageNamed:@"place_big_star_h.png"];
                
                [self.view addTapEvent:bt
                                target:self
                                action:@selector(onStarDown:)];
                
                if(i>rating)
                    bt.highlighted=NO;
                else
                    bt.highlighted=YES;
                
            }
            

            UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(20, 30, 50, 30)];
            l.backgroundColor=[UIColor clearColor];
            l.text=@"评价";
            l.font=[UIFont boldSystemFontOfSize:17];
            [hView addSubview:l];
            
            
            /*
             NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"好评",@"差评",nil];
             segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
             segmentedControl.frame = CGRectMake(10, 10, 300, 50.0);
             [hView addSubview:segmentedControl];
             
             [segmentedControl addTarget:self
             action:@selector(segmentAction:)
             forControlEvents:UIControlEventValueChanged];
             
             segmentedControl.selectedSegmentIndex=rating;
             */
        }
            break;
        case 1:
        {
            UILabel *l=[[UILabel alloc] initWithFrame:hView.frame];
            l.backgroundColor=[UIColor clearColor];
            l.text=@"分享内容(10字以上):";
            l.font=[UIFont boldSystemFontOfSize:16];
            [hView addSubview:l];
        }
            break;
            
    }
    
    return hView;
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
  //  rating=Seg.selectedSegmentIndex;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 2;
    
    if(section==1)
        return 1;
    
    return 0;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField.tag==1101)
    {
        [body becomeFirstResponder];
    }
    
    return YES;
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
                    
                    [[cell textLabel] setText:@"花费"];

                    price=[self.view addTextField:nil
                                            frame:CGRectMake(0, 0, 230, 28)
                                             font:[UIFont systemFontOfSize:15]
                                            color:[UIColor blackColor]
                                      placeholder:@""
                                              tag:1100];
                    
                    price.returnKeyType = UIReturnKeyNext;
                    [price setKeyboardType:UIKeyboardTypeNumberPad];
                    price.delegate=self;
                    
                    cell.accessoryView = price;
                }
                    break;
                    
                case 1:
                {
                    
                    recommend=[self.view addTextField:nil
                                                frame:CGRectMake(0, 0, 230, 28)
                                                 font:[UIFont systemFontOfSize:15]
                                                color:[UIColor blackColor]
                                          placeholder:@"选填"
                                                  tag:1101];
                    recommend.delegate=self;
                    recommend.returnKeyType = UIReturnKeyNext;
                    [recommend setKeyboardType:UIKeyboardTypeNumberPad];
                    
                    [[cell textLabel] setText:@"推荐"];
                    cell.accessoryView = recommend;
                    
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
            
            body=nil;
            body = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 5, 290, 150)];
            body.backgroundColor=[UIColor clearColor];
            //body.returnKeyType = UIReturnKeyDone;
            body.font = [UIFont systemFontOfSize:15.0f];
            //body.delegate=self;
            body.tag=1102;
            body.placeholder=@"分享内容请遵守各项有关《国家法律法规》";
            
            [cell.contentView addSubview:body];
        }
        
    }
    
    return cell;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 5) ? NO : YES;
}


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 50;
    }
    return 165;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 80.0f;
    }
    
    return 30;
}

-(void)onDown:(UIButton*)sender
{
    
}

-(void)onTap:(UIGestureRecognizer*)sender
{
    [recommend endEditing:YES];
    [price endEditing:YES];
    [body endEditing:YES];
}


@end
