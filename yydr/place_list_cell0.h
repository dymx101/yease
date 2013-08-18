//
//  place_list_cell0.h
//  yydr
//
//  Created by Li yi on 13-6-10.
//
//

#import <UIKit/UIKit.h>


@protocol AdvDelegate;

@interface place_list_cell0 : UITableViewCell<UIScrollViewDelegate>
{
    UIPageControl *pc;
    UIScrollView *sv;
    
    
}
@property (nonatomic,strong) id<AdvDelegate> advDelegate;
-(void)loadPlaceAdv:(NSArray*)pl;
@end

@protocol AdvDelegate <NSObject>

@optional
-(void)AdvSelected:(int)n;

@end