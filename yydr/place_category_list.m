//
//  place_category_list.m
//  yydr
//
//  Created by liyi on 13-2-18.
//
//

#import "place_category_list.h"
#import "global.h"

@implementation place_category_list

@synthesize request;
@synthesize categoryDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        [self setActionSheetStyle:UIActionSheetStyleBlackOpaque];
        
        //确定
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确定"]];
        closeButton.momentary = YES;
        closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
        closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
        closeButton.tintColor = [UIColor blackColor];
        [closeButton addTarget:self
                        action:@selector(dismissActionSheet:)
              forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:closeButton];
        [self showInView:[[UIApplication sharedApplication] keyWindow]];
        [self setBounds:CGRectMake(0, 0, 320, 485)];
        
    }
    return self;
}


-(void)loadCategoryWithAll:(BOOL)a Selected:(int)n
{
    currentSelectRow=n;
    allcategory=a;
    
    NSMutableArray *categoryArray=[NSMutableArray array];

    if(allcategory)
    {
        NSDictionary *first = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"全部场所",@"Category",
                               @"0",@"Id", //名称/值
                               nil];
        [categoryArray addObject:first];
    }

    
    
    [categoryArray addObject:[NSDictionary dictionaryWithObjectsAndKeys: @"3", @"Id",@"桑拿会所", @"Category",nil]];
    [categoryArray addObject:[NSDictionary dictionaryWithObjectsAndKeys: @"1", @"Id",@"指压推油", @"Category",nil]];
    [categoryArray addObject:[NSDictionary dictionaryWithObjectsAndKeys: @"5", @"Id",@"夜总会", @"Category",nil]];
    
    
    //有区域缓存，直接显示
    [self showActionSheet:categoryArray];
    
   
}


-(void)dealloc
{
    [self.request clearDelegatesAndCancel];
    self.request=nil;
    NSLog(@"停止");
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [categoryList count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *a=[categoryList objectAtIndex:row];
    return [a objectForKey:@"Text"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}


#pragma mark –
#pragma mark 选择区域表
- (void)showActionSheet:(NSArray*)ar
{
    //NSLog(@"showActionSheet:%@",ar);
    
    categoryList=nil;
    categoryList = [NSMutableArray array];
    
    for (int i=0; i<[ar count]; i++) {
        
        NSDictionary *_area=[ar objectAtIndex:i];
        NSDictionary *_item = [NSDictionary dictionaryWithObjectsAndKeys:
                               [_area objectForKey:@"Category"],@"Text",
                               [_area objectForKey:@"Id"],@"Value", //名称/值
                               nil];
        [categoryList addObject:_item];
        
    }
    
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    
    pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView selectRow:currentSelectRow inComponent:0 animated:YES];
    [self addSubview:pickerView];
}


#pragma mark –
#pragma mark 选中区域后的事件
- (void)dismissActionSheet:(id)sender
{
    currentSelectRow=[pickerView selectedRowInComponent:0];
    int area_id = [[[categoryList objectAtIndex:currentSelectRow] objectForKey:@"Value"] integerValue];
    NSString *area_text=[[categoryList objectAtIndex:currentSelectRow] objectForKey:@"Text"];
    
    [categoryDelegate CategorySelected:area_text Category_id:area_id SelectRow:currentSelectRow];
    [self dismissWithClickedButtonIndex:0 animated:YES];
}



@end
