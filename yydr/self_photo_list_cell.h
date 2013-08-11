//
//  self_photo_list_cell.h
//  yydr
//
//  Created by liyi on 13-5-23.
//
//

#import <UIKit/UIKit.h>

@interface self_photo_list_cell : UITableViewCell
{
    UIImage *pf;
    NSMutableArray *PhotoGroup;
}
-(void)loadPhoto:(NSMutableArray*)pg StartTag:(int)t;

@end
