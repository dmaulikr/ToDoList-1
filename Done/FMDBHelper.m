//
//  DB.m
//  Done
//
//  Created by yuan.wu on 8/23/16.
//  Copyright © 2016 yuan.wu. All rights reserved.
//

#import "FMDBHelper.h"
#import "BaseModel.h"
#import "NewReminderViewController.h"


static FMDBHelper*helper = nil;
@implementation FMDBHelper
+ (FMDBHelper *)sharedDataBaseHelper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[FMDBHelper alloc] init];
        [helper createDataBase];
        [helper createTable];
    });return helper;
}
////创建数据库
- (void)createDataBase{
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)firstObject];
//    NSString *filePath = [doc stringByAppendingPathComponent:@"Done.db"];
//    //创建数据库
//    self.db = [FMDatabase databaseWithPath:filePath];

    FMDatabase *db = [FMDatabase databaseWithPath:@"/Users/yuanwu/Desktop/toDoList1.db"];
    self.db=db;

}


//创表
- (void)createTable{
    if ([self.db open]) {
        BOOL result=[self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS Reminder (rId integer PRIMARY KEY AUTOINCREMENT, title text NOT NULL, content text, flag bool, isCompleted bool,clock date, isTopped integer);"];
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
        [_db close];
    } else {
         NSLog(@"数据库打开失败");
    }

}

// 添加数据
- (NSInteger)insertReminder:(BaseModel *) model{
    NSInteger id;
    if ([self.db open]) {
        NSString *title = model.title;
        NSString *content = model.content;
        bool flag = model.flag;
        BOOL isCompleted = model.isCompleted;
        NSDate *date = model.clock;
        //NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        
        BOOL result = [self.db executeUpdate:@"INSERT INTO Reminder (title, content, flag, isCompleted, clock, isTopped) VALUES (?, ?, ?, ?, ?, ?);",title,content,flag?@"true":@"false",isCompleted?@"true":@"false", date, [NSNumber numberWithInt:0]];
        if (result) {
            NSLog(@"添加数据成功");
        }else{
            NSLog(@"添加数据失败");
        }
        id = [self.db lastInsertRowId];
        [self.db close];
    } else {
        NSLog(@"数据库打开失败");
    }
    return id;
}


//删除
-(void) deleteReminder:(NSInteger)row {
  
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:@"DELETE FROM Reminder WHERE rId = ? ", [NSNumber numberWithInt:row]];
        if (result) {
            NSLog(@"删除数据成功");
        }else{
            NSLog(@"删除失败");
        }
        [self.db close];
    }else{
        NSLog(@"数据库打开失败");
    }
}

//更新
-(void) updateReminder:(BaseModel *)model{
    NSDate *date = model.clock;
    NSLog(@"update title is:%@", model.title);
    NSLog(@"update flag is %d", model.flag);
    
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:@"UPDATE Reminder SET flag = ?,title = ?, content = ?, clock = ? WHERE rId = ?", (model.flag)?@"true":@"false", model.title, model.content, date, [NSNumber numberWithInt:model.rId]];
        if (result) {
            NSLog(@"修改成功");
        }
        else
        {
            NSLog(@"修改失败");
        } [self.db close];
    } else {
        NSLog(@"数据库打开失败");
    }
}

-(void)updateIsTopped:(NSInteger)rID
{
    if ([self.db open]) {
       FMResultSet *set = [self.db executeQuery:@"SELECT MAX(isTopped) FROM Reminder"];
        NSLog(@"columnNameToIndexMap:%@",set.columnNameToIndexMap);
        
        NSInteger Top;
        while ([set next]) {
            Top = [set intForColumn:@"max(istopped)"];
            NSLog(@"Max Top is: %zd", Top);
        }
        
       NSLog(@"Max Top is: %zd", Top);
       BOOL result = [self.db executeUpdate:@"UPDATE Reminder SET isTopped = ? WHERE rId = ?",[NSNumber numberWithInt:(Top + 1)], [NSNumber numberWithInt:rID]];
    } [self.db close];
}

-(void)updateCompleteStatus:(BaseModel *)model withStatus:(BOOL) status{
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:@"UPDATE Reminder SET isCompleted = ? WHERE rId = ?", status?@"true":@"false", [NSNumber numberWithInt:model.rId]];
        if (result) {
            NSLog(@"更改complete成功");
        }
        else
            
        {
            NSLog(@"更改complete失败");
        } [self.db close];
    } else {
        NSLog(@"数据库打开失败");
    }

}



-(NSArray*) queryReminderwithClock    //提醒事件只显示未完成事件
{
    NSMutableArray *arr = [NSMutableArray array];
    if ([self.db open]) {
       FMResultSet *result = [self.db executeQuery:@"SELECT * FROM Reminder WHERE clock is not null and isCompleted ='false' "];
        while ([result next]) {
            BaseModel *modelItem = [BaseModel new];
            modelItem.rId = [result intForColumn:@"rId"];
            modelItem.content = [result stringForColumn:@"content"];
            modelItem.title = [result stringForColumn:@"title"];
            NSString *str1 = [result stringForColumn:@"isCompleted"];
            if ([str1 isEqualToString:@"true"]) {
                modelItem.isCompleted = YES;
            } else {
                modelItem.isCompleted = NO;}
            NSString *str = [result stringForColumn:@"flag"];
            if ([str isEqualToString:@"true"]) {
                modelItem.flag = YES;
            } else {
                modelItem.flag = NO;}
            modelItem.clock = [result dateForColumn:@"clock"];
            [arr addObject:modelItem];
        }
    }
    return arr;
}

-(NSArray*) queryReminderwithCompletedStatus:(BOOL) status
{
    NSMutableArray *arr = [NSMutableArray array];
    if ([self.db open]) {
        FMResultSet *result = [self.db executeQuery:@"SELECT * FROM Reminder WHERE isCompleted = ? order by isTopped desc", status?@"true":@"false"];
        while ([result next]) {
            BaseModel *modelItem = [BaseModel new];
            modelItem.rId = [result intForColumn:@"rId"];
            modelItem.content = [result stringForColumn:@"content"];
            modelItem.title = [result stringForColumn:@"title"];
            NSString *str1 = [result stringForColumn:@"isCompleted"];
            if ([str1 isEqualToString:@"true"]) {
                modelItem.isCompleted = YES;
            } else {
                modelItem.isCompleted = NO;}
            NSLog(@"modelItem.isCompleted: %d", modelItem.isCompleted);
            NSString *str = [result stringForColumn:@"flag"];
            if ([str isEqualToString:@"true"]) {
                modelItem.flag = YES;
            } else {
                modelItem.flag = NO;}
            modelItem.clock = [result dateForColumn:@"clock"];
            [arr addObject:modelItem];
        }
    }
    return arr;

}
//-(NSArray*) queryReminderwithinCompletedStatus
//{
//    NSMutableArray *arr = [NSMutableArray array];
//    if ([self.db open]) {
//        FMResultSet *result = [self.db executeQuery:@"SELECT * FROM Reminder WHERE isCompleted = 'false'"];
//        while ([result next]) {
//            BaseModel *modelItem = [BaseModel new];
//            modelItem.rId = [result intForColumn:@"rId"];
//            modelItem.content = [result stringForColumn:@"content"];
//            modelItem.title = [result stringForColumn:@"title"];
//            NSString *str1 = [result stringForColumn:@"isCompleted"];
//            if ([str1 isEqualToString:@"true"]) {
//                modelItem.isCompleted = YES;
//            } else {
//                modelItem.isCompleted = NO;}
//            NSLog(@"modelItem.isCompleted: %d", modelItem.isCompleted);
//            NSString *str = [result stringForColumn:@"flag"];
//            if ([str isEqualToString:@"true"]) {
//                modelItem.flag = YES;
//            } else {
//                modelItem.flag = NO;}
//            modelItem.clock = [result dateForColumn:@"clock"];
//            [arr addObject:modelItem];
//        }
//    }
//    return arr;
//    
//}






@end
