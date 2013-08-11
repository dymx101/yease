//
//  girl_chat_list.m
//  yydr
//
//  Created by liyi on 12-12-15.
//
//

#import "appointment_chat_list.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

@interface appointment_chat_list ()

@end

@implementation appointment_chat_list

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        AppDelegate *ad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        ad.chatDelegate=self;
        
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];

    dialogArray=nil;
    dialogArray=[NSMutableArray array];
    
    NSLog(@"查询dialog");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"nldb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return;
    }
    
    
    
    //不需要像Android中那样关闭Cursor关闭FMResultSet，因为相关的数据库关闭时，FMResultSet也会被自动关闭
    FMResultSet *resultSet = [database executeQuery:@"select * from dialog order by lastdate"];
    
    while ([resultSet next]) {
        NSString *username = [resultSet stringForColumn:@"username"];
        NSString *avatar = [resultSet stringForColumn:@"avatar"];
        NSString *body = [resultSet stringForColumn:@"message"];
        int sid = [resultSet intForColumn:@"userid"];
        NSDate *ld=[resultSet dateForColumn:@"lastdate"];
        
        NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:
                             username,@"From",
                             @"",@"LastDate",
                             body,@"Message",
                             [NSString stringWithFormat:@"%d",sid],@"Sid",
                             avatar,@"Avatar",
                             nil];
        [dialogArray addObject:msg];
    }
    
    [database close];
    
    NSLog(@"dialogArray=%@",dialogArray);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
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
}

@end
