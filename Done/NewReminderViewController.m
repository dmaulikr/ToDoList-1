//
//  NewReminderViewController.m
//  Done
//
//  Created by yuan.wu on 8/23/16.
//  Copyright © 2016 yuan.wu. All rights reserved.
//

#import "NewReminderViewController.h"
#import <Masonry.h>
#import "SegmentTabController.h"
#import "FMDBHelper.h"
#import "AlarmClockViewController.h"
#import "ViewController1.h"
#import "UIViewController+DismissKeyboard.h"

@interface NewReminderViewController()<UITextFieldDelegate, UITextViewDelegate,clockReminderDelegate>
@property(nonatomic, strong) UITextField *textField1;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UIButton *button1;
@property(nonatomic, strong) UIButton *button2;
@property(nonatomic, strong) UIButton *button3;
@property(nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIControl *control;
@property (nonatomic, strong)BaseModel* mainModel;
@property(nonatomic) BOOL flag;
@property(nonatomic) BOOL isCompleted;
@property(nonatomic) NSInteger isTopped;
@property(nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic,strong) NSDate *clock;

@end

@implementation NewReminderViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [imageView setImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:imageView];
    [self setupForDismissKeyboard];     //使keyboard消失
    
    _textField1 = [[UITextField alloc] init];
    if (_mainModel.title){
        _textField1.text = _mainModel.title;
    }
    _textField1.placeholder = @"请输入标题";
    [_textField1 setBorderStyle:UITextBorderStyleRoundedRect];
    [_textField1.layer setCornerRadius:10];
    [_textField1 setDelegate:self];
    _textField1.secureTextEntry = NO;
    _textField1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_textField1];
    
    [_textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //with is an optional semantic filler
        make.top.equalTo(self.view).offset(80);
        make.left.equalTo(self.view).offset(2.5);
        make.size.mas_equalTo( CGSizeMake(370, 40));
    }];
    
    _showLabel = [[UILabel alloc] init];
    _showLabel.text = @"";
    [self.view addSubview:_showLabel];
    [_showLabel setTextAlignment:NSTextAlignmentCenter];
    [_showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //with is an optional semantic filler
        make.top.equalTo(_textField1.mas_bottom).offset(45);
        make.left.equalTo(_textField1).offset(0);
        make.size.mas_equalTo( CGSizeMake(370, 30));
    }];


    if(_mainModel) {
        _clock = _mainModel.clock;
        _flag = _mainModel.flag;
        _isCompleted = _mainModel.isCompleted;
        _isTopped = _mainModel.isTopped;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日(EEEE)  HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:_mainModel.clock];
        [_showLabel setText: dateString];
    } else {
        _clock = nil;
        _flag = NO;
        _isCompleted = NO;
        _isTopped = 0;
        
    }
    
    _textView = [[UITextView alloc] init];
    if (_mainModel.content){
        _textView.text = _mainModel.content;
    }
    _textView.delegate = self;
    _textView.font = [UIFont fontWithName:@"Arial" size:16.0];
    [_textView.layer setCornerRadius:10];
    _textView.textColor = [UIColor blackColor];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        //with is an optional semantic filler
        make.top.equalTo(_textField1.mas_bottom).offset(80);
        make.left.equalTo(_textField1).offset(0);
        make.size.mas_equalTo( CGSizeMake(370, 300));
    }];

    _button3 = [[UIButton alloc] init];
    [_button3 setTitle:@"旗" forState:UIControlStateNormal];
    [_button3 setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
    [_button3.layer setCornerRadius:10.0];
    if (_flag) {
        [_button3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    [_button3 setTag:2];
    [_button3 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button3];
    
    [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        //with is an optional semantic filler
        make.bottom.equalTo(_textField1.mas_bottom).offset(-3);
        make.right.equalTo(_textField1).offset(-6);
        make.size.mas_equalTo( CGSizeMake(20, 20));
    }];
    
    // 闹铃按钮
    _button4 = [[UIButton alloc] init];
    [_button4 setTitle:@"添加闹铃提醒" forState:UIControlStateNormal];
    [_button4 setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
    [_button4 setTag:3];
    [_button4 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_button4 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button4];
    [_button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        //with is an optional semantic filler
        make.top.equalTo(_textField1.mas_bottom).offset(8);
        make.left.equalTo(_textField1).offset(100);
        make.size.mas_equalTo( CGSizeMake(150, 40));
    }];
    // switch button
    _switchButton = [[ UISwitch alloc] init];
    [_switchButton setOn:YES];
    [self.view addSubview:_switchButton];
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //with is an optional semantic filler
        make.top.equalTo(_textField1.mas_bottom).offset(10);
        make.right.equalTo(_textField1).offset(-20);
    }];
    [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    
    // 取消 & 确定 按钮
    _button1 = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 50, 40)];
    [_button1 setTitle:@"确定" forState: UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_button1 setTag:0];
    [_button1 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_button1];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void) clicked1:(UIControl *)sender
{
    [_textView resignFirstResponder];
    
}

-(void)switchAction:(UISwitch*) myswitch
{
    BOOL isButtonOn = [_switchButton isOn];
    if (isButtonOn) {
        _clock = _mainModel.clock;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日(EEEE)  HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:_mainModel.clock];
        [_showLabel setText: dateString];
    } else {
        _clock = nil;
        [_showLabel setText: @""];
    }
}

-(void) clicked:(UIButton *) sender
{
    if (sender.tag == 1) {   // cancel
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (sender.tag == 2) {  // flag
        [_button3 setTitleColor:[UIColor colorWithRed:255.0/255 green:87.0/255 blue:132.0/255 alpha:0.8]  forState:UIControlStateNormal];
        _flag = YES;
    }
    if ([_textField1.text isEqualToString:@""]){
        if (sender.tag == 0 || sender.tag == 3) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入标题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [myAlertView show];
        }
    } else {
        if (sender.tag == 3) {
            AlarmClockViewController* vc = [[AlarmClockViewController alloc] init];
            [vc setDelegate:self];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (sender.tag == 0) {
            BaseModel *model = [[BaseModel alloc] init];
            model.content = _textView.text;
            model.title = _textField1.text;
            model.flag = _flag;
            model.isCompleted = NO;
            model.clock = _clock;
            model.isTopped = _isTopped;
            model.rId = _mainModel.rId;
            model.isTopped = _isTopped;
            if (_mainModel) {
                [[FMDBHelper sharedDataBaseHelper] updateReminder:model];
                
            } else {
            model.rId = [[FMDBHelper sharedDataBaseHelper] insertReminder:model];
            }
            [self registerLocalNotification:_clock withID:model.rId];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)registerLocalNotification:(NSDate*)date withID:(NSInteger) notifyID{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = date;
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    // 通知内容
    notification.alertBody =  @"you have one reminder.";
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSString *stringInt = [NSString stringWithFormat:@"%d",notifyID];
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:stringInt forKey:@"wuyuan"];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSDayCalendarUnit;
    }
    //获取系统所有本地通知
 NSArray*arr =  [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    UILocalNotification *tempNotify;
    for(UILocalNotification *notify in arr)
    {
        if ([[notify.userInfo objectForKey:@"wuyuan"]isEqualToString:stringInt]) {
            tempNotify = notify;
            break;
        }
    
    }
    //取消通知
    [[UIApplication sharedApplication] cancelLocalNotification:tempNotify];

    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)setupAlarmDate:(NSDate*)date
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        
        notification.fireDate= date;
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber=1; //应用的红色数字
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        notification.alertBody=@"通知内容";//提示信息 弹出提示框
        notification.alertAction = @"打开";  //提示框按钮
        //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        //NSDictionary*infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        //notification.userInfo = infoDict; //添加额外的信息
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(void)didSelectDetail:(BaseModel*)model
{
    _mainModel = model;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    
    return YES;
}
//完成闹铃设置 设置闹铃
-(void)didSelectTime:(NSDate *) date{
    
    _clock = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日(EEEE)  HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:_clock];
    [_showLabel setText: dateString];
    NSLog(@"showlabel is: %@", _showLabel);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
