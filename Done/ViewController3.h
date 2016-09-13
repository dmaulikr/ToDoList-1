//
//  ViewController3.h
//  Done
//
//  Created by yuan.wu on 8/22/16.
//  Copyright © 2016 yuan.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
@protocol seeDetail3Delegate <NSObject>
-(void)didSelectDetail:(BaseModel*) model;
@end

@interface ViewController3 : UIViewController
@property(weak,nonatomic) id<seeDetail3Delegate> delegate;

@end
