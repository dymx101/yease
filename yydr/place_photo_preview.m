//
//  place_photo_preview.m
//  yydr
//
//  Created by liyi on 13-3-13.
//
//

#import "place_photo_preview.h"
#import "global.h"
#import "UIView+GetRequestCookie.h"
#import "UIView+iButtonManager.h"
#import "login.h"

@interface place_photo_preview ()

@end

@implementation place_photo_preview

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(void)loadImage:(UIImage*)im pid:(int)p
{
    img=im;
    PlaceId=p;
    
    UIImageView *photo=[[UIImageView alloc] initWithImage:img];
    
    photo.frame = CGRectMake(0, 0, 320, 320);
    photo.center = self.view.center;
    photo.contentMode= UIViewContentModeScaleAspectFit;

    [self.view addSubview:photo];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    uploading=NO;

}


-(void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem= [self.view add_back_button:@selector(onBack:)
                                                               target:self];

    self.navigationItem.rightBarButtonItem=[self.view add_ok_button:@selector(onRDown:)
                                                             target:self];
    
}


- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}


-(void)onRDown:(id*)sender
{
    //防止连续上传
    if(uploading==YES)
    {
        return;
    }
    
    uploading=YES;
    
    //判断是否需要缩小
    if(img.size.width>768||img.size.height>1024)
    {
        float width=768/(float)img.size.width;
        float height=1024/(float)img.size.height;
        
        float k=width>height?height:width;
        
        img=[self reSizeImage:img
                       toSize:CGSizeMake(img.size.width*k, img.size.height*k)];
    }
    
    NSData* data = UIImageJPEGRepresentation(img, .5);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@Upload?pid=%d&desc=%@",ServerURL,PlaceId,nil]];
    //NSLog(@"%@",url);
    
    uploadRequest = nil;
    uploadRequest = [ASIFormDataRequest requestWithURL:url];
    uploadRequest.timeOutSeconds=TIMEOUT;
    uploadRequest.delegate=self;
    uploadRequest.uploadProgressDelegate=self;
    uploadRequest.tag=1101;
    uploadRequest.showAccurateProgress=YES;
    [uploadRequest setRequestMethod:@"POST"];
    
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    if(ck!=nil)
    {
        [uploadRequest setUseCookiePersistence:NO];
        [uploadRequest setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    }
    
    //场所id
    [uploadRequest setPostValue:[NSString stringWithFormat:@"%d",PlaceId]
                         forKey:@"PlaceId"];
    
    //场所照片
    [uploadRequest setData:data
              withFileName:@"temp.jpg"
            andContentType:@"image/jpeg"
                    forKey:@"file"];
    
    [uploadRequest startAsynchronous];
    
    //进度条
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"正在上传，请稍等...";
    [HUD show:YES];
    
}

-(void)request:(ASIHTTPRequest*)request incrementUploadSizeBy:(long long)newLength{
    
    //NSLog(@"totalupload:%lld",newLength);
    
}



//请求回调
- (void)requestFailed:(ASIHTTPRequest *)r
{
    [HUD hide:YES];
    
    int statusCode=[r responseStatusCode];
    
    switch (statusCode) {
        case 401:
        {
            [[NSUserDefaults standardUserDefaults] setObject:nil
                                                      forKey:@"Value"];
            
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
            break;
            
        default:
        {
            //网络不好跳出提示
            MBProgressHUD *AlertHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:AlertHUD];
            AlertHUD.labelText = ConnectionFailure;
            AlertHUD.mode = MBProgressHUDModeCustomView;
            AlertHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert"]];
            [AlertHUD show:YES];
            [AlertHUD hide:YES afterDelay:1.5];
        }
            break;
    }
    
    [r clearDelegatesAndCancel];
    uploading=NO;
    r=nil;
}



-(void)viewWillAppear:(BOOL)animated
{
    [uploadRequest clearDelegatesAndCancel];
    uploadRequest = nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



//进度条回调
-(void)setProgress:(float)newProgress{
    
    NSLog(@"====%f",newProgress);
    HUD.progress = newProgress;
}


- (void)requestFinished:(ASIHTTPRequest *)r
{
    NSLog(@"上传完成");
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"上传成功，我们将会尽快审核";
    HUD.delegate=self;
    [HUD hide:YES afterDelay:1.5];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
