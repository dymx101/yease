//
//  homepage.h
//  yydr
//
//  Created by Li yi on 13-6-8.
//
//

#import <UIKit/UIKit.h>
#import "appointment_member_list.h"


#import "appointment_chat_list.h"
#import "setting.h"
#import "member.h"

#import "place_list.h"
#import "place_add.h"


#import "title.h"
#import "city_list.h"

#import "UIView+iButtonManager.h"
#import "AppDelegate.h"

@interface homepage : UITabBarController<UITabBarControllerDelegate,chatDelegate,CityDelegate,CitySelectedDelegate,UISearchBarDelegate>
{
    UIBarButtonItem *place_add_button,*place_reload_button,*setting_button;
    place_list *p0;
    appointment_member_list *p1;
    appointment_chat_list *p2;
    member *p3;
    AppDelegate *ad;
    title *titleView;
}
@end
