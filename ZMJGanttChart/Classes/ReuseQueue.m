
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

@property (nonatomic, strong) NSArray<id> *array;
@end

@implementation ReusableCollection
{
    NSRecursiveLock *_lock;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = [NSRecursiveLock new];
        
        _pairs = [NSMutableDictionary dictionary];
        _addresses = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

- (NSArray<id> *)array {
    return self.addresses.array;
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

#pragma mark - NSFastEnumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable [_Nonnull])buffer count:(NSUInteger)len {
//    LOCK(NSUInteger count = [_pairs countByEnumeratingWithState:state objects:stackbuf count:len]);
    LOCK(NSUInteger count = [_pairs countByEnumeratingWithState:state objects:buffer count:len]);
    return count;
}

- (NSEnumerator *)objectEnumerator {
    LOCK(NSEnumerator * e = [_pairs objectEnumerator]); return e;
}

@end
