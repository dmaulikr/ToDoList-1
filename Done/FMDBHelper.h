//
//  DB.h
//  Done
//
//  Created by yuan.wu on 8/23/16.
//  Copyright © 2016 yuan.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "BaseModel.h"
#import <FMDatabase.h>
#import <FMResultSet.h>
#include <FMDB.h>

@interface FMDBHelper : NSObject
+ (FMDBHelper *)sharedDataBaseHelper;
@property (nonatomic, strong) FMDatabase *db;

- (void)createDataBase;
- (NSInteger)insertReminder:(BaseModel *) model;
- (void)createTable;
- (void)deleteReminder:(NSInteger) row;
-(void) updateReminder:(BaseModel *)model;
-(NSArray*) queryReminderwithFlag:(BOOL) flag;
-(NSArray*) queryReminderwithCompletedStatus:(BOOL) status;
-(NSArray*) queryReminderwithClock;
-(void)reArrange;
-(void)updateCompleteStatus:(BaseModel *)model withStatus:(BOOL) status;
//-(void)updateIsTopped:(BaseModel *)model;
-(void)updateIsTopped:(NSInteger)rID;
@end
