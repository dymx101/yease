//
//  place_list_cell.m
//  yydr
//
//  Created by liyi on 13-1-2.
//
//

#import "place_list_cell.h"
#import "global.h"

@implementation place_list_cell

@synthesize placelevel;
@synthesize placeName;
@synthesize placePrice;
@synthesize placeAddress;
@synthesize photo;
@synthesize distance;
@synthesize loc;
@synthesize ke;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
//        self.backgroundView=[self addImageView:nil
//                                         image:@"place_cell_bg.jpg"
//                                      position:CGPointMake(0, 0)];
        
        
        //场所照片
        self.photo =[self addImageView:self.contentView
                            image:@"noPhoto.png"
                         position:CGPointMake(15, 10)];
        self.photo.center=CGPointMake(self.photo.center.x, 50);
        self.photo.backgroundColor = [UIColor grayColor];
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.clipsToBounds = YES;
        
        
        //场所图标
        self.placelevel =[self addImageView:self.contentView
                                    image:@"place_new.png"
                                 position:CGPointMake(58, 3)];
        self.placelevel.hidden=YES;
        

        
        //场所名字
        self.placeName = [self addLabel:self.contentView
                             frame:CGRectMake(100, 8, 200, 25)
                              font:[UIFont systemFontOfSize:18]
                              text:@""
                             color:[UIColor blackColor]
                               tag:0];
        
        self.placeName.shadowColor=[UIColor whiteColor];
        self.placeName.shadowOffset=CGSizeMake(0,1);
        
        //消费
        self.placePrice = [self addLabel:self.contentView
                              frame:CGRectMake(200, 40, 150, 20)
                               font:[UIFont systemFontOfSize:14]
                               text:@""
                              color:[UIColor blackColor]
                                tag:0];

        //客户经理图标=======================================
        ke=[self addImageView:self.contentView
                        image:@"ke_icon.png"
                     position:CGPointMake(500,0)];
        ke.hidden=YES;

        UILabel *ke_t= [self addLabel:ke
                                frame:CGRectMake(0, 0, 10, 25)
                                 font:[UIFont boldSystemFontOfSize:12]
                                 text:@"经"
                                color:[UIColor whiteColor]
                                  tag:0];
        [ke_t sizeToFit];
        ke_t.center=CGPointMake(ke.frame.size.width/2, ke.frame.size.height/2);
        //=================================================
        
        //星
        star = [self addImageView:self.contentView
                            image:@"star_0.png"
                         position:CGPointMake(100, 40)];

        //地址
        self.placeAddress = [self addLabel:self.contentView
                                frame:CGRectMake(100, 60, 200, 25)
                                 font:[UIFont systemFontOfSize:15]
                                 text:@""
                                color:[UIColor blackColor]
                                  tag:0];

        //距离yuepooadm@gmail.com
        self.distance=[self addLabel:self.contentView
                               frame:CGRectMake(242, 85, 70, 15)
                                font:[UIFont systemFontOfSize:12]
                                text:@"1000m"
                               color:[UIColor grayColor]
                                 tag:0];


//        self.loc=[self addImageView:self.contentView
//                              image:@"place_loc.png"
//                           position:CGPointMake(0, 86)];
//        
        
        
        self.distance.textAlignment = UITextAlignmentRight;
        
    }
    return self;
}

//每行内容
-(void)loadPlaceDetail:(NSDictionary*)pd
{
    int price=[[pd objectForKey:@"Price"] intValue];
    int manager=[[pd objectForKey:@"ManagerCount"] intValue];
    int starNum=[[pd objectForKey:@"Star"] intValue];

    
    int status=[[pd objectForKey:@"AdvStatus"] intValue];
    
    float ds=[[pd objectForKey:@"Distance"] floatValue];
    
    
    //===================================================================================================
    //名称
    
    self.placeName.text=[NSString stringWithFormat:@"%@",[pd objectForKey:@"Name"]];
    

    //图标
    switch (status) {
        case 1:
        {
            //新开
            self.placelevel.hidden=NO;
            self.placelevel.image=[UIImage imageNamed:@"place_new.png"];
        }
            break;
        case 2:
        {
            //推荐
            self.placelevel.hidden=NO;
            self.placelevel.image=[UIImage imageNamed:@"place_hot.png"];
        }
            break;
        case 3:
        {
            //优惠
            self.placelevel.hidden=NO;
            self.placelevel.image=[UIImage imageNamed:@"place_off.png"];
        }
            break;
        default:
        {
            self.placelevel.hidden=YES;
        }
            break;
    }
    


    
    //==================================================================================================
    //距离
    
    if(ds<1)
    {
        int temp=ds*1000;
        self.distance.text=[NSString stringWithFormat:@"%dm",temp];
    }
    else
    {
        int temp=(int)(ds*10);
        
        if(temp%10==0)
        {
            self.distance.text=[NSString stringWithFormat:@"%dkm",temp/10];
        }
        else
        {
            ds=(float)temp/10;
            self.distance.text=[NSString stringWithFormat:@"%.1fkm",ds];
        }
    }

    
    //==================================================================================================
    //地址
    self.placeAddress.text=[NSString stringWithFormat:@"%@ %@",
                            [pd objectForKey:@"Area"],
                            [pd objectForKey:@"Address"]];

    //===================================================================================================
    //人均
    
    if(price>0)
    {
        self.placePrice.text=[NSString stringWithFormat:@"¥ %d",price];
        [self.placePrice sizeToFit];
    }
    else
    {
        self.placePrice.text=@"";
    }

    
    //===================================================================================================
    //经理
    
    if(manager>0)
    {
        //有客户经理
        self.ke.center=CGPointMake(self.placePrice.frame.origin.x+self.placePrice.frame.size.width+15,
                                   self.placePrice.center.y);
        self.ke.hidden=NO;
    }
    else
    {
        self.ke.hidden=YES;
    }

    //===================================================================================================
    //计算星星数量 

    star.image=[UIImage imageNamed:[NSString stringWithFormat:@"star_%d.png",starNum]];


    
    //===================================================================================================
    //相册
    
    NSString *FileName=[pd objectForKey:@"Path"];
    int pid=[[pd objectForKey:@"Id"] integerValue];
    
    if(![FileName isEqual:[NSNull null]])
    {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%d/%@",PlacePhotoURL,pid,[NSString stringWithFormat:@"thumb_%@",FileName]]];
        [self.photo setImageWithURL:url
                   placeholderImage:[UIImage imageNamed:@"noPhoto.png"]];
    }
    else
    {
        self.photo.image=[UIImage imageNamed:@"noPhoto.png"];
    }

}


-(void)drawRect:(CGRect)rect
{
    
}

@end
