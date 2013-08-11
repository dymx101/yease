//
//  member_list.m
//  yydr
//
//  Created by 毅 李 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "girl_list.h"
#import "girl_details.h"
#import "UIView+iImageManager.h"

@interface girl_list ()

@end

@implementation girl_list

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        nameList=[NSMutableArray new];
        [nameList addObject:@"1"];
        [nameList addObject:@"2"];
        [nameList addObject:@"3"];
        [nameList addObject:@"4"];
        [nameList addObject:@"5"];
        [nameList addObject:@"6"];
        [nameList addObject:@"7"];
        [nameList addObject:@"8"];
        [nameList addObject:@"9"];
        [nameList addObject:@"10"];
        [nameList addObject:@"11"];
        [nameList addObject:@"12"];
        [nameList addObject:@"13"];
        [nameList addObject:@"14"];
        [nameList addObject:@"15"];
        [nameList addObject:@"16"];
        [nameList addObject:@"17"];
        [nameList addObject:@"18"];
        [nameList addObject:@"19"];
        [nameList addObject:@"20"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *lbt=[[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(onLDown:)];
    self.navigationItem.leftBarButtonItem=lbt;
    
}


-(void)onLDown:(id*)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [nameList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"member_list_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    NSLog(@"%d",indexPath.row);
    
    // Configure the cell...
    if (cell == nil) 
    {  
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]; 
        
        [self.view addImageView:cell.contentView
                          image:@"temp.jpg"
                       position:CGPointMake(10, 10)
                            tag:200];
        
        //名字
        UILabel *nickname=[[UILabel alloc] initWithFrame:CGRectMake(100, 10, 50, 25)];
        nickname.font= [UIFont systemFontOfSize:20];
        nickname.tag=201;
        [cell.contentView addSubview:nickname];
        
        //爱心
        [self.view addImageView:cell.contentView
                          image:@"xin.png"
                       position:CGPointMake(100, 45)
                            tag:202];
        
        
        
        //消费
        UILabel *price=[[UILabel alloc] initWithFrame:CGRectMake(180, 40, 150, 20)];
        price.font= [UIFont systemFontOfSize:14];
        price.text=@"约会花费:¥400";
        price.tag=203;
        [cell.contentView addSubview:price];
        
        
        
        
        //年龄-------------------------------------
        [self.view addImageView:cell.contentView
                          image:@"girl.png"
                       position:CGPointMake(100,75)];
        
        UILabel *age=[[UILabel alloc] initWithFrame:CGRectMake(110, 69, 200, 25)];
        age.font= [UIFont systemFontOfSize:12];
        age.text=@"22";
        age.tag=205;
        [cell.contentView addSubview:age];
        
        
        
        //三围
        [self.view addImageView:cell.contentView
                          image:@"tu.png"
                       position:CGPointMake(135,75)
                            tag:206];
        
        
        UILabel *chest=[[UILabel alloc] initWithFrame:CGRectMake(148, 69, 200, 25)];
        chest.font= [UIFont systemFontOfSize:12];
        chest.text=@"36D";
        chest.tag=207;
        [cell.contentView addSubview:chest];
        
        //身高
        [self.view addImageView:cell.contentView
                          image:@"height.png"
                       position:CGPointMake(180,75)];
        
        
        UILabel *height=[[UILabel alloc] initWithFrame:CGRectMake(188, 69, 200, 25)];
        height.font= [UIFont systemFontOfSize:12];
        height.text=@"170";
        [cell.contentView addSubview:height];
    }
    
    
    
    
    UILabel *l1 = (UILabel *)[cell.contentView viewWithTag: 201];                              
    l1.text = [nameList objectAtIndex:indexPath.row]; 
    
    return cell;
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
    
    
    girl_details *mm = [[girl_details alloc] initWithStyle:UITableViewStyleGrouped];
    mm.title=@"我的资料";
    [self.navigationController pushViewController:mm animated:YES];
    
    
}

@end
