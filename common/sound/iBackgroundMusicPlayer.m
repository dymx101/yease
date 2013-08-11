//
//  iBackgroundMusicPlayer.m
//  test
//
//  Created by 毅 李 on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iBackgroundMusicPlayer.h"

static AVAudioPlayer *bmp;

@implementation iBackgroundMusicPlayer

+(void)init:(NSString*)_n Loop:(int)_l
{
    NSError *error = nil;	
    NSString *path = [[NSBundle mainBundle] pathForResource:_n ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    bmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    bmp.numberOfLoops=_l;
}

+(int)getVolume
{
    return bmp.volume;
}

+(void)fadeOut
{
    if(bmp.volume>0.1)
    {
        bmp.volume=bmp.volume-0.1;
        [self performSelector:@selector(fadeOut) withObject:nil afterDelay:0.1];  
    }
    else
    {
        [bmp stop];
    }
}

+(void)fadeIn
{
    [bmp play];
    
    if(bmp.volume<1)
    {
        bmp.volume=bmp.volume+0.1;
        [self performSelector:@selector(fadeIn) withObject:nil afterDelay:0.1];  
    } 
}
@end
