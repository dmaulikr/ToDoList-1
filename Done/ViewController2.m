//
//  ViewConroller2.m
//  Done
//
//  Created by yuan.wu on 8/22/16.
//  Copyright © 2016 yuan.wu. All rights reserved.
//

#import "ViewController2.h"
#import "FMDBHelper.h"
#import "NewReminderViewController.h"
@interface ViewController2 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation ViewController2
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _dataSource = [[FMDBHelper sharedDataBaseHelper] queryReminderwithClock];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(2.5, 0, 370, 400) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setRowHeight:50.0];
    [self.view addSubview:_tableView];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    BaseModel *model = [_dataSource objectAtIndex:indexPath.row];
    [[cell textLabel] setText:model.title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel *model = [_dataSource objectAtIndex:indexPath.row];
    NewReminderViewController *vc = [[NewReminderViewController alloc] init];
    [self setDelegate:vc];
    [_delegate didSelectDetail:model];
    NSLog(@"select detail 的flag: %d ", model.flag);
    [self.navigationController pushViewController:vc animated:YES];
}

//// 左滑删除
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        //1.更新数据
        BaseModel *model = [_dataSource objectAtIndex:indexPath.row];
        [[FMDBHelper sharedDataBaseHelper] deleteReminder:model.rId];
        [_dataSource removeObjectAtIndex:indexPath.row];
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
        [_dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        //2.更新UI
        NSIndexPath *firstIndexPath =[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }];
    //置顶按钮颜色
    topRowAction.backgroundColor = [UIColor colorWithRed:88.0/255 green:141.0/255 blue:233.0/255 alpha:0.8];
    
    UITableViewRowAction *finishAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"完成" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了完成");
        //1.更新数据
        BaseModel *model = [_dataSource objectAtIndex:indexPath.row];
        model.isCompleted = YES;
        [[FMDBHelper sharedDataBaseHelper] updateCompleteStatus:model withStatus:model.isCompleted];
        
        //2.更新UI
        NSArray *arr = [[FMDBHelper sharedDataBaseHelper] queryReminderwithCompletedStatus:NO];
        _dataSource = [arr mutableCopy];
//        _dataSource = [NSMutableArray arrayWithArray:arr];
        [_tableView reloadData];
    }];
    //置顶按钮颜色
    finishAction.backgroundColor = [UIColor colorWithRed:73.0/255 green:248.0/255 blue:126.0/255 alpha:0.8];
    return @[deleteAction,topRowAction, finishAction];
}

-(void)viewWillAppear:(BOOL)animated
{
    _dataSource = [[FMDBHelper sharedDataBaseHelper] queryReminderwithClock];
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
