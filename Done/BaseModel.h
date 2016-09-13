//
//  BaseModel.h
//  Done
//
//  Created by yuan.wu on 8/23/16.
//  Copyright © 2016 yuan.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmClockViewController.h"

@interface BaseModel : NSObject
@property(nonatomic) NSInteger rId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) BOOL flag;
@property (nonatomic, strong) NSDate *clock;
@property (nonatomic) BOOL isCompleted;
@property (nonatomic) NSInteger isTopped;
-(void)save;
@end
