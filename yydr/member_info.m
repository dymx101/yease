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
        
    }
    return self;
}


-(void)loadInfo:(NSDictionary*)info Appointment:(BOOL)app
{
    isApp=app;
    
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
    intro=@"[汽车之家 试驾体验]  本田最近在国内动作不小，前不久广汽本田刚刚推出了一款叫凌派的紧凑型车，现在东风本田又拿出了一款重量级的全球产品，名字叫JADE，中文名称为杰德，听起来很像动画片里面劫富济贫的江洋大盗。当然吸引人的并不是它的名字，而是它在第九代思域的基础上进行开发，并且加入了第三排座椅，日本人真是把空间这件事玩的很出彩。以厂商的宣传来看，这是一款针对80后年轻家庭用户而设计的新车型，如果要说车型分类，我们姑且把它叫做迷你MPV吧，那么这样一款定位明确的产品，是否能打动目标用户的心呢？";
    
    CGSize titleSize = [intro sizeWithFont:[UIFont systemFontOfSize:14.f]
                         constrainedToSize:CGSizeMake(280, MAXFLOAT)
                             lineBreakMode:UILineBreakModeWordWrap];
    
    orgHeight=titleSize.height+50;
    
    
    [self loadAblum:UserId];
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
    NSString *sUrl=[NSString stringWithFormat:@"%@userphoto?uid=%d",ServerURL,UserId];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.row) {
            
        case 0:
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
                           image:@"manager_chat_bt.png"
                        position:CGPointMake(0, 0)
                             tag:1100
                          target:self
                          action:@selector(onDown:)];
            
            
            UILabel *n=[self.view addLabel:bt0
                                     frame:CGRectMake(10, 0, 100, 25)
                                      font:[UIFont boldSystemFontOfSize:16]
                                      text:@"聊天"
                                     color:[UIColor blackColor] tag:0];
            
            n.center=CGPointMake(130, 25);
            
            
            
            UIButton *bt1= [self.view addButton:cell.contentView
                                          image:@"manager_dial_bt.png"
                                       position:CGPointMake(150, 0)
                                            tag:1101
                                         target:self
                                         action:@selector(onDown:)];

            UILabel *n1=[self.view addLabel:bt1
                                     frame:CGRectMake(10, 0, 100, 25)
                                      font:[UIFont boldSystemFontOfSize:16]
                                      text:@"拨号"
                                     color:[UIColor blackColor] tag:0];
            
            n1.center=CGPointMake(130, 25);
            
            
            //
            
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
                    
                    member_photo *pre=(member_photo*)[cell.contentView viewWithTag:1800+i];
                    
                    pre.hidden=NO;
                    
                    NSDictionary *pd=[UserPhotoList objectAtIndex:i];
                    NSString *FileName=[pd objectForKey:@"Path"];
                    
                    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,UserId,[NSString stringWithFormat:@"thumb_%@",FileName]]];
                    
                    [pre loadImage:url
                              Lock:AlbumPassword];
                    
                }
            }
            

            
        }
            break;
                 
        case 1:
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
            
            
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
            cell.contentView.frame=CGRectMake(0, 0, 100, 50);
            
            UIImageView *im=[self.view addImageView:cell.contentView
                                              image:@"user_row_middle.png"
                                           position:CGPointMake(0, 0)];
            
            im.center=CGPointMake(160, im.center.y);
            
            
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.detailTextLabel.text = intro;
            cell.detailTextLabel.frame=CGRectMake(0, 0, 100, 200);
            
            if(isOpen)
            {
                cell.detailTextLabel.numberOfLines = 0;
            }
            else
            {
                cell.detailTextLabel.numberOfLines = 3;
            }
            
            
            cell.clipsToBounds=YES;
            
            
        }
            break;
            
            
    }
    
    
    
    
    
    /*
     switch (indexPath.row) {
     
     
     case 0:
     {
     static NSString *CellIdentifier = @"cell";
     cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     
     if(cell==nil)
     {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
     reuseIdentifier:@"place_detail_cell_0"];
     }
     
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
     
     cell.textLabel.numberOfLines = 0;
     cell.textLabel.textAlignment=UITextAlignmentLeft;
     
     cell.textLabel.text=signature;
     cell.textLabel.font=[UIFont systemFontOfSize:14];
     
     }
     break;
     
     
     case 0:
     {
     static NSString *CellIdentifier = @"cell";
     cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     if(cell==nil)
     {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
     reuseIdentifier:@"place_detail_cell_0"];
     cell.textLabel.text=@"私人相册";
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
     
     
     for (int i=0; i<3; i++) {
     member_photo *p=[[member_photo alloc] initWithFrame:CGRectMake(95+60*i, 20, 50, 50)];
     p.tag=1800+i;
     [cell.contentView addSubview:p];
     p.hidden=YES;
     }
     }
     
     //有照片
     if([UserPhotoList count]>0)
     {
     
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     
     for(int i=0;i<3;i++)
     {
     if(i>[UserPhotoList count]-1)
     {
     break;
     }
     
     member_photo *pre=(member_photo*)[cell.contentView viewWithTag:1800+i];
     
     pre.hidden=NO;
     
     NSDictionary *pd=[UserPhotoList objectAtIndex:i];
     NSString *FileName=[pd objectForKey:@"Path"];
     
     NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,UserId,[NSString stringWithFormat:@"thumb_%@",FileName]]];
     
     [pre loadImage:url
     Lock:AlbumPassword];
     
     }
     }
     
     }
     break;
     
     case 1:
     {
     //简介
     static NSString *CellIdentifier = @"place_detail_cell_1";
     cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     
     if(cell==nil)
     {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
     reuseIdentifier:CellIdentifier];
     }
     
     
     
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
     
     
     cell.textLabel.text=@"个人简介";
     
     cell.tag=1100;
     cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
     cell.detailTextLabel.text = intro;
     
     
     if(isOpen)
     {
     cell.detailTextLabel.numberOfLines = 0;
     }
     else
     {
     cell.detailTextLabel.numberOfLines = 3;
     }
     
     
     cell.clipsToBounds=YES;
     
     
     NSLog(@"%f %f",cell.frame.origin.x,cell.frame.origin.y);
     }
     break;
     
     case 2:
     {
     static NSString *CellIdentifier = @"place_detail_cell_2";
     cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     
     if(cell==nil)
     {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
     reuseIdentifier:CellIdentifier];
     }
     
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
     cell.textLabel.text=@"联系电话";
     
     cell.detailTextLabel.text=@"13343242342";
     
     }
     break;
     
     }
     */
    
    
    
    
    return cell;
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
                [mm setUid:UserId];
                [self.navigationController pushViewController:mm animated:YES];
            }
        }
            break;
    }
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
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
                [mm setUid:UserId];
                [self.navigationController pushViewController:mm animated:YES];
                
            }
        }
            break;
            
        case 3:
        {
            //个人简介
            NSLog(@"个人简介");
            
            if (orgHeight<MinHeight)
            {
                return;
            }
            
            isOpen=!isOpen;
            
            [tb reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                      withRowAnimation:UITableViewRowAnimationFade];
            
        }
            break;
            
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * hView;
    
    hView=[[UIView alloc] initWithFrame:CGRectMake(20, 5, 300, 30)];
    
    //设置头像
    UIImageView *Avatar = [self.view addImageView:hView
                                            image:@"noAvatar.png"
                                         position:CGPointMake(20, 10)];
    
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
    UILabel *un=[self.view addLabel:hView
                              frame:CGRectMake(110, 10, 200, 30)
                               font:[UIFont systemFontOfSize:22]
                               text:[MemberInfo objectForKey:@"UserName"]
                              color:[UIColor blackColor]
                                tag:0];
    
    un.shadowOffset=CGSizeMake(0, 1);
    un.shadowColor=[UIColor whiteColor];
    
    UILabel *sign= [self.view addLabel:hView
                                 frame:CGRectMake(0, 0, 200, 80)
                                  font:[UIFont systemFontOfSize:12]
                                  text:signature
                                 color:[UIColor blackColor]
                                   tag:0];
    
    
    sign.numberOfLines=0;
    sign.lineBreakMode=UILineBreakModeWordWrap;
    
    CGSize labelsize = [signature sizeWithFont:[UIFont systemFontOfSize:12]
                             constrainedToSize:CGSizeMake(200,2000)
                                 lineBreakMode:UILineBreakModeWordWrap];
    
    sign.frame=CGRectMake(110, 40, labelsize.width, labelsize.height);
    
    
    return hView;
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



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100.f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.row) {
            /*
             case 0:
             {
             CGSize titleSize = [signature sizeWithFont:[UIFont systemFontOfSize:16.f]
             constrainedToSize:CGSizeMake(280, MAXFLOAT)
             lineBreakMode:UILineBreakModeWordWrap];
             
             return titleSize.height+20;
             }
             break;
             */
            
        case 0:
        {
            return 200;
        }
            break;
            
        case 1:
        {
            return 40;
        }
            break;
              
        case 2:
        {
            if(!isOpen&&orgHeight>MinHeight)
            {
                return MinHeight;
            }
            
            return  300;// orgHeight;
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
