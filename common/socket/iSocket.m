//
//  page_socket.m
//  bz
//
//  Created by 毅 李 on 12-9-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iSocket.h"

@implementation iSocket

@synthesize delegate;

- (int) connectServer:(NSString *) hostIP port:(int) hostPort
{
    ip=hostIP;
    port=hostPort;
    
    if (client == nil) {  
        client = [[AsyncSocket alloc] initWithDelegate:self];  
        client.delegate=self;
        
        NSError *err = nil;  
        
        if (![client connectToHost:hostIP onPort:hostPort error:&err]) {  
          //  NSLog(@"Error: %@", err);
            return 0;
        }  
    }  
    return 1;
}

-(void)update
{
    //NSLog(@"reconnect");
    [self connectServer:ip port:port];
}


-(void)setLight:(UIImageView*)im
{
    light=im;
}

-(void)send:(NSString*)s
{
    NSLog(@"%@",s);
    
    NSData* aData= [s dataUsingEncoding: NSUTF8StringEncoding];
    [client writeData:aData withTimeout:-1 tag:1];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"Disconnect");
    client=nil;
    light.image=[UIImage imageNamed:@"bt15.png"];

    
    timer=[NSTimer scheduledTimerWithTimeInterval:1
                                           target:self 
                                         selector:@selector(update) 
                                         userInfo:nil
                                          repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}  

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"error");
}

//连接成功回调
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{ 
    NSLog(@"Connected");
    [client readDataWithTimeout:-1 tag:0];
    light.image=[UIImage imageNamed:@"bt15_h.png"];
    
    [timer invalidate];
    timer=nil;
}  

//接受数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
    NSLog(@"Hava received datas is :%@",aStr);
    
    
    if([delegate conformsToProtocol:@protocol(iSocketDelegate)])
    {
        [delegate iSocketReceive:aStr];
    }

    
    
}



@end
