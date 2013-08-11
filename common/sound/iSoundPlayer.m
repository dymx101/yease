//
//  iSoundManager.m
//  test
//
//  Created by 毅 李 on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iSoundPlayer.h"

@implementation iSoundPlayer

-(id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}


-(id)initWithFile:(NSString *)_n numberOfLoops:(int)_l
{
    if(self =[self init])
    {
        NSError *error = nil;	
        NSString *path = [[NSBundle mainBundle] pathForResource:_n ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        sp = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        sp.numberOfLoops=_l; 
    }
    return  self;
}

+(id)soundWithFile:(NSString *)_n numberOfLoops:(int)_l;
{
    return [[self alloc] initWithFile:_n numberOfLoops:_l];
}

-(void)play
{
    [sp play];
}

-(void)stop
{
    [sp stop];
}

-(void)pause
{
    [sp pause];
}

-(void)fadeOut
{
    if(sp.volume>0.1)
    {
        sp.volume=sp.volume-0.1;
        [self performSelector:@selector(fadeOut) withObject:nil afterDelay:0.1];  
    }
    else
    {
        [sp stop];
    }
}

-(void)fadeIn
{
    [sp play];
    
    if(sp.volume<1)
    {
        sp.volume=sp.volume+0.1;
        [self performSelector:@selector(fadeIn) withObject:nil afterDelay:0.1];  
    }
}
@end
