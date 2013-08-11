//
//  dbHelper.m
//  yydr
//
//  Created by Li yi on 13-5-28.
//
//

#import "dbHelper.h"

#define nldb @"nldb.sqlite"

@implementation dbHelper


-(void)create
{
    //============================================================================================
    //sqlite数据库
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:nldb];
    
    //获取数据库并打开
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    if ([database open]) {
        //创建表（FMDB中只有update和query操作，出了查询其他都是update操作）
        [database executeUpdate:@"create table dialog (did integer,mid integer,username text,avatar text,message text,count integer,lastdate datetime)"];
        [database executeUpdate:@"create table record (did integer,sid integer,mid integer,createdate datetime,message text,type integer)"];
        [database executeUpdate:@"create table userinfo (userid integer,avatar text,mobile integer,sex integer,username text,signature text,albumpassword integer,roleid integer,cityid integer)"];
        [database close];
    }
}



#pragma mark - 获取未读条数
-(int)getNewMessageCount:(int)mid
{
    int newMsgCount = 0;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
        //更新新消息数量
        FMResultSet *results = [database executeQuery:@"SELECT SUM(count) AS newMsgCount FROM dialog where mid = ?",
                                [NSNumber numberWithInt:mid]];
        
        while ([results next]) {
            newMsgCount = [results intForColumn:@"newMsgCount"];
        }
        [database close];
    }
    
    
    newMsgCount=newMsgCount>99?99:newMsgCount;
    
    return newMsgCount;
}



#pragma mark - 删除聊天记录
-(BOOL)deleteRecord:(int)did Mid:(int)mid
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    BOOL deleted=NO;

    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
        
        //删除图片文件
        /*
        FMResultSet *results = [database executeQuery:@"SELECT message from record where did = ? and mid = ? and type = 2",
                                [NSNumber numberWithInt:mid]];
        while ([results next]) {
            NSString *fileName = [results  stringForColumn:@"message"];
        }
        */
        
        deleted = [database executeUpdate:@"delete from record where did = ? and mid = ?",
                   [NSNumber numberWithInt:did],
                   [NSNumber numberWithInt:mid]];
        [database close];
    }
    
    return deleted;
}



#pragma mark - 删除dialog
-(BOOL)deleteDialog:(int)did Mid:(int)mid
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    BOOL deleted=NO;
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
        deleted = [database executeUpdate:@"delete from dialog where did = ? and mid = ?",
                  [NSNumber numberWithInt:did],
                  [NSNumber numberWithInt:mid]];
        [database close];
    }
    
    return deleted;
}



#pragma mark - 未读消息去清0
-(BOOL)updateRecordCountToZero:(int)did Mid:(int)mid
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    BOOL update=NO;
    
    //清0
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
         update = [database executeUpdate:@"update dialog set count = 0 where did = ? and mid = ?",
                       [NSNumber numberWithInt:did],
                       [NSNumber numberWithInt:mid]];
        [database close];
    }
    
    return update;
}



#pragma mark - 更新相册密码
-(BOOL)updateAlbumPassword:(int)userid Password:(int)ps
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    BOOL update=NO;
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    if ([database open])
    {
        update = [database executeUpdate:@"update userinfo set albumpassword = ? where userid = ?",
                  [NSNumber numberWithInt:ps],
                  [NSNumber numberWithInt:userid]];
        
        [database close];
    }
    
    return update;
}

#pragma mark - 获取相册密码
-(int)getAlbumPassword:(int)userid
{
    //操作数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    int ps=0;
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    if ([database open])
    {
        ps = [database intForQuery:@"select albumpassword from userinfo where userid = ?",
                    [NSNumber numberWithInt:userid]];
        
        [database close];
    }
    
    return  ps;
}



#pragma mark - 获取性别
-(int) getUserSex:(int)userid
{
    //操作数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    int sex=0;
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    if ([database open])
    {
        sex=[database intForQuery:@"select sex from userinfo where userid = ?",
                    [NSNumber numberWithInt:userid]];
        
        [database close];
    }
    
    return  sex;
}




#pragma mark - 获取用户名
-(NSString*)getUserName:(int)userid
{
    //操作数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    NSString *username;
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    if ([database open])
    {
        username = [database stringForQuery:@"select username from userinfo where userid = ?",
                            [NSNumber numberWithInt:userid]];

        [database close];
    }
    
    return  username;
}

#pragma mark - 获取头像
-(NSString*)getAvatar:(int)userid
{
    //操作数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    NSString *avatar;
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    if ([database open])
    {
        avatar = [database stringForQuery:@"select avatar from userinfo where userid = ?",
                    [NSNumber numberWithInt:userid]];
        
        [database close];
    }
    
    return  avatar;
}


#pragma mark - 更新签名
-(BOOL)updateSignature:(int)userid Signatrue:(NSString*)signature
{
 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    BOOL update=NO;
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    if ([database open])
    {
        update = [database executeUpdate:@"update userinfo set signature = ? where userid = ?",
                  signature,[NSNumber numberWithInt:userid]];
        
        [database close];
    }
    
    return update;
    
}



#pragma mark - 更新头像
-(BOOL)updateAvatar:(int)userid Avatar:(NSString*)avatar
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    BOOL update=NO;
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    if ([database open])
    {
        update = [database executeUpdate:@"update userinfo set avatar = ? where userid = ?",
                  avatar,[NSNumber numberWithInt:userid]];
        
        [database close];
    }
    
    return update;
}


#pragma mark - 获取用户信息
-(NSDictionary*)getUserInfo:(int)userid
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    NSDictionary *userinfo;
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
        
        
        FMResultSet *resultSet = [database executeQuery:@"select * from userinfo where userid=?",
                                  [NSNumber numberWithInt:userid]];
        
        while ([resultSet next]) {
            int mobile = [resultSet intForColumn:@"mobile"];
            int sex = [resultSet intForColumn:@"sex"];
            int albumpassword = [resultSet intForColumn:@"albumpassword"];
            
            userinfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSString stringWithFormat:@"%d",userid],@"userid",
                        [resultSet stringForColumn:@"avatar"],@"avatar",
                        [NSString stringWithFormat:@"%d",mobile],@"mobile",
                        [NSString stringWithFormat:@"%d",sex],@"sex",
                        [resultSet stringForColumn:@"username"],@"username",
                        [resultSet stringForColumn:@"signature"],@"signature",
                        [NSString stringWithFormat:@"%d",albumpassword],@"albumpassword",
                        [resultSet stringForColumn:@"roleid"],@"roleid",
                        nil];  
        }
        
        [database close];
    }
    
    return  userinfo;
}


#pragma mark - 更新用户信息
-(void)updateUserInfo:(NSDictionary*)userinfo
{

    NSLog(@"updateUserInfo=%@",userinfo);
    
    
    int UserId=[[userinfo objectForKey:@"UserId"] integerValue];
    
    //操作数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    if ([database open])
    {
        //userinfo表
        //==============================================
        NSUInteger count = [database intForQuery:@"select * from userinfo where userid = ?",
                            [NSNumber numberWithInt:UserId]];
        

        //性别与电话
        id sex=[userinfo objectForKey:@"Sex"];
        id mobile=[userinfo objectForKey:@"Mobile"];
        id signature=[userinfo objectForKey:@"Signature"];
        id avatar=[userinfo objectForKey:@"Avatar"];
        int roleid=[[userinfo objectForKey:@"UserLevel"] integerValue];
        int cityid=[[userinfo objectForKey:@"CityId"] integerValue];
        int sexNum,mobileNum;
        
        if( sex && ![sex isKindOfClass:[NSNull class]] )
        {
            sexNum=[sex integerValue];
        }
        else
        {
            sexNum=1;
        }
        
        if( !mobile && [mobile isKindOfClass:[NSNull class]] )
        {
            mobileNum=[mobile integerValue];
        }
        else
        {
            mobileNum=0;
        }
        
        //签名
        if( !signature || [signature isKindOfClass:[NSNull class]] )
        {
             signature=@"";
        }

        //头像
        if( !avatar || [avatar isKindOfClass:[NSNull class]] )
        {
            
            avatar=@"";
        }

        
        
        
        
        if (count>0) {
            //更新数据
            NSLog(@"更新");
            BOOL update = [database executeUpdate:@"update userinfo set avatar = ?, mobile = ?, username = ?, sex = ?, signature = ?, albumpassword = ?, roleid = ?, cityid = ? where userid = ?",
                           avatar,
                           [NSNumber numberWithInt:mobileNum],
                           [userinfo objectForKey:@"UserName"],
                           [NSNumber numberWithInt:sexNum],
                           signature,
                           [userinfo objectForKey:@"AlbumPassword"],
                           [NSNumber numberWithInt:roleid],
                           [NSNumber numberWithInt:UserId],
                           [NSNumber numberWithInt:cityid]];
            
            if(update){
                NSLog(@"更新UserInfo成功");
            }
        }
        else
        {
            NSLog(@"插入");
            
            //插入数据
            BOOL insert = [database executeUpdate:@"insert into userinfo values (?,?,?,?,?,?,?,?,?)",
                           [NSNumber numberWithInt:UserId] ,
                           avatar,
                           [NSNumber numberWithInt:mobileNum],
                           [NSNumber numberWithInt:sexNum],
                           [userinfo objectForKey:@"UserName"],
                           signature,
                           [userinfo objectForKey:@"AlbumPassword"],
                           [NSNumber numberWithInt:roleid],
                           [NSNumber numberWithInt:cityid]];
            
            
            if (insert) {
                NSLog(@"插入UserInfo成功");
            }
        }

        
        
        [database close];
    }
    

}


#pragma mark - 更新对话内容到Dialog与Record表
-(void)updateDatabase:(int)_did         //对话方id
             senderid:(int)sid          //发送方id
               selfid:(int)mid          //自己的id
           dialogname:(NSString*)dun     //发送者用户名
         dialogavatar:(NSString*)dav  //发送者头像
              message:(NSString*)msg    //消息内容
                 type:(int)type
            addNewMsg:(int)num
{

    
    NSLog(@"dialogname=%@ dialogavatar=%@",dun,dav);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:nldb];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    if ([database open]) {
        
        NSUInteger count = [database intForQuery:@"select * from dialog where did = ? and mid = ?",
                            [NSNumber numberWithInt:_did],
                            [NSNumber numberWithInt:mid]];
        
        
        if (count>0) {
            //更新dialog表
            BOOL update = [database executeUpdate:@"update dialog set count=count+?, lastdate = ?,message = ?,avatar = ? where did = ? and mid = ?",
                           [NSNumber numberWithInt:num],
                           [NSDate date],
                           msg,
                           dav,
                           [NSNumber numberWithInt:_did],
                           [NSNumber numberWithInt:mid]];
            
            if(update){
                //NSLog(@"更新dialog成功");
            }
        }
        else
        {
            //插入数据
            BOOL insert = [database executeUpdate:@"insert into dialog values (?,?,?,?,?,?,?)",
                           [NSNumber numberWithInt:_did],
                           [NSNumber numberWithInt:mid],
                           dun,
                           dav,
                           msg,
                           [NSNumber numberWithInt:1],
                           [NSDate date]];
            
            if (insert) {
                //NSLog(@"插入dialog成功");
            }
        }
        
        //更新record表
        BOOL insert = [database executeUpdate:@"insert into record values (?,?,?,?,?,?)",
                       [NSNumber numberWithInt:_did],//did
                       [NSNumber numberWithInt:sid],//sid
                       [NSNumber numberWithInt:mid],//mid
                       [NSDate date],
                       msg,
                       [NSNumber numberWithInt:type]];
        
        if (insert) {
            NSLog(@"插入record成功");
        }
        
        [database close];
    }
}



@end
