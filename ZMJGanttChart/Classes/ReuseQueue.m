
//
//  ReuseQueue.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/19.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "ReuseQueue.h"
#import "Address.h"

@interface ReuseQueue<__covariant Reusable> ()
@property (nonatomic, strong) NSMutableOrderedSet<Reusable> *reusableObjects;
@end

@implementation ReuseQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        _reusableObjects = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

- (void)enqueue:(id)reusableObject {
    [self.reusableObjects addObject:reusableObject];
}

- (id)dequeue {
    id result = nil;
    if ((result = self.reusableObjects.firstObject)) {
        [self.reusableObjects removeObjectAtIndex:0];
    }
    return result;
}

- (id)dequeueOrCreate {
    id result = nil;
    if ((result = self.reusableObjects.firstObject)) {
        [self.reusableObjects removeObjectAtIndex:0];
    }
    return result ?: [NSObject new];
}

@end

@interface ReusableCollection<__covariant Reusable>()
@property (nonatomic, strong) NSMutableDictionary<Address *, id> *pairs;
@property (nonatomic, strong) NSMutableOrderedSet<Address *>     *addresses;
@end

@implementation ReusableCollection

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pairs = [NSMutableDictionary dictionary];
        _addresses = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

- (BOOL)contains:(Address *)member {
    return [self.addresses containsObject:member];
}

- (void)insert:(Address *)newMember {
    [self.addresses addObject:newMember];
}

- (void)substract:(NSOrderedSet<Address *> *)other {
    [self.addresses minusOrderedSet:other];
}

- (id)objectForKeyedSubscript:(Address *)key {
    return self.pairs[key];
}
- (void)setObject:(id)obj forKeyedSubscript:(Address *)key {
    self.pairs[key] = obj;
}

@end
