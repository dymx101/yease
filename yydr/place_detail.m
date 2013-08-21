//
//  place_detail_test.m
//  yydr
//
//  Created by Li yi on 13-6-28.
//
//

#import "place_detail.h"
#import "member_info.h"
#import "place_manager_add.h"

@interface place_detail ()

@end

@implementation place_detail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
       
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        photoHeight=200;
        PageIndex=1;
        
        commentList = nil;
        commentList = [NSMutableArray array];
        
        commentHightList=nil;
        commentHightList=[NSMutableArray array];
    
    }
    return self;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [placeCommentRequest clearDelegatesAndCancel];
    placeCommentRequest=nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.backgroundView = [self.view addImageView:nil
                                                      image:@"place_tel_bbg.png"
                                                   position:CGPointMake(0, 0)];
    
    self.title=@"详情";
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onBack:)
                                                              target:self];
}

-(void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark –
#pragma mark 加载数据
- (void)load:(NSDictionary*)dic
{
    PlaceId= [[dic objectForKey:@"Id"] intValue];
    
    //场所详细信息
    pd=dic;
    
    NSLog(@"%@",pd);
    
    //照片
    FileName=[pd objectForKey:@"Path"];
    manager_count=[[pd objectForKey:@"ManagerCount"] intValue];
    
    [self loadPlaceCommentList:PlaceId
                    page_index:PageIndex
                           tag:1010];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 请求回调
- (void)requestFailed:(ASIHTTPRequest *)r
{
    NSError *error = [r error];
    
    NSLog(@"place_detail_requestFailed:%@",error);
    
    //跳出提示
    MBProgressHUD *AlertHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:AlertHUD];
    AlertHUD.labelText = ConnectionFailure;
    AlertHUD.mode = MBProgressHUDModeCustomView;
    AlertHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert"]];
    [AlertHUD show:YES];
    [AlertHUD hide:YES afterDelay:1.5];
    
    switch (r.tag) {
        case 1010:
        {
            //刷新
            [self refreshCompleted];
        }
            break;
        case 1011:
        {
            //加载更多
            [self loadMoreCompleted];
        }
            break;
    }
    r=nil;
}


- (void)requestFinished:(ASIHTTPRequest *)r

{
    NSData *jsonData = [r responseData];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSArray *items=(NSArray*)jsonObject;
    
    switch (r.tag) {
        case 1010:
        {
            //刷新
            [self addItemsOnTop:items];
        }
            break;
        case 1011:
        {
            //加载更多
            [self addItemsOnBottom:items];
        }
            break;
    }
    
    r=nil;
    items=nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
//
// 刷新列表
//
- (BOOL) refresh
{
    if (![super refresh])
        return NO;
    
    [self loadPlaceCommentList:PlaceId
                    page_index:PageIndex
                           tag:1010];
    
    return YES;
}


/////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Load More

////////////////////////////////////////////////////////////////////////////////////////////////////
// 加载更多
- (BOOL) loadMore
{
    if (![super loadMore])
        return NO;
    
    NSLog(@"加载更多");
    
    [self loadPlaceCommentList:PlaceId
                    page_index:PageIndex
                           tag:1011];
    return YES;
}


#pragma mark 添加更多 addItemsOnBottom
- (void)loadPlaceCommentList:(int)pid page_index:(int)index tag:(int)t
{
    PageIndex=index;
    self.canLoadMore=NO;
    PlaceId=pid;
    
    //请求
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@PlaceCommentList?page=%d&pid=%d",ServerURL,PageIndex,PlaceId]];
    
    NSLog(@"%@",url);
    
    placeCommentRequest = [ASIFormDataRequest requestWithURL:url];
    [placeCommentRequest setDelegate:self];
    [placeCommentRequest setRequestMethod:@"GET"];
    placeCommentRequest.tag=t;
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    if(ck!=nil)
    {
        [placeCommentRequest setUseCookiePersistence:NO];
        [placeCommentRequest setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    }
    
    [placeCommentRequest startAsynchronous];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Dummy data methods

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addItemsOnTop:(NSArray*)items
{
    
    //刷新
    commentList = nil;
    commentList = [NSMutableArray array];
    
    commentHightList = nil;
    commentHightList = [NSMutableArray array];
    
    
    if ([items count]!=0){
        [commentList addObjectsFromArray:items];
        
        
        if(PageIndex==1)
        {
            //第一次的时候才刷新
            comment_count=[[pd objectForKey:@"CommentCount"] intValue];
            star_count=[[pd objectForKey:@"Star"] intValue];
        }
        
        //计算每行高度
        for (int i=0; i<[items count]; i++) {
            NSDictionary *c=[items objectAtIndex:i];
            NSString *txt=[c objectForKey:@"Comment"];
            CGSize titleSize = [txt sizeWithFont:[UIFont systemFontOfSize:15.f]
                               constrainedToSize:CGSizeMake(300, MAXFLOAT)
                                   lineBreakMode:UILineBreakModeWordWrap];
            
            [commentHightList addObject:[NSNumber numberWithFloat:(titleSize.height+90.f)]];
        }  
    }
    
    NSLog(@"%d",[items count]);
    
    if ([items count]>=10)
    {
        //返回有10条，可以继续加载
        self.canLoadMore = YES;
        PageIndex+=1;
        [self setFooterViewVisibility:YES];
    }
    else
    {
        [self setFooterViewVisibility:NO];
    }
    
    [self.tableView reloadData];
    
    // Call this to indicate that we have finished "refreshing".
    // This will then result in the headerView being unpinned (-unpinHeaderView will be called).
    [self refreshCompleted];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addItemsOnBottom:(NSArray*)items
{
    
    if ([items count]!=0){
        [commentList addObjectsFromArray:items];
        
        
        
        if(PageIndex==1)
        {
            
            NSDictionary *temp=[items objectAtIndex:0];
            comment_count=[[temp objectForKey:@"CommentCount"] intValue];
            star_count=[[temp objectForKey:@"GoodCount"] intValue];
        }
        
        
        
        //计算每行高度
        for (int i=0; i<[items count]; i++) {
            NSDictionary *c=[items objectAtIndex:i];
            NSString *txt=[c objectForKey:@"Comment"];
            CGSize titleSize = [txt sizeWithFont:[UIFont systemFontOfSize:15.f]
                               constrainedToSize:CGSizeMake(300, MAXFLOAT)
                                   lineBreakMode:UILineBreakModeWordWrap];
            
            [commentHightList addObject:[NSNumber numberWithFloat:(titleSize.height+90.f)]];
        }
    }
    
    if ([items count]>=10)
    {
        //返回有10条，可以继续加载
        self.canLoadMore = YES;
        PageIndex+=1;
    }
    
    [self.tableView reloadData];
    
    // Inform STableViewController that we have finished loading more items
    [self loadMoreCompleted];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Standard TableView delegates

////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 6;
    }

    return  [commentList count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //照片、评分
                    if( !FileName || [FileName isKindOfClass:[NSNull class]] )
                    {
                        return 80;
                    }
                    else
                    {
                        return 80+photoHeight;
                    }
                    
                }
                    break;
                    
                case 1:
                case 2:
                {
                    //地址
                    return 45;
                }
                    break;
                case 3:
                {
                    //预约
                    return 55;
                }
                    break;
                case 4:
                {
                    //优惠
                    return 90;
                }
                    break;
                case 5:
                {
                    //评论
                    return 60;
                }
                    break;
            }
        }
            break;
            
            
        case 1:
        {
            float h=[[commentHightList objectAtIndex:indexPath.row] floatValue];
            return h;
        }
            break;
            
    }
    
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0://照片、星星
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"place_detail_cell_0"];
                    
                    if(cell==nil)
                    {
                        cell = [[place_detail_cell0 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"place_detail_cell_0"];
                        
                        if( FileName && ![FileName isKindOfClass:[NSNull class]] )
                        {
                            //有照片
                            [(place_detail_cell0*)cell loadPhoto:photoHeight];
                            UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                              action:@selector(onPicDown:)];
                            [((place_detail_cell0*)cell).photo addGestureRecognizer:singleFingerTap];

                        }
                        else
                        {
                            [(place_detail_cell0*)cell loadPhoto:0];
                        }
                    }
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                                      
                    
                    if( FileName && ![FileName isKindOfClass:[NSNull class]] )
                    {
                        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",PlacePhotoURL,PlaceId,[NSString stringWithFormat:@"thumb_%@",FileName]]];
                        
                        [((place_detail_cell0*)cell).photo setImageWithURL:url];
                    }

                    ((place_detail_cell0*)cell).placename.text=[pd objectForKey:@"Name"];
                   
                    //星星数量
                    ((place_detail_cell0*)cell).star.image=[UIImage imageNamed:[NSString stringWithFormat:@"star_%d.png",star_count]];

                    
                    ((place_detail_cell0*)cell).commentcount.text=[NSString stringWithFormat:@"%d人体验",comment_count];

                }
                    break;
                    
                case 1://人均
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"place_detail_cell_5"];
                    
                    int price=[[pd objectForKey:@"Price"] intValue];
                    
                    if(cell==nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"place_detail_cell_5"];
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        
                        
                        UIImageView *im=[self.view addImageView:cell.contentView
                                                          image:@"place_row_top.png"
                                                       position:CGPointMake(0, 0)];
                        
                        im.center=CGPointMake(160, im.center.y);
                        
                        UILabel *t= [self.view addLabel:im
                                                  frame:CGRectMake(40, 12, 250, 30)
                                                   font:[UIFont systemFontOfSize:14]
                                                   text:@""
                                                  color:[UIColor blackColor]
                                                    tag:3000];
                        
                        t.center=CGPointMake(t.center.x, im.center.y);
                        
                        [self.view addImageViewWithCenter:im
                                                    image:@"price_icon.png"
                                                 position:CGPointMake(25, im.center.y)];
                        
                    }
                    
                    UILabel *l=(UILabel*)[cell viewWithTag:3000];
                    
                    if(price>0)
                    {
                        l.text=[NSString stringWithFormat:@"人均：%d",price];
                    }
                    else
                    {
                        l.text=@"人均：暂无";
                    }
                }
                    break;
                    
                case 3: //地址
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"place_detail_cell_6"];
                    
                    if(cell==nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"place_detail_cell_6"];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UIButton *im=[self.view addButton:cell.contentView
                                                    image:@"place_row_bottom.png"
                                                 position:CGPointMake(0, 0)
                                                      tag:1001
                                                   target:self
                                                   action:@selector(onDown:)];
                        
                        im.center=CGPointMake(160, im.center.y);
                        
                        UILabel *t=[self.view addLabel:im
                                                 frame:CGRectMake(40, 12, 230, 30)
                                                  font:[UIFont systemFontOfSize:14]
                                                  text:@""
                                                 color:[UIColor blackColor]
                                                   tag:3002];
                        
                        t.center=CGPointMake(t.center.x, im.center.y);
                        
                        
                        [self.view addImageViewWithCenter:im
                                                    image:@"address_icon.png"
                                                 position:CGPointMake(25, im.center.y)];
                        
                        [self.view addImageViewWithCenter:cell.contentView
                                                    image:@"place_arrow.png"
                                                 position:CGPointMake(290, im.center.y)];
                    }
                    
                    
                    NSString *ad2=[pd objectForKey:@"Address2"];
                    
                    UILabel *l=(UILabel*)[cell viewWithTag:3002];
                    l.text=[NSString stringWithFormat:@"地址：%@%@",[pd objectForKey:@"Address"],[ad2 isEqual:[NSNull null]]?@"":ad2];
                }
                    break;
                    
                case 2://预约定位
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"place_detail_cell_2"];
                    
                    if(cell==nil)
                    {
                        cell = [[place_detail_tel_cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"place_detail_cell_2"];
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                    
                    
                    int tel=[[pd objectForKey:@"Phone"] integerValue];
                    
                    ((place_detail_tel_cell*)cell).tel.text=tel>0?[NSString stringWithFormat:@"电话：%d",tel]:@"电话：暂无";
                    
                }
                    break;
                    
                case 4://优惠
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"place_detail_cell_7"];
                    if(cell==nil)
                    {
                        cell = [[place_detail_manager_cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"place_detail_cell_7"];
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                    
                    if (manager_count>0)
                    {
                         UILabel *off=((place_detail_manager_cell*)cell).off;
                         off.text=[pd objectForKey:@"ManagerOff"];
                    }
                    else
                    {
                        UILabel *off=((place_detail_manager_cell*)cell).off;
                        
                        off.textColor=[UIColor grayColor];
                        off.text=@"经理加入";
                    }
                    
                }
                    break;
                    
                case 5://评论
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"place_detail_cell_7"];
                    
                    if(cell==nil)
                    {
                        cell = [[place_detail_comment_cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"place_detail_cell_7"];
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }

                    ((place_detail_comment_cell*)cell).commentcount.text=[NSString stringWithFormat:@"体验记（%d条）",comment_count];

          
                }
                    break;
            }
        }
            break;
            
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"comment_list_cell"];
            
            if (cell == nil)
            {
                cell = [[place_comment_list_cell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:@"comment_list_cell"];
            }
            
            NSDictionary *cd=[commentList objectAtIndex:indexPath.row];
            
            [(place_comment_list_cell*)cell loadCommentDetail:cd
                                                       Height:[[commentHightList objectAtIndex:indexPath.row] integerValue]];
        }
            break;
    }
    
    
    
    return cell;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 表格点击事件
-(void)onDown:(UIButton*)sender
{
    NSLog(@"%d",sender.tag);
    
    
    switch (sender.tag) {
            //预约电话
        case 1000:
        {
            //座机
            /*
             int tel=[[pd objectForKey:@"Phone"] integerValue];
             
             place_manager_list *mm = [[place_manager_list alloc] init];
             [mm FirstLoad:PlaceId Tel:tel];
             mm.title=@"预约订位";
             [self.navigationController pushViewController:mm animated:YES];
             */
        }
            break;
            
        case 1001:
        {
            //地图
            map *mm = [[map alloc] init];
            mm.title=@"地图";
            
            
            NSString *ad2=[pd objectForKey:@"Address2"];
            
            [mm setLat:[[pd objectForKey:@"Glat"] doubleValue]
                   Lon:[[pd objectForKey:@"Glng"] doubleValue]
                 Title:[pd objectForKey:@"Name"]
               Address:[NSString stringWithFormat:@"%@%@",[pd objectForKey:@"Address"],[ad2 isEqual:[NSNull null]]?@"":ad2]];
            
            
            [self.navigationController pushViewController:mm animated:YES];
            
        }
            break;
            
        case 1002:
        {
            
            //经理
            
            
            id ManagerInfo=[pd objectForKey:@"Manager"];
            
            
            if(!ManagerInfo||[ManagerInfo isKindOfClass:[NSNull class]])
            {
                place_manager_add *mm = [[place_manager_add alloc] initWithStyle:UITableViewStyleGrouped];
                [mm setPlaceId:PlaceId];
                mm.title=@"经理加入";
                [self.navigationController pushViewController:mm animated:YES];
            }
            else
            {
                member_info *mm=[[member_info alloc] init];
                [mm loadInfo:ManagerInfo];
                [self.navigationController pushViewController:mm animated:YES];
            }
            
            
        }
            break;
            
            
            //发布评论
        case 2000:
        {
            place_comment_add *mm = [[place_comment_add alloc] initWithStyle:UITableViewStyleGrouped];
            mm.delegate=self;
            [mm setPlaceId:PlaceId];
            mm.title=@"体验分享";
            [self.navigationController pushViewController:mm animated:YES];
        }
            break;
            
            
            //上传照片
        case 2001:
        {
            UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照上传",@"从相册上传",nil];
            [menu showInView:self.view];
        }
            break;
            
            //错误
        case 2002:
        {
            /*
            place_debug *mm = [[place_debug alloc] init];
            mm.title=@"哪些信息错误？";
            [self.navigationController pushViewController:mm animated:YES];
            */
        }
            break;
    }
}

-(void)onPicDown:(id)sender
{
    NSLog(@"去相册");
    
    place_ablum *mm=[[place_ablum alloc] init];
    [mm setPlaceId:PlaceId];
    [self.navigationController pushViewController:mm animated:YES];
}

-(void)CommentAddFinished
{
    comment_count=comment_count+1;
    [self refresh];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark 上传照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        place_photo_preview *ppp=[[place_photo_preview alloc] init];
        ppp.title=@"预览";
        [picker pushViewController:ppp animated:YES];
        [ppp loadImage:originalImage pid:PlaceId];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
        {
            //拍照
            UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
            imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePickController.delegate=self;
            imagePickController.allowsEditing=NO;
            imagePickController.showsCameraControls=YES;
            [self presentModalViewController:imagePickController animated:YES];
        }
            break;
            
        case 1:
        {
            //从相册
            UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
            imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickController.delegate=self;
            [self presentModalViewController:imagePickController animated:YES];
        }
            break;
    }
    
}

@end
