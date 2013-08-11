//
//  place_area_list.h
//  yydr
//
//  Created by liyi on 13-2-18.
//
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@protocol AreaDelegate;

@interface place_area_list : UIActionSheet<UIPickerViewDelegate,UIPickerViewDataSource>
{
    
    id<AreaDelegate> areaDelegate;
    
    int currentSelectRow;
    ASIHTTPRequest *request;
    NSMutableArray *areaList;
    UIPickerView *pickerView;
    BOOL allarea;
}

@property (nonatomic,strong) id<AreaDelegate> areaDelegate;
@property (nonatomic,strong) ASIHTTPRequest *request;

-(void)loadAreaWithAll:(BOOL)a Selected:(int)n;
@end


@protocol AreaDelegate <NSObject>

@optional
-(void)AreaSelected:(NSString*)at Area_id:(int)aid SelectRow:(int)csr;

@end