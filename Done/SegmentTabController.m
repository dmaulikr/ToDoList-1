//
//  SegmentTabController.m
//  Done
//
//  Created by yuan.wu on 8/22/16.
//  Copyright © 2016 yuan.wu. All rights reserved.
//

#import "SegmentTabController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import <Masonry.h>
#import "NewReminderViewController.h"
@implementation SegmentTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewControllers];
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(30, 47, screenSize.width - 60, 50)
        contentViewFrame:CGRectMake(0, 84, screenSize.width, screenSize.height - 64 - 50)];
    
    self.tabBar.itemTitleColor = [UIColor colorWithRed:68.0/255 green:134.0/255 blue:248.0/255 alpha:0.8];
    self.tabBar.itemTitleSelectedColor = [UIColor whiteColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemSelectedBgColor = [UIColor colorWithRed:42.0/255 green:139.0/255 blue:213.0/255 alpha:1];
    self.tabBar.layer.cornerRadius = 8;
    self.tabBar.layer.borderWidth = 2;
    self.tabBar.layer.borderColor = [UIColor colorWithRed:46.0/255 green:141.0/255 blue:214.0/255 alpha:0.7].CGColor;
    [self.tabBar setItemSeparatorColor:[UIColor colorWithRed:46.0/255 green:141.0/255 blue:214.0/255 alpha:0.7]width:1 marginTop:0 marginBottom:0];
    
    
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setImage:[UIImage imageNamed:@"addButton3"] forState:UIControlStateNormal];
    button.layer.cornerRadius = 60;
    [button setFrame:CGRectMake(157, 590, 60, 60)];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
   
    
    self.tabBar.badgeTitleFont = [UIFont systemFontOfSize:10];
    [self.tabBar setNumberBadgeMarginTop:2
                       centerMarginRight:25
                     titleHorizonalSpace:10
                      titleVerticalSpace:4];
    
    [self.tabBar setDotBadgeMarginTop:5
                    centerMarginRight:15
                           sideLength:8];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 self.navigationController.navigationBarHidden  = YES;

}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden  = NO;
}

-(void)clicked:(UIButton*) sender
{
    NewReminderViewController * vc = [[NewReminderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViewControllers {
    ViewController1 *controller1 = [[ViewController1 alloc] init];
    controller1.yp_tabItemTitle = @"待办事项";
    ViewController2 *controller2 = [[ViewController2 alloc] init];
    controller2.yp_tabItemTitle = @"待提醒事项";
    ViewController3 *controller3 = [[ViewController3 alloc] init];
    controller3.yp_tabItemTitle = @"完成事件";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, nil];
}


@end
