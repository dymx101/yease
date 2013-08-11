//
//  place_tel_cell.h
//  yydr
//
//  Created by liyi on 13-2-15.
//
//

#import <UIKit/UIKit.h>

#import "UIView+iImageManager.h"
#import "UIView+iTextManager.h"
#import "UIView+iButtonManager.h"

@interface place_manager_cell : UITableViewCell
{
    UILabel *name;
    UILabel *info;
    UILabel *tel;
    UILabel *off;
    UIButton *dbt;
    
    UIImageView *avatar;
    
    int num;
}
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *info;
@property (nonatomic,strong) UILabel *tel;
@property (nonatomic,strong) UILabel *off;
@property (nonatomic,strong) UIButton *dbt;

@end
