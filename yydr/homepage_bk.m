//
//  HPViewController.m
//  yydr
//
//  Created by 毅 李 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "homepage.h"
#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"
#import "UIView+iTextManager.h"

#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

#import "setting.h"
#import "login.h"
#import "search.h"
#import "member.h"
#import "place_list.h"
#import "city_list.h"

#import "place_favorite_list.h"

#import "appointment_main.h"
#import "appointment_member_list.h"
#import "appointment_chat_list.h"
#import "appointment_friend_list.h"

#import "UIView+iTextManager.h"


@interface homepage ()

@end


@implementation homepage

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        //分割线
        self.tableView.separatorStyle = NO;
        self.tableView.showsHorizontalScrollIndicator=NO;
        self.tableView.showsVerticalScrollIndicator=NO;
        
        self.tableView.backgroundView = [self.view addImageView:nil
                                                          image:@"home_bg.png"
                                                       position:CGPointMake(0, 0)];
        self.view.backgroundColor=[UIColor blackColor];

        
        //切换按钮
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor=[UIColor clearColor];
        button.tag=1012;
        button.frame=CGRectMake(0, 0, 20, 20);
        [button setTitle:@"夜色－上海" forState:UIControlStateNormal];
        //效果
        //button.titleLabel.shadowColor=[UIColor blackColor];
        //button.titleLabel.shadowOffset=CGSizeMake(1,1);
        
        button.titleLabel.font=[UIFont boldSystemFontOfSize:20];
        [button addTarget:self action:@selector(onCityDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(onCityUp:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(onCityOUp:) forControlEvents:UIControlEventTouchUpOutside];
        [[self navigationItem] setTitleView:button];
        [button sizeToFit];
     

    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}


-(void)viewDidAppear:(BOOL)animated
{
    //测试登入
    ad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.chatDelegate=self;
    
    //更新未读消息数
    [self updateNewMessageCount];
}


//更新新消息数量
-(void)updateNewMessageCount
{
    //==========================================================================================
    //获取新消息数量
    int mid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];

    int newMsgCount = 0;

    
    dbHelper *dh=[[dbHelper alloc] init];
    newMsgCount=[dh getNewMessageCount:mid];

    
    num.text=[NSString stringWithFormat:@"%d",newMsgCount];
    [num sizeToFit];
    num.center=CGPointMake(qNum.frame.size.width/2, qNum.frame.size.height/2-1);
    
    NSLog(@"新消息数量：%d",newMsgCount);
    
    if(newMsgCount>0)
    {
        qNum.hidden=NO;
    }
    else
    {
        qNum.hidden=YES;
    }
    
}




-(void)messageReceived:(NSDictionary *)msg
{
    NSLog(@"在首页接受到消息，需要更新首页图标 %@",msg);
    
    //播放声音
     NSString *path = [[NSBundle mainBundle] pathForResource:@"sms-received1" ofType:@"aif"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *url = [NSURL fileURLWithPath:path];
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        AudioServicesPlaySystemSound(sound);
    }
    
    //顶部显示
    
    
    
    //更新新消息数量
    [self updateNewMessageCount];
}


-(void)onCityDown:(UIButton*)sender
{
    sender.alpha=.5;
}

-(void)onCityUp:(UIButton*)sender
{
    /*
    city_list *mm = [[city_list alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
    nav.navigationBar.tintColor=[UIColor blackColor];
    mm.title=@"城市选择";
    [self presentModalViewController:nav animated:YES];
    */
    sender.alpha=1;
}

-(void)onCityOUp:(UIButton*)sender
{
    sender.alpha=1;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.tableView=nil;
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"homepage_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        NSUInteger row =[indexPath row];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [self createButton:cell.contentView position:CGPointMake(0, 0) num:row*3];
        [self createButton:cell.contentView position:CGPointMake(105, 0) num:row*3+1];
        [self createButton:cell.contentView position:CGPointMake(105*2, 0) num:row*3+2];
        
    }
    return cell;
    
}

-(void)createButton:(UIView*)uv position:(CGPoint)p num:(int)n
{
    
    if (n>8) {
        return;
    }
    
    UIButton *btt= [self.view addButton:uv
                                  image:[NSString stringWithFormat:@"homePage_bt%d.png",n]
                               position:p
                                    tag:1000+n
                                 target:self
                                 action:@selector(onDown:)];
    
    //NSLog(@"%@",[NSString stringWithFormat:@"homePage_bt%d.png",n]);
    
    NSString *bn;
    
    switch (n) {
        case 0:
        {
            bn=@"指压推油";
        }
            break;
        case 1:
        {
            bn=@"洗浴中心";
        }
            break;
        case 2:
        {
            bn=@"桑拿会所";
        }
            break;
        case 3:
        {
            bn=@"足浴按摩";
        }
            break;
        case 4:
        {
            bn=@"夜总会";
        }
            break;
        case 5:
        {
            bn=@"酒   吧";
        }
            break;
        case 7:
        {
            bn=@"个人中心";
        }
            break;
        case 6:
        {
            bn=@"约   会";
            
            qNum=[self.view addImageView:btt
                                   image:@"homePage_num.png"
                                position:CGPointMake(62, 42)];
            qNum.hidden=YES;
           
            num=[self.view addLabel:qNum
                              frame:CGRectMake(0, 0, 0, 0)
                               font:[UIFont boldSystemFontOfSize:10]
                               text:@"0"
                              color:[UIColor whiteColor]
                                tag:1100];
            [num sizeToFit];
            
            
            CGRect f=qNum.frame;
            f=CGRectMake(f.origin.x,
                         f.origin.y,
                         22,
                         f.size.height);
            qNum.frame=f;
        
            num.center=CGPointMake(qNum.frame.size.width/2, qNum.frame.size.height/2-1);

        }
            break;
        case 8:
        {
            bn=@"设   置";
        }
            break;
            
        case 9:
        {
            bn=@"收   藏";
        }
            break;
            
    }
    
    
    UILabel *l=[self.view addLabel:btt
                             frame:CGRectMake(0, 0, 0, 0)
                              font:[UIFont boldSystemFontOfSize:15]
                              text:bn
                             color:[UIColor whiteColor]
                               tag:0];
    
    [l sizeToFit];
    l.center=CGPointMake(btt.frame.size.width/2, 98);
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

-(void)onDown:(UIButton*)sender
{
    NSLog(@"%d",sender.tag);
    
    switch (sender.tag) {
        
        case 1012:
        {
            NSLog(@"切换地方");

        }
            break;
            
        
        case  1010:
        {
            /*
            girl_list *mm = [[girl_list alloc] initWithStyle:UITableViewStylePlain];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
            nav.navigationBar.tintColor=[UIColor blackColor];
            mm.title=@"约会";
            [self presentModalViewController:nav animated:YES];
             */
        }
            break;
            
        case 1008:
        {
            
            setting *mm = [[setting alloc] initWithStyle:UITableViewStyleGrouped];
            mm.title=@"设置";
            
            //设置
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
            nav.navigationBar.tintColor=[UIColor blackColor];
            [self presentModalViewController:nav animated:YES];
        }
            break;
            
        //个人中心 
        case 1007:
        {
            NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];

            if(ck!=nil)
            {
                member *mm = [[member alloc] initWithStyle:UITableViewStyleGrouped];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
                nav.navigationBar.tintColor=[UIColor blackColor];
                mm.title=@"个人中心";
                [self presentModalViewController:nav animated:YES];
            }
            else
            {
                login *mm = [[login alloc] initWithStyle:UITableViewStyleGrouped];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
                nav.navigationBar.tintColor=[UIColor blackColor];
                mm.title=@"登录";
                [self presentModalViewController:nav animated:YES];
            }
              
        }
            break;
            

        case 1006:
        {
            appointment_main *mm = [[appointment_main alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
            nav.navigationBar.tintColor=[UIColor blackColor];
            mm.title=@"约会";
            [self presentModalViewController:nav animated:YES];
        }
            break;
            
        case 1009:
        {
            place_favorite_list *mm = [[place_favorite_list alloc] init];
            mm.title=@"收藏";
            [mm addItemsOnBottom];
            [self.navigationController pushViewController:mm animated:YES];

        }
            break;
            
        default:
        {
            place_list *mm = [[place_list alloc] init];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
            nav.navigationBar.tintColor=[UIColor blackColor];
            nav.toolbar.barStyle=UIBarStyleBlackTranslucent;
            
            int cid = 0;
            
            switch (sender.tag) {
                case 1000:
                {
                    mm.title=@"指压推油";
                    cid=1;
                }   
                    break;
                case 1001:
                {
                    mm.title=@"洗浴中心";
                    cid=2;
                }
                    break;
                case 1002:
                {
                    mm.title=@"桑拿会所";
                    cid=3;
                }
                    break;
                case 1003:
                {
                    mm.title=@"足浴按摩";
                    cid=4;
                }
                    break;  
                case 1004:
                {
                    mm.title=@"夜总会";
                    cid=5;
                }
                    break;
                case 1005:
                {
                    mm.title=@"酒吧";
                    cid=6;
                }
                    break;
            }
            
            [mm FirstLoad:cid];
            
            
            //场馆
            [self presentModalViewController:nav animated:YES]; 
        }
            break;
    }
}



@end
