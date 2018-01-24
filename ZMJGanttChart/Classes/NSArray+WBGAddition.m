//
//  NSArray+WBGAddition.m
//  Trader
//
//  Created by Mingfei Huang on 1/23/16.
//
//

#import "NSArray+WBGAddition.h"

#define ObjectType id

@implementation NSArray (WBGAddition)

# pragma mark - MAP
- (NSArray *)wbg_map:(id (^)(id rawStuff))block {
    return [self wbg_mapWithIndex:^id _Nullable(id  _Nonnull stuff, NSUInteger index) {
        return block ? block(stuff) : nil;
    }];
}

- (NSArray *)wbg_mapWithIndex:(id  _Nullable (^)(id _Nonnull, NSUInteger))block {
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull rawStuff, NSUInteger idx, BOOL * _Nonnull stop) {
        id cookedStuff = block ? block(rawStuff, idx) : nil;
        if (cookedStuff) { [marr addObject:cookedStuff]; }
    }];
    return marr.copy;
}

+ (NSArray *)wbg_map:(NSArray *)array
             inBlock:(id __nullable (^)(id stuff))block {
    if (!array) { return @[]; }
    return [array wbg_map:block];
}

+ (NSArray *)wbg_mapWithIndex:(NSArray *)array
                      inBlock:(id __nullable (^)(id stuff,
                                                 NSUInteger index))block {
    if (!array) { return @[]; }
    return [array wbg_mapWithIndex:block];
}

- (NSArray *)wbg_multiMap:(void (^)(id stuff, WBGMultiMapReturn returnBlock))block
{
    return [self wbg_multiMapWithIndex:^(id  _Nonnull stuff, WBGMultiMapReturn  _Nonnull returnBlock, NSUInteger index) {
        !block ?: block(stuff, returnBlock);
    }];
}

- (NSArray *)wbg_multiMapWithIndex:(void (^)(id stuff, WBGMultiMapReturn returnBlock,
                                             NSUInteger index))block
{
    NSMutableArray *marr = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !block ?:
        block(obj, ^(id returnedStuff) {
            if (returnedStuff) {
                [marr addObject:returnedStuff];
            }
        }, idx);
    }];
    
    return [NSArray arrayWithArray:marr];
}


# pragma mark - Filter
- (NSArray *)wbg_filter:(BOOL (^)(id))block {
    return [self wbg_filterWithIndex:^BOOL(id  _Nonnull stuff, NSUInteger index) {
        return block && block(stuff);
    }];
}

- (NSArray *)wbg_filterWithIndex:(BOOL (^)(id _Nonnull, NSUInteger))block {
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull rawStuff, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block && block(rawStuff, idx)) { [marr addObject:rawStuff]; }
    }];
    return marr.copy;
}

+ (NSArray<id> *)wbg_filter:(NSArray<id> *)array
                    inBlock:(BOOL (^)(id stuff))block {
    if (!array) { return @[]; }
    return [array wbg_filter:block];
}

+ (NSArray<id> *)wbg_filterWithIndex:(NSArray<id> *)array
                             inBlock:(BOOL (^)(id stuff,
                                               NSUInteger index))block {
    if (!array) { return @[]; }
    return [array wbg_filterWithIndex:block];
}


# pragma mark - Reject

- (NSArray *)wbg_reject:(BOOL (^)(id))block {
    return [self wbg_rejectWithIndex:^BOOL(id  _Nonnull stuff, NSUInteger index) {
        return block && block(stuff);
    }];
}

- (NSArray *)wbg_rejectWithIndex:(BOOL (^)(id _Nonnull, NSUInteger))block {
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull rawStuff, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!block || !block(rawStuff, idx)) { [marr addObject:rawStuff]; }
    }];
    return marr.copy;
}

+ (NSArray<id> *)wbg_reject:(NSArray<id> *)array
                    inBlock:(BOOL (^)(id stuff))block {
    if (!array) { return @[]; }
    return [array wbg_reject:block];
}

+ (NSArray<id> *)wbg_rejectWithIndex:(NSArray<id> *)array
                             inBlock:(BOOL (^)(id stuff,
                                               NSUInteger index))block {
    if (!array) { return @[]; }
    return [array wbg_rejectWithIndex:block];
}

# pragma mark - Reduce

- (id)wbg_reduce:(id)first with:(id (^)(id prev, ObjectType curr))block {
    return [self wbg_reduce:first withIndex:^id _Nonnull(id  _Nonnull prev, id  _Nonnull curr, NSUInteger idx) {
        return block ? block(prev, curr) : nil;
    }];
}


- (id)wbg_reduce:(id (^)(id prev, ObjectType curr))block {
    return [self wbg_reduceWithIndex:^id _Nonnull(id  _Nonnull prev, id  _Nonnull curr, NSUInteger idx) {
        return block ? block(prev, curr) : nil;
    }];
}


- (id)wbg_reduce:(id)first withIndex:(id (^)(id prev, ObjectType curr, NSUInteger idx))block {
    __block id prev = first;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        prev = block ? block(prev, obj, idx) : nil;
    }];
    return prev;
}


- (id)wbg_reduceWithIndex:(id (^)(id prev, ObjectType curr, NSUInteger idx))block; {
    return [self wbg_reduce:nil withIndex:block];
}

- (CGFloat)wbg_reduceCGFloat:(CGFloat)first with:(CGFloat (^)(CGFloat prev, ObjectType curr))block {
    
    CGFloat(^CGFloatValue)(NSNumber *number) = ^CGFloat(NSNumber *number) {
        if (![number isKindOfClass:[NSNumber class]]) {
            return 0.0;
        }
#if (CGFLOAT_IS_DOUBLE == 1)
        return (CGFloat)[number doubleValue];
#else
        return (CGFloat)[number floatValue];
#endif
    };
    
    return CGFloatValue([self wbg_reduce:@(first) with:^id _Nonnull(id  _Nullable prev, id  _Nonnull curr) {
        return block ? @(block(CGFloatValue(prev), curr)) : nil;
    }]);
}

- (CGFloat)wbg_reduceDouble:(double)first with:(double (^)(double prev, ObjectType curr))block;
{
    double(^DoubleValue)(NSNumber *number) = ^double(NSNumber *number) {
        return (double)([number isKindOfClass:[NSNumber class]] ? number.doubleValue : 0.0);
    };
    
    return DoubleValue([self wbg_reduce:@(first) with:^id _Nonnull(id  _Nullable prev, id  _Nonnull curr) {
        return block ? @(block(DoubleValue(prev), curr)) : nil;
    }]);
}

- (CGFloat)wbg_reduceNSInteger:(NSInteger)first with:(NSInteger (^)(NSInteger prev, ObjectType curr))block {
    NSInteger(^NSIntegerValue)(NSNumber *number) = ^(NSNumber *number) {
        return [number isKindOfClass:[NSNumber class]] ? [number integerValue] : 0;
    };
    
    return NSIntegerValue([self wbg_reduce:@(first) with:^id _Nonnull(id  _Nullable prev, id  _Nonnull curr) {
        return block ? @(block(NSIntegerValue(prev), curr)) : nil;
    }]);
}

# pragma mark -

- (void)wbg_apply:(void (^)(id _Nonnull))block
{
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !block ?: block(obj);
    }];
}


- (id)wbg_queryFirst:(BOOL (^)(id _Nonnull))block
{
    return [self wbg_queryFirstWithIndex:^BOOL(id  _Nonnull stuff, NSUInteger index) {
        return block && block(stuff);
    }];
}

- (id)wbg_queryFirstWithIndex:(BOOL (^)(id _Nonnull, NSUInteger))block
{
    __block id first;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block && block(obj, idx)) {
            first = obj;
            *stop = YES;
        }
    }];
    return first;
}

- (NSUInteger)wbg_indexOf:(BOOL (^)(id _Nonnull))block
{
    __block NSUInteger daIndex = NSNotFound;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block && block(obj)) {
            daIndex = idx;
            *stop = YES;
        }
    }];
    return daIndex;
}

- (id)wbg_queryLast:(BOOL (^)(id _Nonnull))block
{
    return [self wbg_queryLastWithIndex:^BOOL(id  _Nonnull stuff, NSUInteger index) {
        return block && block(stuff);
    }];
}

- (id)wbg_queryLastWithIndex:(BOOL (^)(id _Nonnull, NSUInteger))block
{
    __block id last;
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block && block(obj, idx)) {
            last = obj;
            *stop = YES;
        }
    }];
    return last;
}

# pragma mark - Any

- (BOOL)wbg_any:(BOOL (^)(id _Nonnull))block
{
    return [self wbg_anyWithIndex:^BOOL(id  _Nonnull stuff, NSUInteger index) {
        return block && block(stuff);
    }];
}

- (BOOL)wbg_anyWithIndex:(BOOL (^)(id _Nonnull, NSUInteger))block
{
    __block BOOL any = NO;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block && block(obj, idx)) {
            any = YES;
            *stop = YES;
        }
    }];
    return any;
}

# pragma mark - All

- (BOOL)wbg_all:(BOOL (^)(id _Nonnull))block
{
    return [self wbg_allWithIndex:^BOOL(id  _Nonnull stuff, NSUInteger index) {
        return block && block(stuff);
    }];
}

- (BOOL)wbg_allWithIndex:(BOOL (^)(id _Nonnull, NSUInteger))block
{
    __block BOOL all = YES;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!block || !block(obj, idx)) {
            all = NO;
            *stop = YES;
        }
    }];
    return all;
}

# pragma mark - For In

+ (NSArray *)wbg_forIn:(NSInteger)count block:(id  _Nullable (^)(NSUInteger))block
{
    if (count <= 0) {
        return @[];
    }
    
    return [self wbg_forInRange:NSMakeRange(0, count) block:block];
}

+ (NSArray *)wbg_forInRange:(NSRange)range block:(id __nullable (^)(NSUInteger index))block;
{
    __block NSMutableArray *marr = nil;
    
    for (NSUInteger ii=range.location; ii<range.length; ii++) {
        id stuff = block ? block(ii) : nil;
        if (stuff) {
            if (marr == nil) {
                marr = [NSMutableArray arrayWithCapacity:range.length];
            }
            [marr addObject:stuff];
        }
    }
    return marr.copy ?: @[];
}

# pragma mark - 去重
- (NSArray *)wbg_arrayByRemovingDuplicate;
{
    return [NSOrderedSet orderedSetWithArray:self].array.copy;
}

# pragma mark - Get
- (id)wbg_safeObjectAtIndex:(NSInteger)index
{
    if (index >= self.count) { return nil; }
    return self[index];
}

- (NSArray<ObjectType> *)wbg_getObjectsWithRange:(NSRange)range {
    NSMutableArray *objects = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx>=range.location&&idx<range.location + range.length) {
            [objects addObject:obj];
        }
    }];
    return objects.copy ?: @[];
}

- (nullable ObjectType)wbg_safeObjectAtIndexNumber:(NSNumber *)indexNumber
{
    if (![indexNumber isKindOfClass:[NSNumber class]]) { return nil; }
    return [self wbg_safeObjectAtIndex:indexNumber.integerValue];
}

# pragma mark - Delete

- (NSArray *)wbg_arrayByRemovingObject:(id)object
{
    if (!object) {
        return [NSArray arrayWithArray:self];
    }
    
    NSMutableArray *marr = [NSMutableArray arrayWithArray:self];
    [marr removeObject:object];
    return [NSArray arrayWithArray:marr];
}

- (NSArray<id> *)wbg_arrayByRemovingObjectsFromArray:(NSArray<id> *)array;
{
    if (!array) {
        return [NSArray arrayWithArray:self];
    }
    
    // copy array lower chance of thread issue
    array = [NSArray arrayWithArray:array];
    
    NSMutableArray *marr = [NSMutableArray arrayWithArray:self];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [marr removeObject:obj];
    }];
    return [NSArray arrayWithArray:marr];
}

- (NSArray<ObjectType> *)wbg_arrayByPopFirst
{
    return [self wbg_safeArrayByRemovingObjectAtIndex:0];
}

- (NSArray<ObjectType> *)wbg_arrayByPopLast
{
    return [self wbg_safeArrayByRemovingObjectAtIndex:self.count - 1];
}

- (NSArray *)wbg_safeArrayByRemovingObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) { return self.copy; }
    
    NSMutableArray *marr = self.mutableCopy;
    [marr removeObjectAtIndex:index];
    return marr.copy;
}

# pragma mark - Append
- (NSArray *)wbg_arrayByAddingObject:(id)anObject
{
    if (!anObject) { return [NSArray arrayWithArray:self]; }
    
    return [self arrayByAddingObject:anObject];
}

# pragma mark - Replace
- (NSArray *)wbg_arrayByReplacingObject:(id)object with:(id)newObject {
    
    return [self wbg_map:^id _Nullable(id  _Nonnull stuff) {
        if ([stuff isEqual:object]) {
            return newObject;
        } else {
            return stuff;
        }
    }];
}

- (NSArray *)wbg_arrayByReplacingObjectAtIndex:(NSUInteger)idx with:(id)newObject
{
    return [self wbg_mapWithIndex:^id _Nullable(id  _Nonnull stuff, NSUInteger index) {
        return index == idx ? newObject : stuff;
    }];
}

# pragma mark - Join
- (NSArray *)wbg_arrayByJoiningWithObject:(id)object copyObject:(BOOL)copyObject
{
    return [self wbg_multiMapWithIndex:^(id  _Nonnull stuff, WBGMultiMapReturn  _Nonnull returnBlock, NSUInteger index) {
        
        // object in array
        returnBlock(stuff);
        
        // object to be joined
        if (index < self.count - 1) {
            if (copyObject) {
                returnBlock([object copy]);
            } else {
                returnBlock(object);
            }
        }
    }];
}

# pragma mark - 👾
+ (NSArray *)wbg_arrayByMergingArray:(NSArray *)oneArray withArray:(NSArray *)anotherArray copyItems:(BOOL)copyItems removeDuplicate:(BOOL)removeDuplicate
{
    oneArray     = [[NSArray alloc] initWithArray:oneArray copyItems:copyItems];
    anotherArray = [[NSArray alloc] initWithArray:anotherArray copyItems:copyItems];
    
    NSArray *mergedArray = [oneArray arrayByAddingObjectsFromArray:anotherArray];
    
    if (removeDuplicate) {
        return [mergedArray wbg_arrayByRemovingDuplicate];
    } else {
        return mergedArray;
    }
}

+ (NSArray *)wbg_arrayByMerging:(NSArray *)oneArray, ...
{
    if (!oneArray) {
        return @[];
    }
    
    va_list args;
    va_start(args, oneArray);
    
    NSMutableArray *merged = [NSMutableArray arrayWithArray:[oneArray isKindOfClass:[NSArray class]] ? oneArray : @[]];
    NSArray *next;
    
    while ((next = va_arg(args, NSArray *)))
    {
        if ([next isKindOfClass:[NSArray class]]) {
            [merged addObjectsFromArray:next];
        }
    }
    va_end(args);
    
    return [NSArray arrayWithArray:merged];
}

- (NSArray *)wbg_arrayByMerging:(NSArray *)oneArray, ...
{
    if (!oneArray) {
        return [NSArray arrayWithArray:self];
    }
    
    va_list args;
    va_start(args, oneArray);
    
    NSMutableArray *merged = [NSMutableArray arrayWithArray:self];
    NSArray *next;
    
    [merged addObjectsFromArray:[oneArray isKindOfClass:[NSArray class]] ? oneArray : @[]];
    
    while ((next = va_arg(args, NSArray *)))
    {
        if ([next isKindOfClass:[NSArray class]]) {
            [merged addObjectsFromArray:next];
        }
    }
    va_end(args);
    
    return [NSArray arrayWithArray:merged];
}


# pragma mark - Overlap

- (NSArray<ObjectType> *)wbg_arrayByIntersectingWithArray:(NSArray<ObjectType> *)otherArray;
{
    NSMutableOrderedSet *m_self = [NSMutableOrderedSet orderedSetWithArray:self];
    [m_self intersectSet:[NSSet setWithArray:otherArray]];
    return m_self.array;
}


# pragma mark - Prepend

- (NSArray *)wbg_arrayByPrependingObject:(id)object
{
    if (!object) { return [NSArray arrayWithArray:self]; }
    
    NSMutableArray *marr = [NSMutableArray arrayWithObject:object];
    [marr addObjectsFromArray:self];
    
    return [NSArray arrayWithArray:marr];
}

- (NSArray *)wbg_arrayByPrependingObjectsFromArray:(NSArray<id> *)array
{
    return [array ?: @[] arrayByAddingObjectsFromArray:self];
}

# pragma mark - Reverse
- (NSArray *)wbg_arrayByReverse;
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj];
    }];
    return array;
}

- (NSArray<ObjectType> *)wbg_interSectWithArray:(NSArray<ObjectType> *)otherArray {
    NSMutableSet *oneSet = [NSMutableSet setWithArray:self];
    NSMutableSet *otherSet = [NSMutableSet setWithArray:otherArray];
    [oneSet intersectsSet:otherSet];
    return [oneSet allObjects];
}

- (NSArray<ObjectType> *)wbg_minuWithArray:(NSArray<ObjectType> *)otherArray  {
    NSMutableSet *oneSet = [NSMutableSet setWithArray:self];
    NSMutableSet *otherSet = [NSMutableSet setWithArray:otherArray];
    [oneSet minusSet:otherSet];
    return [otherSet allObjects];
}

@end
