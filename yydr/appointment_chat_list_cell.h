//
//  appointment_chat_list_cell.h
//  yydr
//
//  Created by liyi on 13-5-13.
//
//

#import <UIKit/UIKit.h>

@interface appointment_chat_list_cell : UITableViewCell
{
    UIImageView *photo,*qNum;
    UILabel *UserName,*Msg,*num,*cdate;  
}
@property (nonatomic,strong) UILabel *UserName;
@property (nonatomic,strong) UIImageView *photo;
@property (nonatomic,strong) UIImageView *qNum;
@property (nonatomic,strong) UILabel *Msg;
@property (nonatomic,strong) UILabel *num;
@property (nonatomic,strong) UILabel *cdate;

-(void)setNewMessageNum:(int)n;
@end
