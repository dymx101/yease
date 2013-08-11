//
//  girlChatDelegate.h
//  yydr
//
//  Created by liyi on 12-12-19.
//
//

#import <Foundation/Foundation.h>

@protocol chatDelegate <NSObject>

-(void)messageReceived:(NSDictionary*)msg;
//-(void)buddyOnline:(NSString*)name;
//-(void)buddyOffline:(NSString*)name;

@end
