//
//  ReuseQueue.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/19.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Address;

@interface ReuseQueue<__covariant Reusable> : NSObject
- (void)enqueue:(Reusable)reusableObject;
- (Reusable)dequeue;
- (Reusable)dequeueOrCreate;
@end

@interface ReusableCollection<__covariant Reusable> : NSObject

- (BOOL)contains:(Address *)member;
- (void)insert:(Address *)newMember;
- (void)substract:(NSOrderedSet<Address *> *)other;

- (Reusable)objectForKeyedSubscript:(Address *)key;
- (void)setObject:(Reusable)obj forKeyedSubscript:(Address *)key;
@end
