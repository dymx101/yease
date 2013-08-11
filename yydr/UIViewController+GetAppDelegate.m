//
//  UIViewController+GetAppDelegate.m
//  yydr
//
//  Created by liyi on 13-4-30.
//
//

#import "UIViewController+GetAppDelegate.h"

@implementation UIViewController (GetAppDelegate)


//取得当前程序的委托
-(AppDelegate*)appDelegate{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

@end
