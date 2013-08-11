//
//  member_avatar.m
//  yydr
//
//  Created by liyi on 13-5-4.
//
//

#import "member_avatar.h"
#import "global.h"

#import "UIView+iImageManager.h"
#import "UIView+GetRequestCookie.h"
#import <UIImageView+WebCache.h>
#import "UIView+iButtonManager.h"


@interface member_avatar ()

@end

@implementation member_avatar

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        dh=[[dbHelper alloc] init];
        
    }
    return self;
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    return iv;
}


-(void)loadImage:(UIImage*)im
{
    sv=[self.view addScrollView:self.view
                       delegate:self
                          frame:CGRectMake(0, 0, 300, 300)
                        bounces:YES
                           page:NO
                          showH:NO
                          showV:NO];
    sv.clipsToBounds=NO;
    sv.center=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    
    
    iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, im.size.width, im.size.height)];
    iv.image=im;
    [sv addSubview:iv];
    
    
    float width=300/(float)iv.image.size.width;
    float height=300/(float)iv.image.size.height;
    
    float k=width>height?width:height;
    
    CGRect f=iv.frame;
    f.size.width=f.size.width*k;
    f.size.height=f.size.height*k;
    iv.frame=f;
    
    NSLog(@"%f %f",iv.frame.size.width,iv.frame.size.height);
    
    sv.contentSize=iv.frame.size;
    sv.maximumZoomScale=2;
    sv.minimumZoomScale=1;
    
    UIImageView *mask=[self.view addImageView:self.view
                                        image:@"member_avatar_mask.png"
                                     position:CGPointMake(0, 0)];
    mask.center=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    
}


- (void)requestFinished:(ASIHTTPRequest *)r
{
    NSLog(@"用户头像上传完成");
    NSLog(@"%@",[r responseString]);
    
    
    int uid=[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] integerValue];
    
    [dh updateAvatar:uid
              Avatar:[r responseString]];
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onLDown:)
                                                              target:self];
    
    
    self.navigationItem.rightBarButtonItem=[self.view add_ok_button:@selector(onSave:)
                                                             target:self];
}


-(void)onLDown:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//保存头像
-(void)onSave:(id)sender
{
        
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(sv.frame.size);

    CGContextRef resizedContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext, -sv.contentOffset.x, -sv.contentOffset.y);
    
    [sv.layer renderInContext:UIGraphicsGetCurrentContext()];

    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    
    image=[self reSizeImage:image
                   toSize:CGSizeMake(200, 200)];
    NSData* data = UIImageJPEGRepresentation(image, .8);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@UserAvatarUpload",ServerURL]];
    NSLog(@"%@",url);
    uploadRequest = nil;
    uploadRequest = [ASIFormDataRequest requestWithURL:url];
    uploadRequest.timeOutSeconds=TIMEOUT;
    uploadRequest.delegate=self;
    uploadRequest.uploadProgressDelegate=self;
    uploadRequest.showAccurateProgress=YES;
    [uploadRequest setRequestMethod:@"POST"];
    
    NSString *ck=[[NSUserDefaults standardUserDefaults] objectForKey:@"Value"];
    if(ck!=nil)
    {
        [uploadRequest setUseCookiePersistence:NO];
        [uploadRequest setRequestCookies:[self.view GetRequestCookie:ServerURL value:ck]];
    }
    
    //场所照片
    [uploadRequest setData:data
              withFileName:@"temp.jpg"
            andContentType:@"image/jpeg"
                    forKey:@"file"];
    
    [uploadRequest startAsynchronous];

}


- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}



//进度条回调
-(void)setProgress:(float)newProgress{
    
    NSLog(@"====%f",newProgress);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
