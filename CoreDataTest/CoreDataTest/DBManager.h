//
//  DBManager.h
//  CoreDataTest
//
//  Created by ding on 15/10/14.
//  Copyright (c) 2015年 aoyolo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface DBManager : NSObject
//管理对象模型
@property(nonatomic,copy)NSManagedObjectModel *managedObjectModel;
//管理对象上下文
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;
//持久性存储助理
@property(nonatomic,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;
+(DBManager *)shareDBManager;
/**
 *  插入数据或更新数据
 *
 */
- (BOOL)excuteInsertOrUpdateManagedObj:(NSManagedObject *)object;
/**
 *  删除一个对象
 *
 *  @param object 要操作的对象
 */
-(void)deleteManagerObj:(NSManagedObject *)object;
/**
 *  查找数据
 *
 *  @param name      实体名字
 *  @param predicate 查询条件
 *
 *  @return 返回查到的数据
 */
- (NSArray *)excuteQueryWithEntityName:(NSString *)name
                             predicate:(NSPredicate *)predicate;
/**
 *  查询符合条件的数据的条数
 *
 *  @param name      实体名字
 *  @param predicate 查询条件
 *
 *  @return 返回符合条件的数据的条数
 */
-(NSUInteger)excuteQueryCountWithEntityName:(NSString *)name predicates:(NSPredicate *)predicate;

/**
 *  返回NSFetchedResultsController用于表格中
 *
 *  @param name      实体名字
 *  @param array     排序条件
 *  @param predicate 查询条件
 *
 *  @return NSFetchedResultsController
 */
-(NSFetchedResultsController *)getFetchedResultsControllerWithEntityName:(NSString *)name sorts:(NSArray *)array predicate:(NSPredicate *)predicate;

@end
