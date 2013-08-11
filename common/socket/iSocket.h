//
//  page_socket.h
//  bz
//
//  Created by 毅 李 on 12-9-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@protocol iSocketDelegate;

@interface iSocket : NSObject
{
    id<iSocketDelegate> delegate;
    
    AsyncSocket *client;
    UIImageView *light;
    
    NSString *ip;
    int port;
    
    NSTimer *timer;
    
}
@property (nonatomic,strong) id<iSocketDelegate> delegate;

-(void)setLight:(UIImageView*)im;
- (int) connectServer:(NSString *) hostIP port:(int) hostPort;
-(void)send:(NSString*)s;
@end

@protocol iSocketDelegate <NSObject>

@optional

-(void)iSocketReceive:(NSString*)rstr;

@end