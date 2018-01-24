//
//  NSArray+WBGAddition.h
//  Trader
//
//  Created by Mingfei Huang on 1/23/16.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (WBGAddition)


# pragma mark - Blocks
/**
 *  把一个数组给map成另外一个数组
 *
 *  @param block 输入一个self里的东西 返回一个需要被map成的东西
 *  可以返回nil, 返回nil的话这个东西就像是被过滤掉了
 *
 *  @return 被map成的另外一个array
 */
- (NSArray *)wbg_map:(id __nullable (^)(ObjectType stuff))block __attribute__((warn_unused_result));
- (NSArray *)wbg_mapWithIndex:(id __nullable (^)(ObjectType stuff,
                                                 NSUInteger index))block __attribute__((warn_unused_result));

/// 比[- NSArray wbg_map]安全, array是nil的时候返回@[]
+ (NSArray *)wbg_map:(NSArray<ObjectType> *)array
             inBlock:(id __nullable (^)(ObjectType stuff))block;

/// 比[- NSArray wbg_mapWithIndex]安全, array是nil的时候返回@[]
+ (NSArray *)wbg_mapWithIndex:(NSArray<ObjectType> *)array
                      inBlock:(id __nullable (^)(ObjectType stuff,
                                                 NSUInteger index))block __attribute__((warn_unused_result));

typedef void(^WBGMultiMapReturn)(id __nullable returnedStuff);

/// 和map一样 不过可以把一个对象map成好几个东西 呼叫returnBlock把需要return的东西传过来
- (NSArray *)wbg_multiMap:(void (^)(ObjectType stuff, WBGMultiMapReturn returnBlock))block __attribute__((warn_unused_result));

/// 和map一样 不过可以把一个对象map成好几个东西 呼叫returnBlock把需要return的东西传过来
- (NSArray *)wbg_multiMapWithIndex:(void (^)(ObjectType stuff, WBGMultiMapReturn returnBlock,
                                             NSUInteger index))block __attribute__((warn_unused_result));


/**
 *  把一个数组过滤一下
 *
 *  @param block 顾虑的block  传进来数组里的每个东西 返回no的话这个元素就被过滤掉了
 *
 *  @return 过滤之后的数组
 */
- (NSArray<ObjectType> *)wbg_filter:(BOOL (^)(ObjectType stuff))block __attribute__((warn_unused_result));
- (NSArray<ObjectType> *)wbg_filterWithIndex:(BOOL (^)(ObjectType stuff,
                                                       NSUInteger index))block __attribute__((warn_unused_result));

+ (NSArray<ObjectType> *)wbg_filter:(NSArray<ObjectType> *)array
                            inBlock:(BOOL (^)(ObjectType stuff))block __attribute__((warn_unused_result));

+ (NSArray<ObjectType> *)wbg_filterWithIndex:(NSArray<ObjectType> *)array
                                     inBlock:(BOOL (^)(ObjectType stuff,
                                                       NSUInteger index))block __attribute__((warn_unused_result));


/**
 *  reject是反着的filter
 *
 *  @param block  传进来数组里的每个东西 返回YES的话这个元素就被过滤掉了
 *
 *  @return 过滤之后的数组
 */
- (NSArray<ObjectType> *)wbg_reject:(BOOL (^)(ObjectType stuff))block __attribute__((warn_unused_result));
- (NSArray<ObjectType> *)wbg_rejectWithIndex:(BOOL (^)(ObjectType stuff,
                                                       NSUInteger index))block __attribute__((warn_unused_result));

+ (NSArray<ObjectType> *)wbg_reject:(NSArray<ObjectType> *)array
inBlock:(BOOL (^)(ObjectType stuff))block __attribute__((warn_unused_result));

+ (NSArray<ObjectType> *)wbg_rejectWithIndex:(NSArray<ObjectType> *)array
inBlock:(BOOL (^)(ObjectType stuff,
                  NSUInteger index))block __attribute__((warn_unused_result));


# pragma mark - Reduce
/**
 reduce

 @param first first value to be passed to `prev`
 @param block reduces `prev` and `curr` and returns next prev
 @return last value returned by `block`
 */
- (nullable id)wbg_reduce:(nullable id)first with:(nullable id (^)(_Nullable id prev, ObjectType curr))block __attribute__((warn_unused_result));


/**
 reduce with first value being `nil`

 @param block reduces `prev` and `curr` and returns next prev
 @return last value returned by `block`
 */
- (nullable id)wbg_reduce:(nullable id (^)(_Nullable id prev, ObjectType curr))block __attribute__((warn_unused_result));


/**
 reduce with index
 
 @param first first value to be passed to `prev`
 @param block reduces `prev` and `curr` and returns next prev
 @return last value returned by `block`
 */
- (nullable id)wbg_reduce:(nullable id)first withIndex:(nullable id (^)(_Nullable id prev, ObjectType curr, NSUInteger idx))block __attribute__((warn_unused_result));


/**
 reduce with index
 
 @param block reduces `prev` and `curr` and returns next prev
 @return last value returned by `block`
 */
- (nullable id)wbg_reduceWithIndex:(nullable id (^)(_Nullable id prev, ObjectType curr, NSUInteger idx))block __attribute__((warn_unused_result));

/**
 reduce with CGFloat as type - most commonly reduced type
 */
- (CGFloat)wbg_reduceCGFloat:(CGFloat)first with:(CGFloat (^)(CGFloat prev, ObjectType curr))block;

/**
 reduce with double as type
 */
- (CGFloat)wbg_reduceDouble:(double)first with:(double (^)(double prev, ObjectType curr))block;

/**
 reduce with NSInteger as type
 */
- (CGFloat)wbg_reduceNSInteger:(NSInteger)first with:(NSInteger (^)(NSInteger prev, ObjectType curr))block;

/**
 apply - equivalent to -[NSArray makeObjectsPerformSelector:]

 @param block the block to perform
 */
- (void)wbg_apply:(void (^)(ObjectType stuff))block;

# pragma mark - QueryFirst

/**
 和过滤一个意思 不过只得第一个元素

 @param block 过滤的block  传进来数组里的每个东西 返回no的话这个元素就被过滤掉了 返回yes的话就停了
 @return 过滤得到的第一个东西
 */
- (ObjectType)wbg_queryFirst:(BOOL (^)(ObjectType stuff))block __attribute__((warn_unused_result));
- (ObjectType)wbg_queryFirstWithIndex:(BOOL (^)(ObjectType stuff,
                                                NSUInteger index))block __attribute__((warn_unused_result));

/**
 找第一个满足block的index 找不到的话return NSNotFound
 */
- (NSUInteger)wbg_indexOf:(BOOL (^)(ObjectType stuff))block __attribute__((warn_unused_result));

/**
 和queryFirst一个意思 不过反着搜索

 @param block 过滤的block  传进来数组里的每个东西 返回no的话这个元素就被过滤掉了 返回yes的话就停了
 @return 过滤得到的第一个东西
 */
- (ObjectType)wbg_queryLast:(BOOL (^)(ObjectType stuff))block __attribute__((warn_unused_result));

/**
 带着index的queryLast
 
 @param block 过滤的block  传进来数组里的每个东西 返回no的话这个元素就被过滤掉了 返回yes的话就停了
 @return 过滤得到的第一个东西
 */
- (ObjectType)wbg_queryLastWithIndex:(BOOL (^)(ObjectType stuff,
                                               NSUInteger index))block __attribute__((warn_unused_result));

# pragma mark - Any

/**
 任意一个object符合block
 */
- (BOOL)wbg_any:(BOOL (^)(ObjectType stuff))block __attribute__((warn_unused_result));

/**
 任意一个object符合block
 */
- (BOOL)wbg_anyWithIndex:(BOOL (^)(ObjectType stuff,
                                   NSUInteger index))block __attribute__((warn_unused_result));

# pragma mark - All

/**
 所有object符合block
 */
- (BOOL)wbg_all:(BOOL (^)(ObjectType stuff))block __attribute__((warn_unused_result));

/**
 所有object符合block
 */
- (BOOL)wbg_allWithIndex:(BOOL (^)(ObjectType stuff,
                                   NSUInteger index))block __attribute__((warn_unused_result));


# pragma mark - For..In

/**
 for ii in 0..count: { ... }

 @param count count, returns @[] for count <= 0
 @param block build your stuff in this block, return nullable
 @return the stuffs you built in `block`
 */
+ (NSArray<ObjectType> *)wbg_forIn:(NSInteger)count block:(ObjectType __nullable (^)(NSUInteger index))block /* __attribute__((warn_unused_result)) */;

/// similar to `for ii in range: ...`
+ (NSArray<ObjectType> *)wbg_forInRange:(NSRange)range block:(ObjectType __nullable (^)(NSUInteger index))block __attribute__((warn_unused_result));


# pragma mark - 去重
- (NSArray<ObjectType> *)wbg_arrayByRemovingDuplicate __attribute__((warn_unused_result));

# pragma mark - Get
- (nullable ObjectType)wbg_safeObjectAtIndex:(NSInteger)index __attribute__((warn_unused_result));
- (NSArray<ObjectType> *)wbg_getObjectsWithRange:(NSRange)range __attribute__((warn_unused_result));
/**
 *  @param indexNumber index作为NSNumber, 取integerValue. 不是NSNumber返回nil
 */
- (nullable ObjectType)wbg_safeObjectAtIndexNumber:(NSNumber *)indexNumber __attribute__((warn_unused_result));

# pragma mark - Delete
- (NSArray<ObjectType> *)wbg_arrayByRemovingObject:(ObjectType)object __attribute__((warn_unused_result));
- (NSArray<ObjectType> *)wbg_arrayByRemovingObjectsFromArray:(NSArray<ObjectType> *)array __attribute__((warn_unused_result));
- (NSArray<ObjectType> *)wbg_arrayByPopFirst __attribute__((warn_unused_result));
- (NSArray<ObjectType> *)wbg_arrayByPopLast __attribute__((warn_unused_result));

- (NSArray<ObjectType> *)wbg_safeArrayByRemovingObjectAtIndex:(NSUInteger)index __attribute__((warn_unused_result));

# pragma mark - Append
- (NSArray<ObjectType> *)wbg_arrayByAddingObject:(ObjectType)anObject __attribute__((warn_unused_result));

# pragma mark - Replace
- (NSArray<ObjectType> *)wbg_arrayByReplacingObject:(ObjectType)object with:(ObjectType)newObject __attribute__((warn_unused_result));
- (NSArray<ObjectType> *)wbg_arrayByReplacingObjectAtIndex:(NSUInteger)idx with:(ObjectType)newObject __attribute__((warn_unused_result));

# pragma mark - Join

/**
 效果参考-[NSArray componentsJoinedByString:]
 */
- (NSArray *)wbg_arrayByJoiningWithObject:(id)object copyObject:(BOOL)copyObject __attribute__((warn_unused_result));

# pragma mark - Merge
+ (NSArray<ObjectType> *)wbg_arrayByMergingArray:(NSArray<ObjectType> *)oneArray withArray:(NSArray<ObjectType> *)anotherArray copyItems:(BOOL)copyItems removeDuplicate:(BOOL)removeDuplicate __attribute__((warn_unused_result));


/**
 merge many arrays
 
 @note this method does not copy items in array, and does not remove duplicate
 @note this method simply skips non nill but non NSArray typed objects in argument list
 
 @param oneArray an array to be merged
 @return merged array
 */
+ (NSArray<ObjectType> *)wbg_arrayByMerging:(NSArray<ObjectType> *)oneArray, ... NS_REQUIRES_NIL_TERMINATION __attribute__((warn_unused_result));


/**
 merge self with many arrays
 
 @note this method does not copy items in array, and does not remove duplicate
 @note this method simply skips non nill but non NSArray typed objects in argument list
 
 @param oneArray the first array to be merged
 @return merged array
 */
- (NSArray<ObjectType> *)wbg_arrayByMerging:(NSArray<ObjectType> *)oneArray, ... NS_REQUIRES_NIL_TERMINATION __attribute__((warn_unused_result));


# pragma mark - Set Like Operations

/**
 @return [item for item in self if item in otherArray]
 */
- (NSArray<ObjectType> *)wbg_arrayByIntersectingWithArray:(NSArray<ObjectType> *)otherArray;

# pragma mark - Prepend
- (NSArray *)wbg_arrayByPrependingObject:(id)object __attribute__((warn_unused_result));

- (NSArray *)wbg_arrayByPrependingObjectsFromArray:(NSArray<id> *)array __attribute__((warn_unused_result));

# pragma mark - Reverse
- (NSArray<ObjectType> *)wbg_arrayByReverse;



/**
 求两个同类型数组的交集

 @param otherArray 另一数组
 @return 交集数组
 */
- (NSArray<ObjectType> *)wbg_interSectWithArray:(NSArray<ObjectType> *)otherArray ;



/**
 求两个数组的差集

 @param otherArray 另一数组
 @return 差集数组
 */
- (NSArray<ObjectType> *)wbg_minuWithArray:(NSArray<ObjectType> *)otherArray ;

@end

NS_ASSUME_NONNULL_END
