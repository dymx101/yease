//
//  girl_main.m
//  yydr
//
//  Created by liyi on 12-12-15.
//
//

#import "appointment_main.h"


#import "global.h"
#import "ASIFormDataRequest.h"

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import <AudioToolbox/AudioToolbox.h>

@interface appointment_main ()

@end

@implementation appointment_main

@synthesize rbt;
@synthesize m0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

        //3合1s
        appointment_chat_list *m1 = [[appointment_chat_list alloc] init];
        
        //appointment_friend_list *m2 = [[appointment_friend_list alloc] initWithStyle:UITableViewStylePlain];
        
        self.m0 = [[appointment_member_list alloc] init];
    
        //=========
        UITabBarItem *item0 = [[UITabBarItem alloc] initWithTitle:@"附近"
                                                            image:[UIImage imageNamed:@"nearby.png"]
                                                              tag:0];
        item0.titlePositionAdjustment=UIOffsetMake(0, -2);
        self.m0.tabBarItem = item0;
        
        
        //=========tabBarItem.badgeValue = @"2";
        item1 = [[UITabBarItem alloc] initWithTitle:@"对话"
                                                            image:[UIImage imageNamed:@"chat.png"]
                                                              tag:0];
        item1.titlePositionAdjustment=UIOffsetMake(0, -2);
        m1.tabBarItem = item1;
       
        
        
        mid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];
        
        dh=[[dbHelper alloc] init];
        int newMsgCount=[dh getNewMessageCount:mid];
        
        if(newMsgCount>0)
        {
            item1.badgeValue=[NSString stringWithFormat:@"%d",newMsgCount];
        }
        else
        {
            item1.badgeValue=nil;
        }
        
        
        self.viewControllers = [NSArray arrayWithObjects:m0, m1, nil];
        
        
      
        
        /*
        //=========
        UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"好友"
                                                            image:[UIImage imageNamed:@"friend.png"]
                                                              tag:0];
        item2.titlePositionAdjustment=UIOffsetMake(0, -2);
        m2.tabBarItem = item2;
         
        */
        
    }
    return self;
}

-(void)getNewMsgCount
{
    
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"%@",item.title);
    
    if([item.title isEqualToString:@"附近"])
    {
        self.navigationItem.rightBarButtonItem=self.rbt;
    }
    else
    {
        self.navigationItem.rightBarButtonItem=nil;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *lbt=[[UIBarButtonItem alloc]initWithTitle:@"关闭"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(onLDown:)];
    
    self.navigationItem.leftBarButtonItem=lbt;
    
    
    
    self.rbt=[[UIBarButtonItem alloc]initWithTitle:@"重新定位"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(onRDown:)];
    self.navigationItem.rightBarButtonItem=self.rbt;
    
}






//按钮事件 -----------------------------------

-(void)onLDown:(id*)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)onRDown:(id*)sender
{
    NSLog(@"重新定位");
    
    appointment_member_list *m=(appointment_member_list*)[self.viewControllers objectAtIndex:0];
    [m clearAndRequest];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
