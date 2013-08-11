//
//  place_tel_list.m
//  yydr
//
//  Created by liyi on 13-2-14.
//
//

#import "place_manager_list.h"
#import "place_manager_cell.h"
#import "place_manager_detail.h"
#import "place_manager_add.h"
#import "global.h"
#import "login.h"

#import "UIView+iImageManager.h"


@interface place_manager_list ()

@end

@implementation place_manager_list

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

        self.tableView.backgroundView = [self.view addImageView:nil
                                              image:@"place_tel_bbg.png"
                                           position:CGPointMake(0, 0)];
    }
    return self;
}


-(void)onCallDown:(UIButton*)sender
{
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"立即预约",nil];
    [menu showInView:self.view];
}

//拨号
- (void)actionSheet:(UIActionSheet *)as didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    
    if(buttonIndex==1)
    {
        return;
    }
    
    //统计
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:11111"]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *rbt=[[UIBarButtonItem alloc]initWithTitle:@"经理加入"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(onRDown:)];
    self.navigationItem.rightBarButtonItem=rbt;
}

-(void)viewDidAppear:(BOOL)animated
{
    cookieValue=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
}

-(void)onRDown:(UIButton*)sender
{
    //添加
    if(cookieValue == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:MustLoginInfo
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"立即登入",nil];
        [alertView show];
    }
    else
    {
        place_manager_add *mm = [[place_manager_add alloc] initWithStyle:UITableViewStyleGrouped];
        mm.title=@"客户经理";
        [self.navigationController pushViewController:mm animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0)
    {
        return 40;
    }
    return 110;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"cell";
    place_manager_cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
            cell = [[place_manager_cell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CellIdentifier];
        if(indexPath.row==0)
        {
            [cell load:YES];
        }
        else
        {
            [cell load:NO];
        }
    }

    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    place_manager_detail *mm = [[place_manager_detail alloc] init];
    mm.title=@"详情";
    [self.navigationController pushViewController:mm animated:YES];
}


#pragma mark –
#pragma mark UIAlertView按钮事件／登入功能
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            login *mm = [[login alloc] initWithStyle:UITableViewStyleGrouped];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mm];
            nav.navigationBar.tintColor=[UIColor blackColor];
            mm.title=@"登录";
            [self presentModalViewController:nav animated:YES];
        }
            break;
    }
}
@end
