//
//  member_photo.h
//  yydr
//
//  Created by Li yi on 13-5-26.
//
//

#import <UIKit/UIKit.h>

@interface member_photo : UIView
{
    UIImageView *im;
    UIImageView *lock;
}

-(void)loadImage:(NSURL*)url Lock:(int)l;

@end
