//
//  place_detail_cell0.h
//  yydr
//
//  Created by Li yi on 13-6-9.
//
//

#import <UIKit/UIKit.h>

@interface place_detail_cell0 : UITableViewCell
{
    
    UIImageView *photo;
    UIImageView *star;
    UILabel *placename,*commentcount;
}

-(void)loadPhoto:(int)h;

@property (nonatomic,strong) UIImageView *photo;
@property (nonatomic,strong) UIImageView *star;
@property (nonatomic,strong) UILabel *placename;
@property (nonatomic,strong) UILabel *commentcount;

@end
