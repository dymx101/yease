//
//  UIView+iTextManager.m
//  test
//
//  Created by 毅 李 on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+iTextManager.h"

@implementation UIView (iTextManager)


-(UITextField*)addTextField:(UIView*)v frame:(CGRect)r font:(UIFont*)f color:(UIColor*)c placeholder:(NSString*)ph tag:(int)t
{
    // Add a UITextField
    UITextField *textField = [[UITextField alloc] init];
    textField.tag = t;
    textField.enablesReturnKeyAutomatically = YES;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.frame = r;
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField.backgroundColor=[UIColor clearColor];
    textField.font= f;
    textField.returnKeyType = UIReturnKeyDone;
    textField.textColor=c;
    textField.placeholder=ph;
    //垂直居中
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    if(v!=nil)
    {
        [v addSubview:textField];
    }

    return  textField;
}


-(UILabel*)addLabel:(UIView*)v frame:(CGRect)r font:(UIFont*)f text:(NSString*)t color:(UIColor*)c tag:(int)g
{
    UILabel *l=[[UILabel alloc] initWithFrame:r];
    l.backgroundColor=[UIColor clearColor];
    l.textColor=c;
    
    l.text=t;
    
    if(g>0)
    {
        l.tag=g;
    }
    l.textAlignment = UITextAlignmentLeft;
    l.font = f;
    
    if(v!=nil)
    {
        [v addSubview:l];
    }
    
    return l;
}


@end
