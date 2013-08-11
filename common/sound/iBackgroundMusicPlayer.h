//
//  iBackgroundMusicPlayer.h
//  test
//
//  Created by 毅 李 on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface iBackgroundMusicPlayer : NSObject
+(void)init:(NSString*)_n Loop:(int)_l;
+(void)fadeOut;
+(void)fadeIn;
+(int)getVolume;
@end
