//
//  UIView+GetRequestErrorInfo.m
//  yydr
//
//  Created by liyi on 13-2-21.
//
//

#import "UIView+GetRequestCookie.h"
#import "global.h"


@implementation UIView (GetRequestCookie)


-(NSMutableArray*)GetRequestCookie:(NSString*)svr value:(NSString*)v
{
    //Create a cookie
    NSDictionary *properties = [[NSMutableDictionary alloc] init];
    [properties setValue:v forKey:NSHTTPCookieValue];
    [properties setValue:@".ASPXAUTH" forKey:NSHTTPCookieName];
    [properties setValue:svr forKey:NSHTTPCookieDomain];
    [properties setValue:@"-1" forKey:NSHTTPCookieExpires];
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    
    return  [NSMutableArray arrayWithObject:cookie];
}


@end
