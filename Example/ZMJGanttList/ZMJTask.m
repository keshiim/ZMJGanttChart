//
//  ZMJTask.m
//  ZMJGanttList
//
//  Created by Jason on 2018/2/27.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import "ZMJTask.h"

@implementation ZMJTask
+ (instancetype)taskWithName:(NSString *)taskName startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    ZMJTask *task = [self new];
    task.taskName  = taskName;
    task.startDate = startDate;
    task.dueDate   = endDate;
    return task;
}
@end
