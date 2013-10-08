//
//  AppDelegate.m
//  yydr
//
//  Created by 毅 李 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "global.h"
#import "homepage.h"
#import "Harpy.h"
#import "KeychainItemWrapper.h"
#import "chatDelegate.h"
#import "login.h"



@interface AppDelegate()

@end

@implementation AppDelegate

@synthesize chatDelegate;
@synthesize notifierView;
@synthesize window = _window;

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //
    // Override point for customization after application launch.

    
    //版本判断
    int ver=[[[NSUserDefaults standardUserDefaults] objectForKey:@"version"] integerValue];
    
    if(ver!=3)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"3"
                                                 forKey:@"version"];
        
        //////////////////////////////////////////
        //清除用户名与密码 聊天测试
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"yease"
                                                                           accessGroup:nil];
        [wrapper resetKeychainItem];

        //清除cookie
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:@"Value"];
        //id
        [[NSUserDefaults standardUserDefaults] setObject:nil
                                                  forKey:@"UserId"];
    }
    

    //初始化xmppStream
    [self setupStream];
    
    

    //============================================================================================
    //sqlite数据库
    dh=[[dbHelper alloc] init];
    [dh create];
    //============================================================================================
    

    //homepage *hp = [[homepage alloc] init];
    
    
    login *hp=[[login alloc] initWithStyle:UITableViewStyleGrouped];
    
    
    
    nav = [[UINavigationController alloc] initWithRootViewController:hp];
    
    nav.navigationBar.barStyle = UIBarStyleBlack;
    nav.navigationBar.translucent=NO;


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    NSLog(@"bounds=%f",self.window.bounds.size.height);
    
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];

    [nav setNavigationBarHidden:YES];
    [nav setNavigationBarHidden:NO];
 

    
    
    //place 新加按钮
    UIBarButtonItem *place_add_button=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                   target:self
                                                                   action:@selector(onPlaceAddDown:)];
    
    nav.navigationItem.rightBarButtonItem=place_add_button;
    
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];    
    
    //注册推送通知功能
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
                                                                           UIRemoteNotificationTypeBadge |
                                                                           UIRemoteNotificationTypeSound)];
    
    //图标上得数字
    application.applicationIconBadgeNumber = 0;
    
    //检查新版本
    [Harpy checkVersion:NO];
    
    
    //直接登入
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"yease"
                                                                       accessGroup:nil];
    
    
    password = [wrapper objectForKey:(__bridge id)kSecValueData];
    username = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
    
    int mid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];

    if(username!=nil&&mid>0)
    {
        [self connect:[NSString stringWithFormat:@"%@@%@",username,XMPPServer]
             password:password];
    }
    

    notifierView = [[FDStatusBarNotifierView alloc] initWithMessage:@""
                                                           delegate:self];
    notifierView.manuallyHide=YES;

    isShowNotifierView=YES;
    
    
    return YES;
}

#pragma mark ------------
#pragma mark - 推送相关回调
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"apns -> 注册推送功能时发生错误， 错误信息:\n %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"\napns -> didReceiveRemoteNotification,Receive Data:\n%@", userInfo);
    

    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
        
        //application.applicationIconBadgeNumber = 10;
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"**推送消息**"
                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:@"处理推送内容",nil];
        [alert show];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
    
    NSString *tokenStr = [deviceToken description];
    NSString *pushToken = [[[tokenStr
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"DeviceToken=%@",pushToken);
    
    //记录推送的Token
    [[NSUserDefaults standardUserDefaults] setObject:pushToken
                                              forKey:@"DeviceToken"];
}

#pragma mark -------------
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    NSLog(@"切换到前台");
    [xmppReconnect manualStart];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)dealloc
{
	[self teardownStream];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark xmppframework
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data 暂时不知道什么用
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 上线/下线
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	[[self xmppStream] sendElement:presence];
}


- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 初始化/释放
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	[xmppReconnect setAutoReconnect:YES];
    
	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
	[xmppStream setHostName:ChatServerURL];
	[xmppStream setHostPort:5222];
	
    
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 连接/断开
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)connect:(NSString*)myJID password:(NSString*)myPassword
{
    
    NSLog(@"连接xmpp服务器 %@ %@",myJID,myPassword);
    
    
	if (![xmppStream isDisconnected]) {
	
        NSLog(@"isDisconnected");
        return YES;
	}
    
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connect:&error])
	{
        
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
         
		return NO;
	}
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 连接回调函数
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	NSLog(@"xmppStream_socketDidConnect");
    
}


- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	isXmppConnected = YES;
    
    NSError *error=nil;

	if (![[self xmppStream] authenticateWithPassword:password
                                               error:&error])
	{
		NSLog(@"xmppStreamDidConnect:%@",error);
	}
}


-(void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags
{
    NSLog(@"didDetectAccidentalDisconnect");
  
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 注册新用户回调
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
	NSLog(@"不会有这个注册回调");
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
	NSLog(@"不会有这个注册回调");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 登入验证回调
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"xmpp登入成功");
    //上线
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
  
    NSLog(@"聊天服务器登入失败 error=%@",error);
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	NSLog(@"xmppStream_didReceivePresence:%@",presence);
}


-(void)hide
{
    [notifierView hide];
}

- (void)setShow:(BOOL)b
{
    isShowNotifierView=b;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
    NSLog(@"在AppDelegate中接受得内容:\n%@",message);
    
    
    //统一在这里解析消息
    NSString *body = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *avatar = [[message elementForName:@"avatar"] stringValue];
    

    //发送消息的sid,就是did。
    int did = [[[message elementForName:@"sid"] stringValue] integerValue];

    //自己的userid
    int mid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];

    
    
    //解析到 NSDictionary ==============================
    NSArray *array = [from componentsSeparatedByString:@"@"]; //从字符@中分隔成2个元素的数组
    
    NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:
                         [array objectAtIndex:0],@"From",
                         [NSDate date],@"CreateDate",
                         body,@"Body",
                         [NSString stringWithFormat:@"%d",did],@"Sid",
                         avatar,@"Avatar",
                         nil];
    //==================================================
    
    
    NSString *_username=[array objectAtIndex:0];
    
  // NSLog(@"did=%d mid=%d username=%@",did,mid,[array objectAtIndex:0]);
    

    
    //更新数据库
    [dh updateDatabase:did
              senderid:did
                selfid:mid
            dialogname:_username
          dialogavatar:avatar
               message:body
                  type:1
             addNewMsg:1];
    

    [chatDelegate messageReceived:msg];
    
    
    //顶部聊天显示,在跟当事人聊天的时候不需要
    if(isShowNotifierView)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(hide)
                                                   object:nil];
        
        notifierView.message=[NSString stringWithFormat:@"%@：%@",_username,body];
        
        [notifierView showInWindow:self.window];
        [self performSelector:@selector(hide)
                   withObject:nil
                   afterDelay:3];
    }
    
}




@end
