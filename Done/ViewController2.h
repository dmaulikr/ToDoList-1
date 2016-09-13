//
//  ViewConroller2.h
//  Done
//
//  Created by yuan.wu on 8/22/16.
//  Copyright © 2016 yuan.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
@protocol seeDetailDelegate <NSObject>
-(void) didSelectDetail:(BaseModel*) model;
@end

@interface ViewController2 : UIViewController
@property(weak,nonatomic) id<seeDetailDelegate> delegate;
@end
