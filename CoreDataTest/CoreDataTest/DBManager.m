//
//  DBManager.m
//  CoreDataTest
//
//  Created by ding on 15/10/14.
//  Copyright (c) 2015年 aoyolo.com. All rights reserved.
//

#import "DBManager.h"
static DBManager *dbManager;
@implementation DBManager
//单例
+(DBManager *)shareDBManager
{
    @synchronized(self){
        if (dbManager==nil) {
            dbManager=[[self alloc] init];
        }
    }
    return dbManager;
}
//确保该类只创建一个对象
+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self){
        if (dbManager==nil) {
            dbManager=[super allocWithZone:zone];
        }
    }
    return dbManager;
}
-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectContext!=nil) {
        return _managedObjectModel;
    }
    _managedObjectModel=[[NSManagedObjectModel mergedModelFromBundles:nil] copy];
    return _managedObjectModel;
}
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator  ;
    }
    NSString *docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *storeURL=[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"CoreData.sqlite"]];
//    NSLog(@"storeURL is %@",storeURL);
    NSError *error=nil;
    _persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    //为了支持自动升级
    NSDictionary *options=[NSDictionary dictionaryWithObjectsAndKeys:@(YES),NSMigratePersistentStoresAutomaticallyOption,@(YES),NSInferMappingModelAutomaticallyOption, nil];
    //增加持续性存储类型
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Error: %@",[error description]);
    }
    return _persistentStoreCoordinator;
}

-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext!=nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator=[self persistentStoreCoordinator];
    if (coordinator!=nil) {
        //创建管理对象上下文
        _managedObjectContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (BOOL)excuteInsertOrUpdateManagedObj:(NSManagedObject *)object
{
    return [self saveObject];
}
-(void)deleteManagerObj:(NSManagedObject *)object
{
    [_managedObjectContext deleteObject:object];
    if([self saveObject]){
        NSLog(@"单个删除成功");
    }
}
-(BOOL)saveObject
{
    NSError* error;
    //保存操作
    BOOL isSaveSuccess=[self.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }
    return isSaveSuccess;
}

- (NSArray *)excuteQueryWithEntityName:(NSString *)name
                             predicate:(NSPredicate *)predicate
{
    NSError *error;
    NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:name];
    [fetch setPredicate:predicate];
    NSArray *array=[self.managedObjectContext executeFetchRequest:fetch error:&error];
    return array;
}
-(NSUInteger)excuteQueryCountWithEntityName:(NSString *)name predicates:(NSPredicate *)predicate
{
    NSError *error;
    NSFetchRequest *fetch=[[NSFetchRequest alloc] initWithEntityName:name];
    [fetch setPredicate:predicate];
    return [self.managedObjectContext countForFetchRequest:fetch error:&error];
}
-(NSFetchedResultsController *)getFetchedResultsControllerWithEntityName:(NSString *)name sorts:(NSArray *)array predicate:(NSPredicate *)predicate
{
    //查询对象
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:name];
    //设置排序
    [fetchRequest setSortDescriptors:array];
    //设置查询条件
    [fetchRequest setPredicate:predicate];
    //创建查询控制器可与tableView配合使用
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:nil];
    return theFetchedResultsController;
}
@end
