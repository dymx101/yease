//
//  girl_list_cell.h
//  yydr
//
//  Created by liyi on 13-4-19.
//
//

#import <UIKit/UIKit.h>

@interface appointment_member_list_cell : UITableViewCell
{
    UIImageView *Avatar;
    UILabel *UserName,*Distance,*Signature;
}
@property (nonatomic,strong) UILabel *UserName;
@property (nonatomic,strong) UILabel *Distance;
@property (nonatomic,strong) UILabel *Signature;
@property (nonatomic,strong) UIImageView *Avatar;
@end