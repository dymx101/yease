//
//  place_list_cell.h
//  yydr
//
//  Created by liyi on 13-1-2.
//
//

#import <UIKit/UIKit.h>
#import "UIView+iImageManager.h"
#import "UIView+iTextManager.h"
#import <UIImageView+WebCache.h>

@interface place_list_cell : UITableViewCell
{
    UIImageView *photo;
    UIImageView *star;
    UIImageView *loc;
    UILabel *placeName;
    UILabel *placePrice;
    UILabel *placeAddress;
    UILabel *distance;
    UIImageView *ke;
    UIImageView *placelevel;

}

@property (nonatomic,strong) UILabel *placeName;
@property (nonatomic,strong) UILabel *placeAddress;
@property (nonatomic,strong) UILabel *placePrice;
@property (nonatomic,strong) UILabel *distance;
@property (nonatomic,strong) UIImageView *photo;
@property (nonatomic,strong) UIImageView *loc;
@property (nonatomic,strong) UIImageView *ke;
@property (nonatomic,strong) UIImageView *placelevel;

-(void)loadPlaceDetail:(NSDictionary*)pd;

@end
