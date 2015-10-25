//
//  ListTableViewController.m
//  CoreDataTest
//
//  Created by ding on 15/10/14.
//  Copyright (c) 2015年 aoyolo.com. All rights reserved.
//

#import "ListTableViewController.h"
#import <CoreData/CoreData.h>
#import "User.h"
#import "DBManager.h"
@interface ListTableViewController ()<NSFetchedResultsControllerDelegate>
//定义查询结果控制器属性
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    DBManager *manager=[DBManager shareDBManager];
    //排序方式
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"age" ascending:NO];
    NSArray *array=[NSArray arrayWithObjects:sort, nil];
    //创建查询结果控制器并斌值
    self.fetchedResultsController=[manager getFetchedResultsControllerWithEntityName:@"User" sorts:array predicate:nil];
    self.fetchedResultsController.delegate=self;
    NSError *error=nil;
    //这里执行查询
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"error is %@",[error userInfo]);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//表格填充数据源的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.fetchedResultsController.fetchedObjects.count;
}
//创建表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentify" forIndexPath:indexPath];
    //获取User
    User *user=[self.fetchedResultsController objectAtIndexPath:indexPath];
    UIImageView *imgV=(UIImageView *)[cell viewWithTag:100];
    imgV.image=[UIImage imageWithData:user.headerImg];
    UILabel *lb=(UILabel *)[cell viewWithTag:101];
    lb.text=[NSString stringWithFormat:@"用户ID:%@,用户名:%@,年龄:%@",user.userId,user.name,user.age];
    return cell;
}
// 表格支持编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
//表格编辑操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        User *user=[self.fetchedResultsController objectAtIndexPath:indexPath];
        [[DBManager shareDBManager] deleteManagerObj:user];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark -NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}
@end
