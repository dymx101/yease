//
//  place_comment_list.m
//  yydr
//
//  Created by 毅 李 on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "place_comment_list.h"
#import "place_comment_list_cell.h"
#import "place_comment_list_footview.h"

@interface place_comment_list ()

@end

@implementation place_comment_list

@synthesize HUD;
@synthesize request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        PageIndex=1;
        
        self.view.backgroundColor=[UIColor whiteColor];
        
        commentList = nil;
        commentList = [NSMutableArray array];
        
        commentHightList=nil;
        commentHightList=[NSMutableArray array];
        
        self.tableView.separatorStyle = NO;
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.labelText = @"正在加载，请稍等...";
        [HUD show:YES];
        
    }
    return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h=[[commentHightList objectAtIndex:indexPath.row] floatValue];
    return h;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置表格脚标
    place_comment_list_footview *footView=[[place_comment_list_footview alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.footerView=footView;    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"comment_list_cell";
    place_comment_list_cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[place_comment_list_cell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *cd=[commentList objectAtIndex:indexPath.row];
    
    //名字
    cell.name.text=[cd objectForKey:@"user_name"];
    
    
    //花费
    cell.price.text=[NSString stringWithFormat:@"花费：¥%@",[cd objectForKey:@"price"]];
    

    //推荐
    if([[cd objectForKey:@"recommend"] isEqual:@""])
    {
        cell.recommend.hidden = YES;
    }
    else
    {
        cell.recommend.text=[NSString stringWithFormat:@"推荐：%@",[cd objectForKey:@"recommend"]];
        cell.recommend.hidden = NO;
    }
    
    
    if([[cd objectForKey:@"rating"] boolValue])
    {
        cell.rating.image=[UIImage imageNamed:@"good.png"];
    }
    else
    {
        cell.rating.image=[UIImage imageNamed:@"bad.png"];
    }

    //评论
    cell.comment.frame=CGRectMake(10, 50, 300, 0);
    cell.comment.text=[cd objectForKey:@"comment"];
    [cell.comment sizeToFit];
    
    
    //日期
    float h=[[commentHightList objectAtIndex:indexPath.row] floatValue];
    cell.date.text=[cd objectForKey:@"created_at"];
    cell.date.center=CGPointMake(cell.date.center.x,  h-10);
    

    
    return cell;
}


#pragma mark –
#pragma mark 开始loadMore
- (void) willBeginLoadingMore
{
    NSLog(@"willBeginLoadingMore");
    
    place_comment_list_footview *fv = (place_comment_list_footview *)self.footerView;
    [fv.activityIndicator startAnimating];
    fv.title.hidden=NO;
}


- (BOOL) loadMore
{
    if (![super loadMore])
        return NO;
    
    [self addItemsOnBottom:pid];
    return YES;
}

#pragma mark –
#pragma mark 完成 LoadMore
- (void) loadMoreCompleted
{
    [super loadMoreCompleted];

    [self.HUD hide:YES];
    NSLog(@"loadMoreCompleted");
    
    if (!self.canLoadMore) {
        //place_comment_list_footview *fv = (place_comment_list_footview *)self.footerView;
        //fv.hidden=YES;
        self.footerView=nil;
    }
}

#pragma mark –
#pragma mark 添加更多 addItemsOnBottom
- (void) addItemsOnBottom:(int)place_id
{
    pid=place_id;
    
    //请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/v1/comments.json?page=%d&place_id=%d&auth_token=%@",ServerURL,PageIndex,pid,[[NSUserDefaults standardUserDefaults] objectForKey:@"private_token"]]];
    
    NSLog(@"%@",url);
    
    self.request = [ASIFormDataRequest requestWithURL:url];
    [self.request setDelegate:self];
    [self.request setRequestMethod:@"GET"];
    [self.request startAsynchronous];
    
}

#pragma mark –
#pragma mark 请求完成 requestFinished
- (void)requestFinished:(ASIHTTPRequest *)r
{
    [HUD hide:YES];
    
    // Use when fetching text data
    NSString *responseString = [r responseString];
    
    // Use when fetching binary data
    NSData *jsonData = [r responseData];
    
    NSLog(@"%@",responseString);
    
    
    //解析JSon
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil){
        
        NSLog(@"place_list:Successfully deserialized...");
        
        NSArray *items=(NSArray*)[jsonObject objectForKey:@"result"];
        PageCount=[[jsonObject objectForKey:@"last_page"] integerValue];
        
        if(PageCount>=PageIndex)
        {
           
            [commentList addObjectsFromArray:items];
            
            
            //计算每行高度
            for (int i=0; i<[items count]; i++) {
                NSDictionary *c=[items objectAtIndex:i];
                NSString *txt=[c objectForKey:@"comment"];
                CGSize titleSize = [txt sizeWithFont:[UIFont systemFontOfSize:15.f]
                                   constrainedToSize:CGSizeMake(300, MAXFLOAT)
                                       lineBreakMode:UILineBreakModeWordWrap];
                
                [commentHightList addObject:[NSNumber numberWithFloat:(titleSize.height+90.f)]];
            }
            

            if (PageCount==PageIndex) {
                self.canLoadMore = NO;
            }
            else
            {
                PageIndex+=1;
                self.canLoadMore = YES;
            }

        }
        else
        {
            self.canLoadMore = NO;
        }
    }
    
    [self.tableView reloadData];
    [self loadMoreCompleted];
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
