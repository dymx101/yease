//
//  UIView+iTextManager.h
//  test
//
//  Created by 毅 李 on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (iTextManager)
-(UILabel*)addLabel:(UIView*)v frame:(CGRect)r font:(UIFont*)f text:(NSString*)t color:(UIColor*)c tag:(int)g;

-(UITextField*)addTextField:(UIView*)v frame:(CGRect)r font:(UIFont*)f color:(UIColor*)c placeholder:(NSString*)ph tag:(int)t;

@end
