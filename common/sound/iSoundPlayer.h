//
//  iSoundManager.h
//  test
//
//  Created by 毅 李 on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface iSoundPlayer : NSObject
{
    AVAudioPlayer *sp;
}

-(id)initWithFile:(NSString *)_n numberOfLoops:(int)_l;
-(id)init;
-(void)fadeOut;
-(void)fadeIn;
-(void)play;
-(void)pause;
-(void)stop;

+(id)soundWithFile:(NSString*)_n numberOfLoops:(int)_l;

@end
