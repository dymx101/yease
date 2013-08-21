//
//  girl_chat.m
//  yydr
//
//  Created by liyi on 12-12-19.
//
//

#import "appointment_chat.h"
#import "appointment_chat_cell.h"

#import "UIView+iImageManager.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIView+iButtonManager.h"

#import "global.h"

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

#import "NSDataAdditions.h"

#import <AudioToolbox/AudioToolbox.h>

@interface appointment_chat ()

@end

@implementation appointment_chat
@synthesize messageArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom in不itialization

        //底部输入框
        int tHeight=44;
        int tWidth=300;
        //int off=_AppDelegate.notifierView.hidden==YES?0:20;
        
        
        tb=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44-tHeight)];
        tb.delegate=self;
        tb.dataSource=self;
        tb.separatorStyle = NO;

        tb.backgroundView= [self.view addImageView:nil
                                             image:@"place_tel_bbg.png"
                                          position:CGPointMake(0, 0)];
        [self.view addSubview:tb];
        
        
        [self.view addTapEvent:self.view
                        target:self
                        action:@selector(onTap:)];
        
        
     
    
        NSLog(@"%f",self.view.frame.size.height-tHeight-44);
        NSLog(@"%f",self.view.bounds.size.height-tHeight-44);
    
        

        

        inputView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             self.view.bounds.size.height-tHeight-44,
                                                             320,
                                                             tHeight)];
        inputView.backgroundColor=[UIColor redColor];
        

        
        [self.view addButton:inputView
                       image:@"chat_photo_bt.png"
                    position:CGPointMake(300, 0)
                         tag:1100
                      target:self
                      action:@selector(onDown:)];
        
        
        
        
        
        
        
        tv = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 5, tWidth, 40)];
        tv.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        tv.minNumberOfLines = 1;
        tv.maxNumberOfLines = 5;
        tv.returnKeyType =UIReturnKeySend;
        tv.font = [UIFont systemFontOfSize:15.0f];
        tv.delegate = self;
        tv.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        tv.backgroundColor = [UIColor whiteColor];
        
        // textView.text = @"test\n\ntest";
        // textView.animateHeightChange = NO; //turns off animation
        
        //输入框
        UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
        UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
        entryImageView.frame = CGRectMake(5, 0, tWidth+2, tHeight);
        entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        //输入框背景
        UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
        UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
        imageView.frame = CGRectMake(0, 0, inputView.frame.size.width, inputView.frame.size.height);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        tv.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        
        // view hierachy
        [inputView addSubview:imageView];
        [inputView addSubview:tv];
        [inputView addSubview:entryImageView];
        
        [self.view addSubview:inputView];
        

        //键盘出现隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
        
        messageArray=nil;
        messageArray=[NSMutableArray new];
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{

}


-(void)viewDidAppear:(BOOL)animated
{
    _AppDelegate.chatDelegate=self;
}


-(void)dealloc
{
    [_AppDelegate setShow:YES];
}

-(void)onTap:(UIGestureRecognizer*)sender
{
    [tv resignFirstResponder];    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 接受即时消息
-(void)messageReceived:(NSDictionary*)msg
{

    //播放声音
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sms_8" ofType:@"mp3"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *url = [NSURL fileURLWithPath:path];
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        AudioServicesPlaySystemSound(sound);
    }

    
    int sid=[[msg objectForKey:@"Sid"] integerValue];
    
    
    NSLog(@"在聊天中接受到消息 sid=%d did=%d",sid,did);
    
    if(did==sid)
    {
        //当前对话才更新
        [self loadHistory];
        [_AppDelegate setShow:NO];
    }

    [self scrollToBottomAnimated:YES];
    
}



#pragma mark – 清空聊天纪录
-(void)onRDown:(id*)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"是否清空聊天记录？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    
    [alertView show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ( buttonIndex ) {
        case 1:
        {
            dbHelper *dh=[[dbHelper alloc] init];
            [dh deleteRecord:did Mid:mid];
            
            
            messageArray=nil;
            messageArray=[NSMutableArray array];
            
            [tb reloadData];
        }
            
            break;
    }
    
}

-(void)loadHistory
{
    messageArray=nil;
    messageArray=[NSMutableArray array];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    dbPath = [documentPath stringByAppendingPathComponent:@"nldb.sqlite"];
    
    mid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];
    
    NSLog(@"did=%d mid=%d",did,mid);
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
    
       
        FMResultSet *resultSet = [database executeQuery:@"select * from record where did = ? and mid = ? order by createdate",
                                  [NSNumber numberWithInt:did],
                                  [NSNumber numberWithInt:mid]];


        NSDate *bdate;
        
        while ([resultSet next]) {
            int sid = [resultSet intForColumn:@"sid"];
            
            NSDate *ld=[resultSet dateForColumn:@"createdate"];
            
            if (bdate==nil) {
                bdate=ld;
                
                //需要时间
                NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:
                                     ld,@"CreateDate",
                                     @"date",@"Type",
                                     nil];
                [messageArray addObject:msg];
            }
            

            NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [resultSet stringForColumn:@"message"],@"Body",
                                 [NSString stringWithFormat:@"%d",sid],@"Sid",
                                 [NSString stringWithFormat:@"%d",did],@"Did",
                                 [NSString stringWithFormat:@"%d",mid],@"Mid",
                                 rname,@"From",
                                 ravatar,@"Avatar",
                                 ld,@"CreateDate",
                                 @"message",@"Type",
                                 nil];
            
            
            NSTimeInterval seconds = [ld timeIntervalSinceDate:bdate];
            int minutes=seconds/60;
            
            bdate=ld;
            
            //大于15分钟需要显示日起时间
            if(minutes>15)
            {
               NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:
                                    ld,@"CreateDate",
                                    @"date",@"Type",
                                    nil];
               [messageArray addObject:msg];
            }

            [messageArray addObject:msg];
        }
        
        //NSLog(@"histroy=%@",messageArray);
        
        [database close];
        
    }
    
    [self scrollToBottomAnimated:NO];
  
    [tb reloadData];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    self.navigationItem.rightBarButtonItem=[self.view add_clear_button:@selector(onRDown:)
                                                                target:self];

    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onBack:)
                                                              target:self];

    dbHelper *dh = [[dbHelper alloc] init];
    [dh updateRecordCountToZero:did Mid:mid];

}


-(void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note
{
     [self keyboardWillShowHide:note];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    [self keyboardWillShowHide:note];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         
                         
                         
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = inputView.frame;
                         inputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                           keyboardY - inputViewFrame.size.height,
                                                           inputViewFrame.size.width,
                                                           inputViewFrame.size.height);
                         
                         
                         
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - inputView.frame.origin.y-44,
                                                                0.0f);
                         
                         tb.contentInset = insets;
                         tb.scrollIndicatorInsets = insets;
                         
                         [self scrollToBottomAnimated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
    
}


-(void)setRev:(int)revId revName:(NSString*)revName revAvatar:(NSString*)revAvatar
{
    NSLog(@"setRev did=%d rname=%@ revAvatar=%@",revId,revName,revAvatar);
    
    self.title=revName;
    
    did=revId;
    rname=revName;
    ravatar=revAvatar;
    
    [self loadHistory];
}

-(void)getAvatar:(int)revId
{
    
}


#pragma mark - Text view delegate
-(void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    [growingTextView becomeFirstResponder];
    [self scrollToBottomAnimated:YES];
}


- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]&&growingTextView.text.length==0)
    {
        NSLog(@"空字符");
        return NO;
    }
    else if(growingTextView.text.length>200)
    {

        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"输入内容少200字"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else if ([text isEqualToString:@"\n"])
    {
        //获取自己的信息
        dbHelper *dh=[[dbHelper alloc] init];
        NSDictionary *userinfo = [dh getUserInfo:mid];

        NSString *MyUserName=[userinfo objectForKey:@"username"];
        
        NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:
                             MyUserName,@"From",
                             @"",@"CreateDate",
                             @"message",@"Type",
                             tv.text,@"Body", nil];
        

        [self.messageArray addObject:msg];
   
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:tv.text];
        
        //生成头像
        NSXMLElement *avatar = [NSXMLElement elementWithName:@"avatar"];
        [avatar setStringValue:[userinfo objectForKey:@"avatar"]];
        
        //生成发送者id
        NSXMLElement *uid = [NSXMLElement elementWithName:@"sid"];
        [uid setStringValue:[NSString stringWithFormat:@"%d",mid]];
        
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];

        //接受者
        NSString *Receiver=[NSString stringWithFormat:@"%@@yease.cn",rname];
        [mes addAttributeWithName:@"to" stringValue:Receiver];
        
        //发送者
        [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@@yease.cn",MyUserName]];
        
        [mes addChild:body];
        [mes addChild:avatar];
        [mes addChild:uid];

        NSLog(@"did=%d MyUserName=%@ 我发送的消息:%@",did,MyUserName,mes);
        
        //发送消息
        [[_AppDelegate xmppStream] sendElement:mes];
        
        //更新数据库
        [dh updateDatabase:did
                  senderid:mid
                    selfid:mid
                dialogname:rname
              dialogavatar:ravatar
                   message:tv.text
                      type:1  //消息类型 1-文字 2-图片 3-语音
                 addNewMsg:0];
        
        
        [self loadHistory];
        [self scrollToBottomAnimated:YES];
        
        growingTextView.text=nil;
        
        return NO;
    }
    
    return YES;
}


- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = inputView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	inputView.frame = r;

    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                           0.0f,
                                           self.view.frame.size.height - inputView.frame.origin.y-44,
                                           0.0f);
    
    tb.contentInset = insets;
    tb.scrollIndicatorInsets = insets;
    
    [self scrollToBottomAnimated:YES];
    
}

-(void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    [growingTextView resignFirstResponder];
}



- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    return NO;
}


- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [tb numberOfRowsInSection:0];
    
    if(rows > 0) {
        [tb scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                  atScrollPosition:UITableViewScrollPositionBottom
                          animated:animated];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageArray count];
}


//每行高度计算
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *type=[[messageArray objectAtIndex:indexPath.row] objectForKey:@"Type"];
    
    if([type isEqualToString:@"message"])
    {
        NSString *mm=[[messageArray objectAtIndex:indexPath.row] objectForKey:@"Body"];
        
        CGSize bubbleSize = [mm sizeWithFont:[UIFont systemFontOfSize:18.f]
                           constrainedToSize:CGSizeMake(ChatTextWidth, MAXFLOAT)
                               lineBreakMode:UILineBreakModeWordWrap];
        
        int h = bubbleSize.height>22?bubbleSize.height:22;
        
        return h+20+30;
    }
    else
    {
        return 30;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *msg=[self.messageArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"cell";
    
    appointment_chat_cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[appointment_chat_cell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
    }
    
    [cell loadMessage:msg];
    [cell setNeedsDisplay];
    
    return cell;
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    dbHelper *dh=[[dbHelper alloc] init];
    [dh updateRecordCountToZero:did Mid:mid];
    
    
    [tv resignFirstResponder];
}

@end
