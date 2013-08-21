//
//  member_info.m
//  yydr
//
//  Created by liyi on 13-4-19.
//
//

#import "member_info.h"
#import "member_photo.h"

#import "appointment_main.h"
#import "appointment_chat_list.h"
#import "appointment_member_list.h"
#import "appointment_chat.h"

#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"
#import "UIView+GetRequestCookie.h"
#import "UIView+iTextManager.h"


#import "UIImageView+WebCache.h"

#import "self_photo_list.h"

#import "login.h"
#import "global.h"
#import <QuartzCore/QuartzCore.h>

#define MinHeight 104

@interface member_info ()

@end

@implementation member_info

@synthesize request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        tb=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44)
                                        style:UITableViewStylePlain];
        
        tb.delegate=self;
        tb.dataSource=self;
        tb.separatorStyle = NO;
        tb.backgroundView = [self.view addImageView:nil
                                              image:@"bg.png"
                                           position:CGPointMake(0, 0)];
        
        tb.backgroundView= [self.view addImageView:nil
                                             image:@"place_tel_bbg.png"
                                          position:CGPointMake(0, 0)];
        
        [self.view addSubview:tb];
        
        isOpen=NO;
        
        Mobile=0;
        
    }
    return self;
}


-(void)loadInfo:(NSDictionary*)info
{

    MemberInfo=info;
    NSLog(@"info==========%@",info);
    
    UserId=[[MemberInfo objectForKey:@"UserId"] integerValue];
    
    AlbumPassword=0;
    
    //访问密码
    id ap=[MemberInfo objectForKey:@"AlbumPassword"];
    
    if( ap && ![ap isKindOfClass:[NSNull class]] )
    {
        AlbumPassword=[[MemberInfo objectForKey:@"AlbumPassword"] integerValue];
    }
    
    
    
    //签名
    signature=[MemberInfo objectForKey:@"Signature"];
    if( !signature || [signature isKindOfClass:[NSNull class]] )
    {
        signature=@"没有个性签名";
    }
    

    //个人简介
    intro=[MemberInfo objectForKey:@"Intro"];
    
    if( !intro || [intro isKindOfClass:[NSNull class]] )
    {
        intro=@"无";
    }


    
    CGSize titleSize = [intro sizeWithFont:[UIFont systemFontOfSize:14.f]
                         constrainedToSize:CGSizeMake(280, MAXFLOAT)
                             lineBreakMode:UILineBreakModeWordWrap];
    orgHeight=titleSize.height;
    
    [self loadAblum:UserId];
    [self loadManager:UserId];
    
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
}


-(void)loadAblum:(int)uid
{
    NSString *sUrl=[NSString stringWithFormat:@"%@userphoto?uid=%d",ServerURL,uid];
    NSURL *url = [NSURL URLWithString:sUrl];
    NSLog(@"%@",url);
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
    
    [self.request setRequestMethod:@"GET"];
    [self.request startAsynchronous];
}


-(void)loadManager:(int)uid
{
    //拨打统计
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@PlaceManager?uid=%d",ServerURL,uid]];
    ASIHTTPRequest *manager=[ASIHTTPRequest requestWithURL:url];
    manager.timeOutSeconds=TIMEOUT;
    manager.tag=1030;
    [manager setRequestMethod:@"GET"];
    [manager setUseCookiePersistence:NO];
    
    
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    if(ck!=nil)
    {
        [self.request setUseCookiePersistence:NO];
        [self.request setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    }
    
    [manager setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    [manager setDelegate:self];
    [manager startAsynchronous];
}


#pragma mark –
#pragma mark 请求完成 requestFinished
- (void)requestFailed:(ASIHTTPRequest *)r
{
    NSError *error = [r error];
    
    NSLog(@"member_info:%@",error);
}

- (void)requestFinished:(ASIHTTPRequest *)r
{
    [HUD hide:YES];
    
   
    
    switch (r.tag) {
        case 1010:
        {
            NSData *jsonData = [r responseData];
            NSError *error = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
            
            NSArray *items=(NSArray*)jsonObject;
            
            UserPhotoList=nil;
            UserPhotoList=[NSMutableArray array];
            
            [UserPhotoList addObjectsFromArray:items];
            
            items=nil;
        }
            break;
            
        case 1030:
        {
            
            NSData *jsonData = [r responseData];
            NSError *error = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];

            Mobile = [jsonObject objectForKey:@"ManagerMobile"];
            
            
            
            NSLog(@"Mobile===%@",Mobile);
        }
            break;
            
            
    }
    
    //    [tb reloadRowsAtIndexPaths:
    //              withRowAnimation:UITableViewRowAnimationFade];
    
    [tb reloadData];
    r=nil;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    _AppDelegate.chatDelegate=self;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.request clearDelegatesAndCancel];
    self.request=nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.row) {
            
        case 0:
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell0"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                

                
                //设置头像
                UIImageView *Avatar = [self.view addImageView:cell.contentView
                                                        image:@"noAvatar.png"
                                                     position:CGPointMake(10, 10)];
                CALayer * ll =Avatar.layer;
                [ll setMasksToBounds:YES];
                [ll setCornerRadius:6.0];

                
                NSString *FileName=[MemberInfo objectForKey:@"Avatar"];
                NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,UserId,FileName]];
                
                
                [Avatar setImageWithURL:url
                       placeholderImage:[UIImage imageNamed:@"noAvatar.png"]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  
                              }];
                
                //用户名
                UILabel *un=[self.view addLabel:cell.contentView
                                          frame:CGRectMake(100, 10, 200, 30)
                                           font:[UIFont systemFontOfSize:22]
                                           text:[MemberInfo objectForKey:@"UserName"]
                                          color:[UIColor blackColor]
                                            tag:0];
                
                
                un.shadowOffset=CGSizeMake(0, 1);
                un.shadowColor=[UIColor whiteColor];

                //签名
                UILabel *sign= [self.view addLabel:cell.contentView
                                             frame:CGRectMake(0, 0, 210, 80)
                                              font:[UIFont systemFontOfSize:12]
                                              text:signature
                                             color:[UIColor grayColor]
                                               tag:0];

                sign.numberOfLines=0;
                sign.lineBreakMode=UILineBreakModeWordWrap;
                

                
                
                
                CGSize labelsize = [signature sizeWithFont:[UIFont systemFontOfSize:12]
                                         constrainedToSize:CGSizeMake(210,2000)
                                             lineBreakMode:UILineBreakModeWordWrap];
                
                sign.frame=CGRectMake(100, 40, labelsize.width, labelsize.height);
                

            }

            
        }
            break;
            
        case 1:
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell0"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            cell.clipsToBounds=YES;
            
            UIImageView *im=[self.view addImageView:cell.contentView
                                              image:@"user_row_content.png"
                                           position:CGPointMake(0, 0)];
            
            im.center=CGPointMake(160, im.center.y);
            
            
            UIButton *bt0= [self.view addButton:cell.contentView
                                          image:@"user_chat.png"
                                       position:CGPointMake(10, 10)
                                            tag:1100
                                         target:self
                                         action:@selector(onStartChatDown:)];
            

            
            //拨号
            if( !Mobile || [Mobile isKindOfClass:[NSNull class]] )
            {
               
                [self.view addImageView:cell.contentView
                                  image:@"user_not_dial.png"
                               position:CGPointMake(167, 10)];
            }
            
            else
            {
                [self.view addButton:cell.contentView
                                           image:@"user_dial.png"
                                        position:CGPointMake(167, 10)
                                             tag:1101
                                          target:self
                                          action:@selector(onDial:)];
                
            }

            
            UILabel *n2=[self.view addLabel:im
                                      frame:CGRectMake(10, 0, 100, 25)
                                       font:[UIFont boldSystemFontOfSize:16]
                                       text:@"私人相册"
                                      color:[UIColor blackColor] tag:0];
            
            n2.center=CGPointMake(n2.center.x, 85);
            
            
            
            for (int i=0; i<4; i++) {
                member_photo *p=[[member_photo alloc] initWithFrame:CGRectMake(20+65*i, 115, 50, 50)];
                p.tag=1800+i;
                [cell.contentView addSubview:p];
                p.hidden=YES;
            }
            
            //有照片
            if([UserPhotoList count]>0)
            {
                for(int i=0;i<4;i++)
                {
                    if(i>[UserPhotoList count]-1)
                    {
                        break;
                    }

                    [self.view addImageView:cell.contentView
                                      image:@"place_arrow.png"
                                   position:CGPointMake(283, 135)];
                    
                    
                    member_photo *pre=(member_photo*)[cell.contentView viewWithTag:1800+i];
                    
                    pre.hidden=NO;
                    
                    NSDictionary *pd=[UserPhotoList objectAtIndex:i];
                    NSString *FileName=[pd objectForKey:@"Path"];
                    
                    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,UserId,[NSString stringWithFormat:@"thumb_%@",FileName]]];
                    
                    [pre loadImage:url
                              Lock:AlbumPassword];
                    
                    [self.view addTapEvent:pre target:self action:@selector(onAblumDown:)];
                    
                    
                }
            }
            
            
            
            
        }
            break;
            
        case 2:
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
            UIImageView *im=[self.view addImageView:cell.contentView
                                              image:@"user_row_top.png"
                                           position:CGPointMake(0, 0)];
            
            im.center=CGPointMake(160, im.center.y);
            
            
            
            UILabel *n=[self.view addLabel:im
                                     frame:CGRectMake(10, 0, 100, 25)
                                      font:[UIFont boldSystemFontOfSize:16]
                                      text:@"个人简介"
                                     color:[UIColor blackColor] tag:0];
            
            n.center=CGPointMake(n.center.x, 18);
            
        }
            break;
            
            
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
            
            UIImageView *im=[self.view addImageView:cell.contentView
                                              image:@"user_row_middle.png"
                                           position:CGPointMake(0, 0)];
            
            im.center=CGPointMake(160, im.center.y);
            
            CGRect f=im.frame;
            f.size.height=orgHeight+10;
            im.frame=f;
            
            
            
            
            
            UILabel *n=[self.view addLabel:im
                                     frame:CGRectMake(10, 0, 280, orgHeight)
                                      font:[UIFont systemFontOfSize:14]
                                      text:intro
                                     color:[UIColor blackColor] tag:0];
            n.numberOfLines=0;

            if([intro isEqualToString:@"无"])
            {
                n.textColor=[UIColor grayColor];
                n.text=@"没有个人简介";
            }
            
            
                       
            
            [self.view addImageView:cell.contentView
                              image:@"user_row_bottom.png"
                           position:CGPointMake(10, f.size.height)];
            
        }
            break;
            
    }
    
    

    
    
    return cell;
}


-(void)onDial:(id)sender
{
    
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"立即预约",nil];
    [menu showInView:self.view];
    
}


//真正开始拨号了
- (void)actionSheet:(UIActionSheet *)as didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        return;
    }
    
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    if(ck==nil)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",Mobile]]];
    
    //拨打统计
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@PlaceManager?mid=%d&num=1",ServerURL,mid]];
    ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:url];
    req.timeOutSeconds=TIMEOUT;
    req.tag=1020;
    [req setRequestMethod:@"PUT"];
    [req setUseCookiePersistence:NO];
    [req setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    [req setDelegate:self];
    [req startAsynchronous];
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [alertView show];
    
    NSLog(@"%d  %@  %d",buttonIndex,[alertView textFieldAtIndex:0].text,AlbumPassword);
    
    switch ( buttonIndex ) {
            
        case 1:
        {
            //判断密码输入是否正确
            if(AlbumPassword!=[[alertView textFieldAtIndex:0].text integerValue])
            {
                //锁定
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"访问限制"
                                                                    message:@"请输入访问密码"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确定",nil];
                
                alertView.alertViewStyle=UIAlertViewStyleSecureTextInput;
                [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
                [alertView show];
            }
            else
            {
                //相册
                self_photo_list *mm = [[self_photo_list alloc] init];
                [mm setUid:UserId RoleId:0];
                [self.navigationController pushViewController:mm animated:YES];
            }
        }
            break;
    }
    
}

-(void)onAblumDown:(id)sender
{
    NSLog(@"相册");
    
    if(AlbumPassword>0)
    {
        //锁定
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"访问限制"
                                                            message:@"请输入访问密码"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
        
        alertView.alertViewStyle=UIAlertViewStyleSecureTextInput;
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
        [alertView show];
    }
    else
    {
        //相册
        self_photo_list *mm = [[self_photo_list alloc] init];
        [mm setUid:UserId RoleId:0];
        [self.navigationController pushViewController:mm animated:YES];
        
    }

}

-(void)onStartChatDown:(UIButton*)sender
{
    //开始聊天
    appointment_chat *cc=[[appointment_chat alloc] init];
    
    [cc setRev:[[MemberInfo objectForKey:@"UserId"] integerValue]
       revName:[MemberInfo objectForKey:@"UserName"]
     revAvatar:[MemberInfo objectForKey:@"Avatar"]];
    
    
    [self.navigationController pushViewController:cc animated:YES];
}





#pragma mark - Table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.row) {
            
        case 0:
        {
            return 100;
        }
            break;

        case 1:
        {
            return 200;
        }
            break;
            
        case 2:
        {
            return 40;
        }
            break;
            
        case 3:
        {
            //            if(!isOpen&&orgHeight>MinHeight)
            //            {
            //                return MinHeight;
            //            }
            
            return  orgHeight+30;
        }
            
            
        default:
        {
            return 40;
        }
            break;
            
            
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onBack:)
                                                              target:self];
    
}


-(void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
