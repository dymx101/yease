//
//  girl_chat_cell.h
//  yydr
//
//  Created by liyi on 13-4-25.
//
//

#import <UIKit/UIKit.h>

@interface appointment_chat_cell : UITableViewCell
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
