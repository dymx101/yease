//
//  homepage.m
//  yydr
//
//  Created by Li yi on 13-6-8.
//
//

#import "homepage.h"

#import "city_list.h"
#import "chatDelegate.h"
#import "search.h"

#import <AudioToolbox/AudioToolbox.h>

@interface homepage ()

@end

@implementation homepage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        place_add_button = [self.view add_add_button:@selector(onPlaceAddDown::) target:self];//[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onPlaceAddDown:)];
       
        place_reload_button=[self.view add_reload_button:@selector(onPlaceReloadDown:) target:self];
        
        setting_button=[self.view add_setting_button:@selector(onSettingDown:) target:self];
        
        

        //底部工具栏 场所列表
        p0 = [[place_list alloc] init];
        
        UITabBarItem *item0 = [[UITabBarItem alloc] initWithTitle:@"场所"
                                                            image:[UIImage imageNamed:@"hp_place.png"]
                                                              tag:0];
        
        
        item0.titlePositionAdjustment=UIOffsetMake(0, -2);
        p0.tabBarItem = item0;
        item0.tag=1000;
        
        
        //约会列表
        p1 = [[appointment_member_list alloc] init];
        
        UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"约会"
                                                            image:[UIImage imageNamed:@"hp_appointment.png"]
                                                              tag:0];
        item1.titlePositionAdjustment=UIOffsetMake(0, -2);
        p1.tabBarItem = item1;
        item1.tag=1001;
        
        
        //消息列表
        p2 = [[appointment_chat_list alloc] init];
        
        UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"对话"
                                                            image:[UIImage imageNamed:@"hp_chat.png"]
                                                              tag:0];
        item2.titlePositionAdjustment=UIOffsetMake(0, -2);
        p2.tabBarItem = item2;
        item2.tag=1002;
        
        
        //设置
        p3 = [[member alloc] initWithStyle:UITableViewStyleGrouped];
        
        UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                            image:[UIImage imageNamed:@"hp_member.png"]
                                                              tag:0];
        item3.titlePositionAdjustment=UIOffsetMake(0, -2);
        p3.tabBarItem = item3;
        item3.tag=1003;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.tabBar.barStyle=UIBarStyleBlack;
            self.tabBar.translucent=NO;
        }
        
        
        self.viewControllers = [NSArray arrayWithObjects:p0, p1, p2, p3, nil];
        
        [self.navigationItem setHidesBackButton:YES];
        
        
        ad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        ad.chatDelegate=self;
        
        
    }
    return self;
}





-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
   // self.navigationItem.leftBarButtonItem=place_add_button;
   // searchView.frame=CGRectMake(0, 0, 270, 44);
}


-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
   // self.navigationItem.leftBarButtonItem=nil;
   // searchView.frame=CGRectMake(0, 0, 300, 44);
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    titleView.titleText.text = item.title;
    
    switch (item.tag) {
        case 1000:
        {
            
            
            self.navigationItem.titleView=searchView;
            self.navigationItem.rightBarButtonItem=nil;
            self.navigationItem.leftBarButtonItem=nil;
        }
            break;
        case 1001:
        {
            self.navigationItem.titleView=nil;
            self.navigationItem.title=@"约会";
            self.navigationItem.rightBarButtonItem=nil;
            self.navigationItem.leftBarButtonItem=nil;
        }
            break;
        case 1002:
        {
            self.navigationItem.titleView=nil;
            self.navigationItem.title=@"对话";
            self.navigationItem.rightBarButtonItem=nil;
            self.navigationItem.leftBarButtonItem=nil;
        }
            break;
        case 1003:
        {
            self.navigationItem.titleView=nil;
            self.navigationItem.title=@"我的";
            self.navigationItem.rightBarButtonItem=setting_button;
            self.navigationItem.leftBarButtonItem=nil;
        }
            break;
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    ad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [ad.notifierView hide];
}


-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"homepage:viewDidAppear");
    
    ad=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    ad.chatDelegate=self;
    
    [self getNewMsgCount];
    
    if(self.selectedIndex==2)
    {
        [p2 updateNewMessageCount];
        [p2 viewDidAppear:NO];
    }
    
}



-(void)messageReceived:(NSDictionary *)msg
{
    //播放声音
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sms_8" ofType:@"mp3"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *url = [NSURL fileURLWithPath:path];
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        AudioServicesPlaySystemSound(sound);
    }
    
    [self getNewMsgCount];
}


-(void)getNewMsgCount
{
    //更新底部
    int mid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];
    
    dbHelper *dh=[[dbHelper alloc] init];
    int newMsgCount=[dh getNewMessageCount:mid];

    if(newMsgCount>0)
    {
       [[self.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",newMsgCount]];
    }
    else
    {
         [[self.tabBar.items objectAtIndex:2] setBadgeValue:nil];
    }
}


-(void)onCityDown
{
    city_list *mm=[[city_list alloc] initWithStyle:UITableViewStylePlain];
    mm.delegate=self;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    nav.navigationBar.translucent=NO;
    
    
    [self presentModalViewController:nav
                            animated:YES];
}


//城市选择
-(void)onCitySelected
{
    
    NSLog(@"onCitySelected");
    
    NSString *city= [[NSUserDefaults standardUserDefaults] objectForKey:@"City"];
    titleView.cityText.text=city;
    
    //城市改变重新载入
    [p0 reloadWithInit];
    [titleView showPlace];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	//Do any additional setup after loading the view.

    titleView=[[title alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleView.cityDelegate=self;
    self.navigationItem.titleView = titleView;
    [titleView showPlace];
}



//现实搜索栏
-(void)showSearchBar
{
    //默认出现搜索框初始化,原本的添加按钮消失。
    //self.navigationItem.rightBarButtonItem=place_add_button;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    searchBar.placeholder=@"搜索场所";
    searchBar.delegate=self;
    searchBar.backgroundImage=[UIImage imageNamed:@"search_bg.jpg"];
    
    
    sdc=[[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                          contentsController:self.navigationController];
    
    sdc.delegate = self;
    
    //sdc.searchResultsDataSource = self;
    //sdc.searchResultsDelegate = self;
    
    
    searchView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    self.navigationItem.titleView=searchView;
    [searchView addSubview:searchBar];

}


-(void)onSettingDown:(id)sender
{
    setting *mm = [[setting alloc] initWithStyle:UITableViewStyleGrouped];
    mm.title=@"设置";
    [self.navigationController pushViewController:mm animated:YES];
}



-(void)onPlaceAddDown:(id)sender
{
    place_add *mm = [[place_add alloc] initWithStyle:UITableViewStyleGrouped];
    mm.title=@"添加新地方";
    [self.navigationController pushViewController:mm animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
