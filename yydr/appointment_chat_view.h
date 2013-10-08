//
//  appointment_chat_view.h
//  yydr
//
//  Created by Li yi on 13-10-2.
//
//

#import "iPageView.h"

@interface appointment_chat_view : iPageView
{
    UIImage *bubble,*sbubble,*avatar;
    CGSize bubbleSize,bodySize;
    NSString *UserName,*Sender,*Msg,*Avatar;
    int sid,mid;
    NSString *type,*cdate;
    NSDictionary *msgDict;
    UIImageView *AvatarImageView;
}

@property (nonatomic,strong) UIImageView *AvatarImageView;
@property (nonatomic,strong) NSDictionary *msgDict;
-(void)loadMessage:(NSDictionary*)msg;

@end
