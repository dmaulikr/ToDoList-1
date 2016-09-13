//
//  ViewController.m
//  Done
//
//  Created by yuan.wu on 8/22/16.
//  Copyright © 2016 yuan.wu. All rights reserved.
//

#import "ViewController.h"
#import <FMDatabase.h>
#import <FMResultSet.h>
#include <FMDB.h>
#import "FMDBHelper.h"
#import "BaseModel.h"
#import "NewReminderViewController.h"
@interface ViewController ()
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FMDatabase *db = [FMDatabase databaseWithPath:@"/Users/yuanwu/Desktop/toDoList.db"];
    self.db=db;
    
    
    if ([self.db open]) {
        BOOL result=[self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS Reminder1 (rId integer PRIMARY KEY AUTOINCREMENT, title text NOT NULL, content text, flag bool, isCompleted bool, remindTime date);"];
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
        [_db close];
    } else {
        NSLog(@"数据库打开失败");
    }

    if ([self.db open]) {
        NSString *title = @"aaa";
        NSString *content = @"bbb";
        
        BOOL result = [self.db executeUpdate:@"INSERT INTO Reminder1 (title, content, flag, isCompleted, remindTime) VALUES ('title','content','true','true', null);"];
        //        BOOL result = [self.db executeUpdate:@"INSERT INTO Reminder (rId, title, content, flag, isCompleted, RemindTime) VALUES (?,?,?,?,?,?);", model.rId, model.title, model.content, model.flag, model.isCompleted, model.clock];
        
        if (result) {
            NSLog(@"添加数据成功");
        }else{
            NSLog(@"添加数据失败");
        }
        [self.db close];
    } else {
        NSLog(@"数据库打开失败");
    }

    
//    if ([db open]) {
//        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS toDoList (id integer PRIMARY KEY AUTOINCREMENT, incomplete_list text, completed_list text, tag text);"];
//        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Reminder (iid integer PRIMARY KEY AUTOINCREMENT references toDoList(id), RemindTime date not null)"];
//        if (result) {
//                NSLog(@"创表成功");
//            } else {
//                NSLog(@"创表失败");
//                }
//        [_db close];
//    }
    
    
    //    if ([db open]) {
    //        BOOL res = [db executeUpdate:@"DROP TABLE IF EXISTS Reminder1;"];
    //        //BOOL res = [db executeUpdate: @"delete from toDoList2 where content = 'hahaha'"];
    //
    //        if (!res) {
    //            NSLog(@"error when delete db table");
    //        } else {
    //            NSLog(@"success to delete db table");
    //        }
    //        [db close];
    //    }

    
////    NSArray *arr = @[@"aa",@"bb",@"cc"];
//    if ([self.db open]) {
//        NSDate *date = [NSDate date];
//        [db executeUpdate:@"insert into Reminder (RemindTime) values(?)",date];
//        [db executeUpdate:@"UPDATE toDoList SET tag = 'haha' WHERE incomplete_list = 'aa'"];
//        [self.db close];
//}
    
}




    



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
