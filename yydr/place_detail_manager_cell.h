//
//  place_detail_manager_cell.h
//  yydr
//
//  Created by Li yi on 13-6-9.
//
//

#import <UIKit/UIKit.h>

@interface place_detail_manager_cell : UITableViewCell
{
    UILabel *off;
    
}
@property (nonatomic,strong) UILabel *off;

-(void)loadManager:(int)pid;
@end