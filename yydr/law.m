//
//  law.m
//  yydr
//
//  Created by liyi on 13-1-19.
//
//

#import "law.h"
#import "UIView+iImageManager.h"
#import "UIView+iButtonManager.h"

@interface law ()

@end

@implementation law

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor redColor];
    
    UITextView *textView = [[UITextView  alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    [self.view addSubview:textView];
    textView.font=[UIFont systemFontOfSize:16];
    
    textView.text=@"夜色App对于任何自本软件获得的场馆信息、评论或者广告宣传等任何资讯（以下统称”信息“）,不保证真实、准确和完整性。如果任何单位或者个人通过上述“信息“而进行任何行为，须自行甄别真伪和谨慎预防风险。否则，无论何种原因，本软件不对任何非与本软件直接发生的交易或行为承担任何直接、间接、附带或衍生的损失和责任。\n\n本软件内设有场所的公开电话和个人联系方式，此类电话均由场所本身发布，用户拨打任何此类电话进行联系的所有风险自负，本软件不负任何责任。\n\n夜色App有权利但无义务，改善或更正本软件任何部分之任何疏漏、错误。夜色App不保证本公司及其服务器目前或今后任何时候没有计算机病毒或其他有害机能；夜色App亦不保证用户经由本软件取得的任何场馆资料、评论真伪或其他资讯符合用户的期望。\n\n第四条基于以下原因而造成的利润、商业信誉、资料损失或其他有形或无形损失，夜色App不承担任何直接、间接、附带、衍生或惩罚性的赔偿：\n(1) 本软件使用或无法使用；\n(2) 经由本软件购买或无偿取得的任何产品、资料或服务；\n(3) 用户资料遭到未授权的使用或修改；\n(4) 其他与本软件相关的事宜。\n\n由于用户经由本软件上载或发布内容、发表任何评论以及观点、与本软件连接、违反本服务条款或侵害其他人的任何权利导致任何第三人提出权利主张，本软件不承担责任。如因用户上述行为而致使本软件承担任何责任，用户同意赔偿夜色App及合作伙伴、代理人及员工，并使其免受损害。\n\n如因用户在本软件上载或发布侵权或涉嫌侵权的信息、资料，本软件有权根据法律规定予以处理或根据权利人的要求删除相关涉嫌侵权的信息、资料、链接。如用户多次发生侵权或涉嫌侵权的情形，本软件有权采取终止服务、注销用户帐号等方式进一步处理，以维护国家法律和权利人的合法权益。";
    textView.editable=NO;
    
    self.navigationItem.leftBarButtonItem=[self.view add_back_button:@selector(onLDown:)
                                                              target:self];
    
}


-(void)onLDown:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
