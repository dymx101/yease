//
//  apointment_chat_list.m
//  yydr
//
//  Created by liyi on 13-5-13.
//
//

#import "appointment_chat_list.h"
#import "appointment_chat_list_cell.h"
#import "appointment_chat.h"




#import "global.h"

#import "UIImageView+WebCache.h"

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

#import "UIView+iButtonManager.h"


#import <AudioToolbox/AudioToolbox.h>

@interface appointment_chat_list ()

@end

@implementation appointment_chat_list

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        //表格
        tb=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44-49)];
        [self.view addSubview:tb];
        tb.separatorStyle = NO;
        tb.delegate=self;
        tb.dataSource=self;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    mid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];
}

-(void)viewDidAppear:(BOOL)animated
{
    _AppDelegate.chatDelegate=self;
    [self updateNewMessageCount];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark -
#pragma mark 表格回调
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dialogArray count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark -
#pragma mark 滑动删除对话
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    

    NSDictionary *dialog=[dialogArray objectAtIndex:indexPath.row];
    int sid=[[dialog objectForKey:@"Sid"] integerValue];
    dbHelper *dh=[[dbHelper alloc] init];
    [dh deleteDialog:sid Mid:mid];
    
    
    [dialogArray removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tb deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"comment_list_cell";
    appointment_chat_list_cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *UserDetail=[dialogArray objectAtIndex:indexPath.row];
    
    if (cell == nil)
    {
        cell = [[appointment_chat_list_cell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:CellIdentifier];
    }
    
    cell.UserName.text=[UserDetail objectForKey:@"From"];
    
    [cell setNewMessageNum:[[UserDetail objectForKey:@"Count"] integerValue]];
    
    
    cell.Msg.text=[UserDetail objectForKey:@"Message"];
    
    [cell.Msg sizeToFit];
    CGRect f=cell.Msg.frame;
    f.size.width=200;
    f.origin.y=35;
    cell.Msg.frame=f;
    
    
    int UserId=[[UserDetail objectForKey:@"Sid"] integerValue];
    NSString *FileName=[UserDetail objectForKey:@"Avatar"];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,UserId,FileName]];

    //日期
    NSDate *nowDate=[NSDate date];
    NSDate *ld=[UserDetail objectForKey:@"LastDate"];
    
    NSTimeInterval seconds = [nowDate timeIntervalSinceDate:ld];
    int days=((int)seconds)/(3600*24);

    if(days>1)
    {
        //n天以前
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        cell.cdate.text = [dateFormatter stringFromDate:ld];
    }
    else if(days==1)
    {
        //昨天
        cell.cdate.text = @"昨天";
    }
    else
    {
        //今天
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        cell.cdate.text = [dateFormatter stringFromDate:ld];
    }
    
    //头像
    [cell.photo setImageWithURL:url
               placeholderImage:[UIImage imageNamed:@"noAvatar.png"]];
     
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"开始聊天");
    
    [_AppDelegate.notifierView hide];
    
    NSDictionary *UserDetail=[dialogArray objectAtIndex:indexPath.row];
    
    int sid=[[UserDetail objectForKey:@"Sid"] integerValue];
    
    
    NSLog(@"sid=%d mid=%d",sid,mid);
    
    //读取消息后清0
    dbHelper *dh=[[dbHelper alloc] init];
    [dh updateRecordCountToZero:sid Mid:mid];

    
    

    //去聊天
    appointment_chat *cc=[[appointment_chat alloc] init];
    cc.title=[UserDetail objectForKey:@"From"];
    
    //设置接受者id、用户名
    [cc setRev:[[UserDetail objectForKey:@"Sid"] integerValue]
       revName:[UserDetail objectForKey:@"From"]
     revAvatar:[UserDetail objectForKey:@"Avatar"]];
    
    
    [self.navigationController pushViewController:cc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}


-(void)messageReceived:(NSDictionary *)msg
{
    NSLog(@"在对话列表里收到消息: %@",msg);
    
    //播放声音
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sms_8" ofType:@"mp3"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *url = [NSURL fileURLWithPath:path];
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        AudioServicesPlaySystemSound(sound);
    }
        
    [self updateNewMessageCount];

}


//更新新消息数量
-(void)updateNewMessageCount
{
    dialogArray=nil;
    dialogArray=[NSMutableArray array];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    dbPath = [documentPath stringByAppendingPathComponent:@"nldb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return;
    }
    
    FMResultSet *resultSet = [database executeQuery:@"select * from dialog where mid=? order by lastdate desc",
                              [NSNumber numberWithInt:mid]];

    while ([resultSet next]) {
        int sid = [resultSet intForColumn:@"did"];
        int count = [resultSet intForColumn:@"count"];
        NSDate *ld=[resultSet dateForColumn:@"lastdate"];
        
        NSString *avatar=[resultSet stringForColumn:@"avatar"];

        
        NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:
                             [resultSet stringForColumn:@"username"],@"From",
                             ld,@"LastDate",
                             [resultSet stringForColumn:@"message"],@"Message",
                             [NSString stringWithFormat:@"%d",sid],@"Sid",
                             [NSString stringWithFormat:@"%d",count],@"Count",
                             avatar==nil?@"noAvatar":avatar,@"Avatar",
                             nil];
        
        [dialogArray addObject:msg];
    }
    
    
    //NSLog(@"dialogArray=====%@",dialogArray);
    
    
    [database close];
    [tb reloadData];
    
    dbHelper *dh=[[dbHelper alloc] init];
    int newMsgCount=[dh getNewMessageCount:mid];
    
    if(newMsgCount>0)
    {
        [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d",newMsgCount]];
    }
    else
    {
        [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
    }
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
