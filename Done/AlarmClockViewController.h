//
//  AlarmClock.h
//  
//
//  Created by yuan.wu on 8/26/16.
//
//

#import <UIKit/UIKit.h>
@protocol clockReminderDelegate <NSObject>
-(void)didSelectTime:(NSDate *) date;
@end

@interface AlarmClockViewController : UIViewController
{
    UILabel *_showLabel;
}
@property(weak,nonatomic) id<clockReminderDelegate> delegate;
@end
