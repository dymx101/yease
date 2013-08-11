//
//  title.h
//  yydr
//
//  Created by Li yi on 13-6-20.
//
//

#import <UIKit/UIKit.h>

@protocol CityDelegate;

@interface title : UIView
{
    
    id<CityDelegate> cityDelegate;

    UILabel *titleText;
    UILabel *cityText;
    NSInteger *cityId;
    UIImageView *arrow;
}
@property (nonatomic,strong) id<CityDelegate> cityDelegate;

@property (nonatomic,strong) UILabel *titleText;
@property (nonatomic,strong) UILabel *cityText;
@property (nonatomic) NSInteger *cityId;
-(void)showPlace;
-(void)showOther;
@end

@protocol CityDelegate <NSObject>

@optional
-(void)onCityDown;

@end