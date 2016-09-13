//
//  ViewController3.m
//  Done
//
//  Created by yuan.wu on 8/22/16.
//  Copyright © 2016 yuan.wu. All rights reserved.
//

#import "ViewController3.h"
#import "FMDBHelper.h"
#import "NewReminderViewController.h"
@interface ViewController3 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSArray *arr = [[FMDBHelper sharedDataBaseHelper] queryReminderwithCompletedStatus:YES];
    _dataSource = [arr mutableCopy];
    NSLog(@"_datasource data is:%@",_dataSource);
    
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
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    _dataSource = [[FMDBHelper sharedDataBaseHelper] queryReminderwithCompletedStatus:YES];
    [_tableView reloadData];
    
}

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
    return @[deleteAction];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
