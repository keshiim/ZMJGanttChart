
//
//  ReuseQueue.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/19.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "ReuseQueue.h"
@interface ReuseQueue<__covariant Reusable> ()
@property (nonatomic, strong) NSMutableSet<Reusable> *reusableObjects;
@end

@implementation ReuseQueue

- (void)dequeue {
    
}

@end
