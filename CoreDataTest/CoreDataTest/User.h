//
//  User.h
//  CoreDataTest
//
//  Created by ding on 15/10/14.
//  Copyright (c) 2015年 aoyolo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSData * headerImg;
@property (nonatomic, retain) NSNumber * userId;

@end
