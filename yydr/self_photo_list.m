//
//  member_photo_list.m
//  yydr
//
//  Created by liyi on 13-4-21.
//
//

#import "self_photo_list.h"

#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"
#import "UIView+GetRequestCookie.h"

#import "global.h"

#import "self_photo_list_cell.h"



@interface self_photo_list ()

@end

@implementation self_photo_list
@synthesize request;
@synthesize UserPhotoList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        tb=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-44)];
        tb.delegate=self;
        tb.dataSource=self;
        tb.separatorStyle = NO;
        tb.backgroundView = [self.view addImageView:nil
                                              image:@"place_tel_bbg.png"
                                           position:CGPointMake(0, 0)];
        [self.view addSubview:tb];
        
        
        self.UserPhotoList=[NSMutableArray array];
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.labelText = @"正在加载，请稍等...";
       
        
    }
    return self;
}


-(void)setUid:(int)uid
{
    UserId = uid;
    SelfId=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];
    
    
    if(SelfId==UserId)
    {
        UIBarButtonItem *rbt=[self.view add_upload_button:@selector(onRDown:)
                                                   target:self];
        self.navigationItem.rightBarButtonItem=rbt;
        
        self.title=@"我的相册";
    }
    else
    {
        self.title=@"私人相册";
        
        
        
    }
    
    
    [self loadAblum];
}


-(void)loadAblum
{
    [HUD show:YES];
    
    
    NSString *sUrl=[NSString stringWithFormat:@"%@userphoto?uid=%d",ServerURL,UserId];
    NSURL *url = [NSURL URLWithString:sUrl];
    NSLog(@"%@",url);
    [self.request clearDelegatesAndCancel];
    self.request=nil;
    self.request = [ASIFormDataRequest requestWithURL:url];
    self.request.tag=1010;
    self.request.timeOutSeconds=TIMEOUT;
    [self.request setDelegate:self];
    
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    
    if(ck!=nil)
    {
        [self.request setUseCookiePersistence:NO];
        [self.request setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    }
    
    
    [self.request setRequestMethod:@"GET"];
    [self.request startAsynchronous];
    
}


-(void)UploadFinished
{
    [self loadAblum];
}

-(void)DeleteFinished
{
    [self loadAblum];
}




#pragma mark –
#pragma mark 请求完成 requestFinished
- (void)requestFailed:(ASIHTTPRequest *)r
{
    NSError *error = [r error];
    
    NSLog(@"member_photo_list:%@",error);
}

- (void)requestFinished:(ASIHTTPRequest *)r
{
    [HUD hide:YES];
    
    switch (r.tag) {
        case 1010:
        {
            
            NSData *jsonData = [r responseData];
            
            NSError *error = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
            
            NSArray *items=(NSArray*)jsonObject;
            
            NSLog(@"%@",items);
            
            //相册数量限制 暂定100张
            if ([items count]<100){
                [self.UserPhotoList addObject:@"add"];
            }
            
            self.UserPhotoList=nil;
            self.UserPhotoList=[NSMutableArray array];
            
            [self.UserPhotoList addObjectsFromArray:items];
            
           
            items=nil;
            
        }
            break;
            
        case 1011:
        {
            [self.UserPhotoList removeObjectAtIndex:photo_row];
        }
            break;
    }
    
    [tb reloadData];
    r=nil;
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=[self.UserPhotoList count];
    return (count/3)+(count%3==0?0:1);

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self_photo_list_cell *cell;
    
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell==nil)
    {
        cell = [[self_photo_list_cell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"place_detail_cell_0"];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    int row =indexPath.row;
    int sNum=row*3;
    
    NSMutableArray *photoGroup=[NSMutableArray array];
    
    
    for(int i=sNum;i<sNum+3;i++)
    {
        if(i>=[self.UserPhotoList count])
                break;
        
        [photoGroup addObject:[self.UserPhotoList objectAtIndex:i]];
        
    }
    
    [cell loadPhoto:photoGroup StartTag:sNum];
    [cell setNeedsDisplay];

    return cell;
}



-(void)onTap:(UIButton*)sender
{
    NSLog(@"相册点击 %d",sender.tag);

    if(SelfId==UserId)
    {
        self_photo *mm=[[self_photo alloc] init];
        mm.deleteDelegate=self;
        [mm loadUserPhoto:[self.UserPhotoList objectAtIndex:sender.tag-1000]];
        [self.navigationController pushViewController:mm
                                             animated:YES];
    }
    else
    {
        //查看别人的相册
        member_ablum *mm=[[member_ablum alloc] init];
        [mm loadUserPhotoList:UserPhotoList PageIndex:sender.tag-1000];
        [self.navigationController pushViewController:mm
                                             animated:YES];
    }
    
}


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}


#pragma mark –
#pragma mark 上传照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        self_photo_preview *ppp=[[self_photo_preview alloc] init];
        ppp.uploadDelegate=self;
        ppp.title=@"预览";
        [picker pushViewController:ppp animated:YES];
        [ppp loadImage:originalImage];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex=%d",buttonIndex);
    
    if(actionSheet.tag==6101)
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
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.request clearDelegatesAndCancel];
    self.request=nil;
}

-(void)dealloc
{
    self.UserPhotoList=nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onLDown:)
                                                              target:self];
}

-(void)onLDown:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)onRDown:(UIButton*)sender
{
    //上传照片
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"拍照上传",@"从相册上传",nil];
    menu.tag=6101;
    [menu showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
