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

#import "global.h"
#import "UIView+GetRequestCookie.h"


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
        [HUD show:YES];

    }
    return self;
}


-(void)loadAblum
{
    UserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];
    
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
    return (count/4)+(count%4==0?0:1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"place_detail_cell_0"];
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSUInteger row =[indexPath row];
    
    [self createButton:cell.contentView position:CGPointMake(4, 4) num:row*4];
    [self createButton:cell.contentView position:CGPointMake(4*2+75, 4) num:row*4+1];
    [self createButton:cell.contentView position:CGPointMake(4*3+75*2, 4) num:row*4+2];
    [self createButton:cell.contentView position:CGPointMake(4*4+75*3, 4) num:row*4+3];
    
    return cell;
}

-(void)createButton:(UIView*)uv position:(CGPoint)p num:(int)n
{
    
    if(n>=[self.UserPhotoList count])
        return;
    
    //上传新照片按钮
    if(n==0)
    {
        [self.view addButton:uv
                       image:@"member_photo_add.png"
                    position:p
                         tag:1000+n
                      target:self
                      action:@selector(onDown:)];
        return;
    }
    
    //===========================================================================
    //载入照片
    NSDictionary *PlaceDetail=[self.UserPhotoList objectAtIndex:n];
    NSString *FileName=[PlaceDetail objectForKey:@"Path"];
    
    UIImageView *photo =[self.view addImageView:uv
                                          image:@"noPhoto_ye.png"
                                       position:p
                                            tag:3000+n];
    
    photo.contentMode = UIViewContentModeScaleAspectFill;
    photo.clipsToBounds = YES;
    
    //id
    UserId=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",UserPhotoURL,UserId,[NSString stringWithFormat:@"thumb_%@",FileName]]];
    
    [photo setImageWithURL:url
          placeholderImage:[UIImage imageNamed:@"noPhoto_ye.png"]];
    
    [self.view addTapEvent:photo
                    target:self
                    action:@selector(onTap:)];
    
}

-(void)onTap:(UIGestureRecognizer*)sender
{
    NSLog(@"%d",sender.view.tag);  
  
    if (status==1) {
        
        photo_row=sender.view.tag-3000;
        
        //编辑状态
        UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"删除"
                                               otherButtonTitles:nil];
        menu.tag=6100;
        [menu showInView:self.view];
        
    }
    else
    {
        //查看大照片
        self_ablum *pp=[[self_ablum alloc] init];
        [pp loadUserPhotoList:UserPhotoList PageIndex:sender.view.tag-3000];
        [self.navigationController pushViewController:pp animated:YES];
    }
}



-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


//上传照片
-(void)onDown:(UIButton*)sender
{
    switch (sender.tag) {
        case 1000:
        {
            UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                  otherButtonTitles:@"拍照上传",@"从相册上传",nil];
             menu.tag=6101; 
            [menu showInView:self.view];
        }
            break;
    }
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
    else if(actionSheet.tag==6100)
    {
        //删除照片
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"删除照片");
                
                HUD.labelText = @"正在删除，请稍等...";
                [HUD show:YES];
                
                NSDictionary *Detail=[self.UserPhotoList objectAtIndex:photo_row];
                
                //photo id
                int pid=[[Detail objectForKey:@"Id"] integerValue];
                
                //删除
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@userphoto/%d",ServerURL,pid]];
                
                NSLog(@"%@",url);
                
                [deleteRequest clearDelegatesAndCancel];
                deleteRequest=nil;
                deleteRequest = [ASIFormDataRequest requestWithURL:url];
                deleteRequest.tag=1011;
                deleteRequest.timeOutSeconds=TIMEOUT;
                [deleteRequest setDelegate:self];
                
                NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
                
                if(ck!=nil)
                {
                    [deleteRequest setUseCookiePersistence:NO];
                    [deleteRequest setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
                }
                
                [deleteRequest setRequestMethod:@"DELETE"];
                [deleteRequest startAsynchronous];
                
            }
                break;
        }
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view    
    //编辑.

    rbt=[[UIBarButtonItem alloc]initWithTitle:@"编辑"
                                        style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(onRDown:)];
    
    self.navigationItem.rightBarButtonItem=rbt;
    
}

-(void)viewDidUnload
{
    [self.request clearDelegatesAndCancel];
    self.request=nil;
    self.UserPhotoList=nil;
}


-(void)onRDown:(UIButton*)sender
{
    if(status==0)
    {
        rbt.title=@"完成";
        rbt.tintColor=[UIColor colorWithRed:1 green:191.f/255 blue:0 alpha:1];
        status=1;
        
        self.title=@"编辑";
        [self.navigationItem setHidesBackButton:YES];
    }
    else
    {
        rbt.title=@"编辑";
        rbt.tintColor=[UIColor blackColor];
        status=0;
        self.title=@"私人相册";

        [self.navigationItem setHidesBackButton:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
