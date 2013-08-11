//
//  dbHelper.h
//  yydr
//
//  Created by Li yi on 13-5-28.
//
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"

@interface dbHelper : NSObject
{
    
}

-(void)create;
-(void)updateUserInfo:(NSDictionary*)userinfo;
-(NSDictionary*)getUserInfo:(int)userid;
-(BOOL)updateAvatar:(int)userid Avatar:(NSString*)avatar;
-(NSString*)getUserName:(int)userid;
-(NSString*)getAvatar:(int)userid;
-(BOOL)updateSignature:(int)userid Signatrue:(NSString*)signature;
-(int)getAlbumPassword:(int)userid;
-(BOOL)updateAlbumPassword:(int)userid Password:(int)ps;
-(BOOL)updateRecordCountToZero:(int)did Mid:(int)mid;
-(BOOL)deleteDialog:(int)did Mid:(int)mid;
-(BOOL)deleteRecord:(int)did Mid:(int)mid;
-(int)getUserSex:(int)userid;
-(int)getNewMessageCount:(int)mid;


-(void)updateDatabase:(int)_did         //对话方id
             senderid:(int)sid          //发送方id
               selfid:(int)mid          //自己的id
           dialogname:(NSString*)dun    //接受者用户名
         dialogavatar:(NSString*)dav    //接受者头像
              message:(NSString*)msg    //消息内容
                 type:(int)type
            addNewMsg:(int)num;

@end
