//
//  AlarmClock.m
//  
//
//  Created by yuan.wu on 8/26/16.
//
//

#import "AlarmClockViewController.h"
#import <Masonry.h>
@interface AlarmClockViewController()
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong)  NSDate*  date;

@end


@implementation AlarmClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _datePicker = [[UIDatePicker alloc] init];
    [_datePicker setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:_datePicker];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        //with is an optional semantic filler
        make.bottom.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.size.mas_equalTo( CGSizeMake(375, 400));
    }];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    _showLabel = [[UILabel alloc] init];
    [_showLabel setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [_showLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_showLabel];
    [_showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //with is an optional semantic filler
        make.top.equalTo(self.view).offset(70);
        make.right.equalTo(self.view).offset(0);
        make.size.mas_equalTo( CGSizeMake(375, 30));
    }];
    
    _date = [_datePicker date];
    NSLog(@"local._date = %@date", _date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日(EEEE)  HH:mm:ss"];   //设置日期格式的string格式
    NSString *dateString = [formatter stringFromDate:_date];   // 把data格式换成string格式
    [_showLabel setText: dateString];
    
    _button1 = [[UIButton alloc] init];
    [_button1.layer setCornerRadius:5.0];
    [_button1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [_button1 setTitle:@"确定" forState: UIControlStateNormal];
    [_button1 setTag:1];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button1];
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //with is an optional semantic filler
        make.top.equalTo(_showLabel).offset(65);
        make.right.equalTo(_showLabel).offset(-100);
        make.size.mas_equalTo( CGSizeMake(60, 30));
    }];
    
    _button2 = [[UIButton alloc] init];
    [_button2.layer setCornerRadius:5.0];
    [_button2 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [_button2 setTitle:@"取消" forState: UIControlStateNormal];
    [_button2 setTag:0];
    [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button2 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button2];

    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //with is an optional semantic filler
        make.top.equalTo(_showLabel).offset(65);
        make.left.equalTo(_showLabel).offset(100);
        make.size.mas_equalTo( CGSizeMake(60, 30));
    }];
    // Do any additional setup after loading the view.
}

-(void)clicked:(UIButton *) sender
{
    if (sender.tag == 0) {  //cancel
        [self.navigationController popViewControllerAnimated:YES];
    } else {   //submit
        [_delegate didSelectTime:_date];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) dateChanged:(id)sender
{
    UIDatePicker *control = sender;
    _date = control.date;
//    NSLog(@"picker._date = %@date", _date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日(EEEE)  HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:_date];
    [_showLabel setText: dateString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end