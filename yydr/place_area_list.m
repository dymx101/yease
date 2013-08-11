//
//  place_area_list.m
//  yydr
//
//  Created by liyi on 13-2-18.
//
//

#import "place_area_list.h"
#import "global.h"

@implementation place_area_list

@synthesize request;
@synthesize areaDelegate;

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


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [areaList count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *a=[areaList objectAtIndex:row];
    return [a objectForKey:@"Text"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"%@",[areaList objectAtIndex:row]);
    
    NSLog(@"Selected 哪个区: %@. 值: %@", [[areaList objectAtIndex:row] objectForKey:@"Text"],
          [[areaList objectAtIndex:row] objectForKey:@"Value"]);
}



-(void)loadAreaWithAll:(BOOL)a Selected:(int)n
{
    currentSelectRow=n;
    allarea=a;

    int cid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CityId"] integerValue];

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSDictionary *cityList = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    
    for (int i=0;i<[cityList count];i++)
    {
        
        NSDictionary *city=[cityList objectForKey:[NSString stringWithFormat:@"item%d",i]];
        
        

        int _cid= [[city objectForKey:@"id"] integerValue];
       
        if(cid==_cid)
        {
            [self showActionSheet:[city objectForKey:@"areaList"]];
        }
        
    }
    
    
   // NSLog(@"区域%@",[cityList objectForKey:[NSString stringWithFormat:@"item%d",cid]] );
    
    
    //有区域缓存，直接显示
   // [self showActionSheet:areaArray];

}


-(void)dealloc
{
    [self.request clearDelegatesAndCancel];
    self.request=nil;
}


#pragma mark –
#pragma mark 选择区域表
- (void)showActionSheet:(NSDictionary*)ar
{
    //NSLog(@"showActionSheet:%@ %d",ar,[ar count]);
    
    areaList=nil;
    areaList = [NSMutableArray array];
    
    
    if(allarea)
    {
        NSDictionary *first = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"全部区域",@"Text",
                               @"0",@"Value", //名称/值
                               nil];
        [areaList addObject:first];
    }

    for (int i=0; i<[ar count]; i++) {
        
        NSDictionary *_area=[ar objectForKey:[NSString stringWithFormat:@"item%d",i]];
        
        NSDictionary *_item = [NSDictionary dictionaryWithObjectsAndKeys:
                               [_area objectForKey:@"area"],@"Text",
                               [_area objectForKey:@"id"],@"Value", //名称/值
                               nil];
        [areaList addObject:_item];
        
    }    
    
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    
    pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView selectRow:currentSelectRow  inComponent:0 animated:NO];
    [self addSubview:pickerView];
    
}


#pragma mark –
#pragma mark 选中区域后的事件
- (void)dismissActionSheet:(id)sender
{
    currentSelectRow=[pickerView selectedRowInComponent:0];
    int area_id = [[[areaList objectAtIndex:currentSelectRow] objectForKey:@"Value"] integerValue];
    NSString *area_text=[[areaList objectAtIndex:currentSelectRow] objectForKey:@"Text"];

    [areaDelegate AreaSelected:area_text Area_id:area_id SelectRow:currentSelectRow];
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end
