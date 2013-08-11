//
//  place_category_list.h
//  yydr
//
//  Created by liyi on 13-2-18.
//
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@protocol CategoryDelegate;

@interface place_category_list : UIActionSheet<UIPickerViewDelegate,UIPickerViewDataSource>
{
    id<CategoryDelegate> categoryDelegate;
    
    int currentSelectRow;
    ASIFormDataRequest *request;
    NSMutableArray *categoryList;
    UIPickerView *pickerView;
    BOOL allcategory;
}

@property (nonatomic,strong) id<CategoryDelegate> categoryDelegate;
@property (nonatomic,strong) ASIFormDataRequest *request;

-(void)loadCategoryWithAll:(BOOL)a Selected:(int)n;
@end


@protocol CategoryDelegate <NSObject>

@optional
-(void)CategorySelected:(NSString*)at Category_id:(int)cid SelectRow:(int)csr;

@end