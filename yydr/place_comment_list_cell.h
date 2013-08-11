//
//  place_comment_list_cell.h
//  yydr
//
//  Created by liyi on 13-1-4.
//
//

#import <UIKit/UIKit.h>

@interface place_comment_list_cell : UITableViewCell
{
    UILabel *name;
    UILabel *price;
    UILabel *comment;
    UILabel *recommend;
    UILabel *date;
    UIImageView *rating;
    UIImageView *line;
    UIImageView *Avatar;
    
}

@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *price;
@property (nonatomic,strong) UILabel *comment;
@property (nonatomic,strong) UILabel *recommend;
@property (nonatomic,strong) UILabel *date;

@property (nonatomic,strong) UIImageView *Avatar;
@property (nonatomic,strong) UIImageView *rating;

-(void)loadCommentDetail:(NSDictionary*)cd Height:(int)height;

@end
