//
//  iuiueSQL.m
//  木鸟房东助手
//
//  Created by 赵中良 on 14/12/15.
//  Copyright (c) 2014年 iuiue. All rights reserved.
//

#import "iuiueSQL.h"
#import "FMDatabase.h"

//#define DBNAME    @"personinfo.sqlite"
//#define NAME      @"name"
//#define AGE       @"age"
//#define ADDRESS   @"address"
//#define TABLENAME @"PERSONINFO"

@interface iuiueSQL(){
    FMDatabase *db_;
}

- (BOOL)opendb;

- (BOOL)closedb;

@end

@implementation iuiueSQL


//数据库初始化
- (id)init{
    self = [super init];
    if (self) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *name = [NSString stringWithFormat:@"%@.db",MY_UID];
        NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:name];
        db_ = [FMDatabase databaseWithPath:documentLibraryFolderPath];
        [self CREATTABLE];
        
    }
    return self;
}


// 打开数据库
- (BOOL)opendb{
    if ([db_ open]) {
        return YES;
    }
    NSLog(@"err:%@",db_.lastErrorMessage);
    return NO;
}
//关闭数据库
- (BOOL)closedb{
    return [db_ close];
}

//创建表
-(BOOL)CREATTABLE{
    BOOL flag = NO;
    if ([self opendb])
    {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, uid TEXT, image TEXT,from TEXT, to TEXT, body TEXT ,time TEXT,isRead BOOL)",MY_UID];
        if ([db_ executeUpdate:sql])
        {
            flag = YES;
            NSLog(@"%@数据库用户列表创建成功",MY_UID);
        }
//        NSString *sql1 = @"CREATE TABLE IF NOT EXISTS FRIENDSINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, uid TEXT, image TEXT)";
//        if ([db_ executeUpdate:sql1])
//        {
//            flag = YES;
//            NSLog(@"数据库好友列表创建成功");
//        }
//        NSString *sql2 = @"CREATE TABLE IF NOT EXISTS CHATLIST (ID INTEGER PRIMARY KEY AUTOINCREMENT, from TEXT, to TEXT, body TEXT)";
//        if ([db_ executeUpdate:sql2])
//        {
//            flag = YES;
//            NSLog(@"数据库聊天列表创建成功");
//        }

    }
    [self closedb];
    return flag;
}

//-(NSArray *)queryForFriendList{
//    
//}

@end
