//
//  girl_main.h
//  yydr
//
//  Created by liyi on 12-12-15.
//
//

#import <UIKit/UIKit.h>
#import "appointment_chat_list.h"
#import "appointment_chat.h"
#import "appointment_friend_list.h"
#import "appointment_member_list.h"

@interface appointment_main : UITabBarController<UITabBarControllerDelegate>
{
    UIBarButtonItem *rbt;
    appointment_member_list *m0;
    UITabBarItem *item1;
    dbHelper *dh;
    int mid;

}
@property (nonatomic,strong) appointment_member_list *m0;
@property (nonatomic,strong) UIBarButtonItem *rbt;
@end
