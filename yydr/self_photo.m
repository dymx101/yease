//
//  self_photo.m
//  yydr
//
//  Created by Li yi on 13-5-25.
//
//

#import "self_photo.h"
#import "place_photo.h"
#import "global.h"
#import "UIView+GetRequestCookie.h"

@interface self_photo ()

@end

@implementation self_photo
@synthesize HUD;
@synthesize deleteDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor=[UIColor blackColor];
        deleting=NO;
       
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title=@"照片";
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onBack:)
                                                              target:self];
    
    
    self.navigationItem.rightBarButtonItem=[self.view add_clear_button:@selector(onDelDown:)
                                                               target:self];

}


-(void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 1:
        {
            
            deleting=YES;
            
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            self.HUD.labelText = @"正在删除，请稍等...";
            [self.HUD show:YES];
            
            
            //删除
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@userphoto/%d",ServerURL,pid]];
            
            NSLog(@"%@",url);
            
            [deleteRequest clearDelegatesAndCancel];
            deleteRequest=nil;
            deleteRequest = [ASIFormDataRequest requestWithURL:url];
            deleteRequest.tag=1011;
            deleteRequest.timeOutSeconds=TIMEOUT;
            [deleteRequest setDelegate:self];
            
            
            NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
            
            if(ck!=nil)
            {
                [deleteRequest setUseCookiePersistence:NO];
                [deleteRequest setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
            }
            
            [deleteRequest setRequestMethod:@"DELETE"];
            [deleteRequest startAsynchronous];

        }
            break;
    }
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [deleteRequest clearDelegatesAndCancel];
    deleteRequest=nil;
}


-(void)onDelDown:(UIButton*)sender
{
    NSLog(@"删除照片");
    
    if(deleting==YES)
        return;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"是否确定删除？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    
    [alertView show];    
}

#pragma mark –
#pragma mark 请求完成 requestFinished
- (void)requestFailed:(ASIHTTPRequest *)r
{
    NSError *error = [r error];
    NSLog(@"删除照片:%@",error);
}



- (void)requestFinished:(ASIHTTPRequest *)r
{
    [HUD hide:YES];
    
    deleting=NO;
    
    [deleteDelegate DeleteFinished];
    
    [self.navigationController popViewControllerAnimated:YES];

    r=nil;
}




-(void)loadUserPhoto:(NSDictionary*)up
{
    NSLog(@"%@",up);
    
     //photo id
    pid = [[up objectForKey:@"Id"] integerValue];
    
    UserId = [[up objectForKey:@"UserId"] integerValue];
    
    place_photo *p=[[place_photo alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height-44)];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,UserId,[up objectForKey:@"Path"]]];
    
    [p loadPhoto:url];
    
    [self.view addSubview:p];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
