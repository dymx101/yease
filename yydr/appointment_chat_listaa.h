//
//  girl_chat_list.h
//  yydr
//
//  Created by liyi on 12-12-15.
//
//

#import <UIKit/UIKit.h>
#import "chatDelegate.h"
#import "AppDelegate.h"
@interface appointment_chat_list : UITableViewController<chatDelegate>
{
    
    NSMutableArray *dialogArray;
}
@end
