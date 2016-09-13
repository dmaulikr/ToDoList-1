//
//  ViewController1.m
//  Done
//
//  Created by yuan.wu on 8/22/16.
//  Copyright © 2016 yuan.wu. All rights reserved.
//

#import "ViewController1.h"
#import "NewReminderViewController.h"
#import "FMDBHelper.h"

@interface ViewController1 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic) NSMutableArray *marray;



@end

@implementation ViewController1
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _marray = [[FMDBHelper sharedDataBaseHelper] queryReminderwithCompletedStatus:NO];
    NSLog(@"_marray:%@",_marray);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(2.5, 0, 370, 400) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setRowHeight:50.0];
    [self.view addSubview:_tableView];
    //_tableView.UITableViewCellAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [_tableView setBackgroundColor:[UIColor clearColor]];
}

//# delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_marray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    BaseModel *model = [_marray objectAtIndex:indexPath.row];
    [[cell textLabel] setText:model.title];
//     [[cell textLabel] setText:(( BaseModel *)[_marray objectAtIndex:indexPath.row]).title];   这种方法一样
    return cell;
}

//// 左滑删除
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        //1.更新数据
        BaseModel *model = [_marray objectAtIndex:indexPath.row];
        [[FMDBHelper sharedDataBaseHelper] deleteReminder:model.rId];
        [_marray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor redColor];
    
    //添加一个置顶按钮
    UITableViewRowAction *topRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        //1.更新数据
        BaseModel *model = [_marray objectAtIndex:indexPath.row];
        NSLog(@"MODEL.rId is :%d", model.rId);
        [[FMDBHelper sharedDataBaseHelper] updateIsTopped:model.rId];
        NSArray *arr = [[FMDBHelper sharedDataBaseHelper] queryReminderwithCompletedStatus:NO];
        _marray = [arr mutableCopy];
        [_tableView reloadData];
    }];
    
    
    //置顶按钮颜色
    topRowAction.backgroundColor = [UIColor colorWithRed:88.0/255 green:141.0/255 blue:233.0/255 alpha:0.8];
    
    UITableViewRowAction *finishAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"完成" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了完成");
        //1.更新数据
        BaseModel *model = [_marray objectAtIndex:indexPath.row];
        model.isCompleted = YES;
        [[FMDBHelper sharedDataBaseHelper] updateCompleteStatus:model withStatus:model.isCompleted];
        
        //2.更新UI
        NSArray *arr = [[FMDBHelper sharedDataBaseHelper] queryReminderwithCompletedStatus:NO];
        _marray = [arr mutableCopy];
        _marray = [NSMutableArray arrayWithArray:arr];
        [_tableView reloadData];
    }];
    //完成按钮颜色
    finishAction.backgroundColor = [UIColor colorWithRed:73.0/255 green:248.0/255 blue:126.0/255 alpha:0.8];
    return @[deleteAction,topRowAction, finishAction];
}

// reload data when viewDidAppear / viewWillAppear
-(void) viewWillAppear:(BOOL)animated
{
    NSArray *arr = [[FMDBHelper sharedDataBaseHelper] queryReminderwithCompletedStatus:NO];
    _marray = [arr mutableCopy];
    [_tableView reloadData];
    
}

// 选择某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel *model = [_marray objectAtIndex:indexPath.row];
    NewReminderViewController *vc = [[NewReminderViewController alloc] init];
    [self setDelegate:vc];
    [_delegate didSelectDetail:model];
    NSLog(@"select detail 的flag: %d ", model.flag);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
