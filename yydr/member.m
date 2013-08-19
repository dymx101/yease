//
//  member.m
//  yydr
//
//  Created by 毅 李 on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "member.h"
#import "member_map.h"
#import "member_avatar.h"
#import "member_signature.h"
#import "member_intro.h"

#import "UIView+iButtonManager.h"
#import "UIView+iImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIView+GetRequestCookie.h"

#import "global.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "change_password.h"
#import "change_name.h"

#import "about_us.h"

#import "Harpy.h"
#import "login.h"
#import "place_favorite_list.h"


#import "self_photo_list.h"
#import "self_photo_password.h"

#import "AppDelegate.h"


@interface member ()

@end


@implementation member

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        /*
         self.tableView.backgroundView = [self.view addImageView:nil
         image:@"member_bg.png"
         position:CGPointMake(0, 0)];
        */
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView= [self.view addImageView:nil
                                                     image:@"place_tel_bbg.png"
                                                  position:CGPointMake(0, 0)];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    
    dh=[[dbHelper alloc] init];
    UserId=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];

}


-(void)onLDown:(id*)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self dismissModalViewControllerAnimated:YES];
}




//按钮事件 -----------------------------------
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

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if(section==0)
        return 2;
    
    if(section==1)
        return 4;
    
    if(section==2)
        return 2;
    
    
    return 0;
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
        }
        
        switch (indexPath.row) {
                //第二版 加修改
            case 0:
            {
                [[cell textLabel] setText:@"用户名"];
                cell.detailTextLabel.text = [userinfo objectForKey:@"username"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
                break;
            case 1:
            {
                [[cell textLabel] setText:@"修改密码"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
        }
        
    }
    
    if(indexPath.section==1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"cell1"];
        }
        
        switch (indexPath.row) {
            case 0:
            {
                [[cell textLabel] setText:@"头像"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                avatar=[self.view addImageView:cell.contentView
                                                  image:@"noAvatar.png"
                                               position:CGPointMake(0, 0)];
                avatar.contentMode= UIViewContentModeScaleToFill;
                avatar.frame=CGRectMake(220, 5, 50, 50);
                
                
                NSString *FileName=[userinfo objectForKey:@"avatar"];
                
                NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,UserId,FileName]];
                
                NSLog(@"url====%@",url);
                
                [avatar setImageWithURL:url
                       placeholderImage:[UIImage imageNamed:@"noAvatar.png"]];

            }
                break;
                
            case 1:
            {
                int sex=[[userinfo objectForKey:@"sex"] integerValue];
                [[cell textLabel] setText:@"性别"];
                cell.detailTextLabel.text = sex==1?@"男":@"女";
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
                break;

            /* next version
            case 1:
            {
                [[cell textLabel] setText:@"年龄"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
                
            case 2:
            {
                [[cell textLabel] setText:@"星座"];
            }
                break;
             */
                   
            case 2:
            {
                [[cell textLabel] setText:@"签名"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = [userinfo objectForKey:@"signature"];
            }
                break;
                
            case 3:
            {
                [[cell textLabel] setText:@"个人简介"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //下回
                cell.detailTextLabel.text=@"";
            }
                break;
                
        }
    }
    
    else if(indexPath.section==2)
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"cell2"];
        }
        
        
        switch (indexPath.row) {
            case 0:
            {
                [[cell textLabel] setText:@"我的相册"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
                
                case 1:
            {
                
                [[cell textLabel] setText:@"访问限制"];
                
                if([[userinfo objectForKey:@"albumpassword"] integerValue]>0)
                {
                    cell.detailTextLabel.text=@"打开";
                }
                else
                {
                    cell.detailTextLabel.text=@"关闭";
                }
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
        }
        
       

    }
    
    /*
    else if(indexPath.section==3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"cell2"];
        }

        [[cell textLabel] setText:@"居住地"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
     */
    
    return cell;
}


#pragma mark - 自动登入开关

-(void)switchAction:(UISwitch*)sender
{
    NSLog(@"member_switchAction:%d",sender.on);
}


#pragma mark - Table view 设置
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * hView;
    
    hView=[[UIView alloc] initWithFrame:CGRectMake(20, 5, 300, 30)];
    
    UILabel *l=[[UILabel alloc] initWithFrame:hView.frame];
    l.backgroundColor=[UIColor clearColor];
    l.shadowColor=[UIColor whiteColor];
    l.shadowOffset=CGSizeMake(0, 1);
    
    switch (section) {
        case 0:
        {
            l.text=@"帐户信息";
           
        }
            break;
        case 1:
        {
            l.text=@"个人信息";
        }
            break;
    }
    
    [hView addSubview:l];
    
    return hView;
}

//-----------------------------------
#pragma mark - load数据

-(void) viewWillAppear:(BOOL)animated
{
    //加载
    userinfo=[dh getUserInfo:UserId];
    
    NSLog(@"userinfo====%@",userinfo);
    
    RoleId=[[userinfo objectForKey:@"roleid"] integerValue];
    
    [self.tableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2||section==3) {
        return 0;
    }
    
    return 40.f;
}



-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1&&indexPath.row==0)
    {
        return 60;
    }
    
    return 40;
}

//-----------------------------------
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            
            switch (indexPath.row) {
                    
                case 0:
                {
                    // change_name *mm = [[change_name alloc] initWithStyle:UITableViewStyleGrouped];
                    // mm.title=@"修改昵称";
                    // [self.navigationController pushViewController:mm animated:YES];
                }
                    break;
                    
                case 1:
                {
                    change_password *mm = [[change_password alloc] initWithStyle:UITableViewStyleGrouped];
                    mm.title=@"修改密码";
                    [self.navigationController pushViewController:mm animated:YES];
                }
                    break;
            }
            
        }
            break;
            
        case 1:
        {
            
            switch (indexPath.row) {
                    
                case 0:
                {
                    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消"
                                                      destructiveButtonTitle:nil
                                                           otherButtonTitles:@"拍照上传",@"从相册上传",nil];
                    [menu showInView:[[UIApplication sharedApplication] keyWindow]];
                }
                    break;
                    

                case 2:
                {
                    member_signature *mm = [[member_signature alloc] initWithStyle:UITableViewStyleGrouped];
                    [mm loadSignature:[userinfo objectForKey:@"signature"]];
                    mm.title=@"个性签名";
                    [self.navigationController pushViewController:mm animated:YES];
                    
                }
                    break;
            
                case 3:
                {
                    member_intro *mm = [[member_intro alloc] initWithStyle:UITableViewStyleGrouped];
                    [mm loadSignature:[userinfo objectForKey:@"signature"]];
                    mm.title=@"个人简介";
                    [self.navigationController pushViewController:mm animated:YES];
                }
                    break;
            }
        }
            break;
            
            
        case 2:
        {
            //个人相册
            switch (indexPath.row) {   
                case 0:
                {
                    //相册
                    self_photo_list *mm = [[self_photo_list alloc] init];
                    [mm setUid:UserId RoleId:RoleId];
                    [self.navigationController pushViewController:mm animated:YES];
                }
                    break;
                    
                case 1:
                {
                    //相册加密
                    self_photo_password *mm = [[self_photo_password alloc] initWithStyle:UITableViewStyleGrouped];
                    [self.navigationController pushViewController:mm animated:YES];
                }
                    break;
            }
        }
            break;
            
        case 3:
        {
            
            //居住地
            member_map *mm = [[member_map alloc] init];
            mm.title=@"定位";
            [self.navigationController pushViewController:mm animated:YES];
            
        }
            break;
    }
    
}


#pragma mark –
#pragma mark 上传照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        member_avatar *ppp=[[member_avatar alloc] init];
        ppp.title=@"头像";
        [picker pushViewController:ppp animated:YES];
        [ppp loadImage:originalImage];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //拍照
            UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
            imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePickController.delegate=self;
            imagePickController.allowsEditing=NO;
            imagePickController.showsCameraControls=YES;
            [self presentModalViewController:imagePickController animated:YES];
        }
            break;
            
        case 1:
        {
            //从相册
            UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
            imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickController.delegate=self;
            [self presentModalViewController:imagePickController animated:YES];
        }
            break;
    }
    
    
    
}

@end

