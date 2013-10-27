//
//  AppDelegate.h
//  yydr
//
//  Created by 毅 李 on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "FDStatusBarNotifierView.h"
#import "dbHelper.h"

//百度推送
#import "BPush.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPStreamDelegate,XMPPRosterDelegate,XMPPReconnectDelegate,FDStatusBarNotifierViewDelegate,BPushDelegate>
{
    UINavigationController *nav;
    
    //==========================================
    //XMPP
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    
    NSString *password;
	NSString *username;
    
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    
    dbHelper *dh;
    
    FDStatusBarNotifierView *notifierView;
    BOOL isShowNotifierView;

    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) FDStatusBarNotifierView *notifierView;
//================================================================================
//XMPP
@property(nonatomic, strong)id chatDelegate;

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

//花名册
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect:(NSString*)myJID password:(NSString*)myPassword;
- (void)disconnect;
- (void)setShow:(BOOL)b;
- (void)goOffline;

@end







