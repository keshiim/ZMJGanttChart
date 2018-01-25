//
//  NSDictionary+WBGAdd.h
//  WBGNetworkingDemo
//
//  Created by LiMing on 16/7/6.
//  Copyright © 2016年 LiMing. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef WBG_WARN_RESULT_UNUSED
#define WBG_WARN_RESULT_UNUSED __attribute__((warn_unused_result))
#endif

NS_ASSUME_NONNULL_BEGIN

// 1.扩展NSDictionary+YYAdd的方法应用范围
// 2.支持通过多级路径访问NSDictionary中的数值, 如:路径"report/0/id"，表示返回关键字为"report"下的0号位置的"id"字段

@interface NSDictionary<KeyType, ObjectType> (WBGAdd)

typedef void(^WBGDictionaryReturnBlock)(KeyType key, ObjectType obj);

// 扩展YYKit
- (nullable NSDictionary *)dictionaryValueForKey:(NSString *)key default:(nullable NSDictionary *)def;
- (nullable NSArray *)arrayValueForKey:(NSString *)key default:(nullable NSArray *)def;
- (nullable NSDate *)dateValueForKey:(NSString *)key default:(nullable NSDate *)def;
- (nullable id)blockValueForKey:(NSString *)key default:(nullable id)def;

/// match * for kind == nil
- (nullable ObjectType)valueForKey:(NSString *)key ofKind:(nullable Class)kind default:(nullable id)def;

// 多级路径匹配

- (BOOL)boolValueForPath:(NSString *)path default:(BOOL)def;

- (char)charValueForPath:(NSString *)path default:(char)def;
- (unsigned char)unsignedCharValueForPath:(NSString *)path default:(unsigned char)def;

- (short)shortValueForPath:(NSString *)path default:(short)def;
- (unsigned short)unsignedShortValueForPath:(NSString *)path default:(unsigned short)def;

- (int)intValueForPath:(NSString *)path default:(int)def;
- (unsigned int)unsignedIntValueForPath:(NSString *)path default:(unsigned int)def;

- (long)longValueForPath:(NSString *)path default:(long)def;
- (unsigned long)unsignedLongValueForPath:(NSString *)path default:(unsigned long)def;

- (long long)longLongValueForPath:(NSString *)path default:(long long)def;
- (unsigned long long)unsignedLongLongValueForPath:(NSString *)path default:(unsigned long long)def;

- (float)floatValueForPath:(NSString *)path default:(float)def;
- (double)doubleValueForPath:(NSString *)path default:(double)def;

- (NSInteger)integerValueForPath:(NSString *)path default:(NSInteger)def;
- (NSUInteger)unsignedIntegerValueForPath:(NSString *)path default:(NSUInteger)def;

- (nullable NSNumber *)numberValueForPath:(NSString *)path default:(nullable NSNumber *)def;
- (nullable NSString *)stringValueForPath:(NSString *)path default:(nullable NSString *)def;

- (nullable NSDictionary *)dictionaryValueForPath:(NSString *)path default:(nullable NSDictionary *)def;
- (nullable NSArray *)arrayValueForPath:(NSString *)path default:(nullable NSArray *)def;

- (nullable NSDate *)dateValueForPath:(NSString *)path default:(nullable NSDate *)def;
- (nullable id)blockValueForPath:(NSString *)path default:(nullable id)def;

// 缺省默认值
- (nonnull NSDictionary *)dictionaryValueForPath:(NSString *)path;  // 默认值为@{}
- (nonnull NSArray *)arrayValueForPath:(NSString *)path;            // 默认值为@[]
- (nonnull NSString *)stringValueForPath:(NSString *)path;          // 默认值为@""
- (nonnull NSDictionary *)dictionaryValueForKey:(NSString *)key;    // 默认值为@{}
- (nonnull NSArray *)arrayValueForKey:(NSString *)key;              // 默认值为@[]
- (nonnull NSString *)stringValueForKey:(NSString *)key;            // 默认值为@""


# pragma mark - Array Like

- (NSDictionary *)wbg_map:(void (^)(KeyType key, ObjectType obj, WBGDictionaryReturnBlock returnBlock))block WBG_WARN_RESULT_UNUSED;

- (NSDictionary<KeyType, ObjectType> *)wbg_filter:(BOOL (^)(KeyType key, ObjectType obj))block WBG_WARN_RESULT_UNUSED;

+ (NSDictionary<KeyType, ObjectType> *)wbg_forIn:(NSInteger)count block:(void (^)(NSInteger idx, WBGDictionaryReturnBlock returnBlock))block WBG_WARN_RESULT_UNUSED;

/**
 把一个字典map成array

 @param block 用这个block把key和obj加工成要放到数组里的东西
 @return map完了之后的数组
 */
- (NSArray<id> *)wbg_toArray:(id (^)(KeyType key, ObjectType obj))block WBG_WARN_RESULT_UNUSED;

/**
 给一个字典append上一个key value

 @param anObject anObject
 @param aKey aKey
 @return 新append过的字典
 */
- (NSDictionary<KeyType, ObjectType> *)wbg_dictionaryBySettingObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey WBG_WARN_RESULT_UNUSED;

/**
 把字典里所有NSNull都去掉

 @return 新📙
 */
@property (nonatomic, readonly, nonnull) NSDictionary<KeyType, ObjectType> *wbg_dictionaryByRemovingNSNull;

@end

@interface NSMutableDictionary<KeyType, ObjectType> (WBGAdd)

/// If 'anObject' or 'aKey' is nil or NSNull, then ignore this operation
- (void)setSafeObject:(ObjectType)anObject forKey:(KeyType)aKey;

/// If integer == defaultValue, then ignore this operation
/// dict[aKey] = string(integer)
- (void)setSafeInteger:(NSInteger)integer forKey:(KeyType)aKey defaultValue:(NSInteger)defaultValue;

/// use milliseconds as date value
- (void)setSafeDate:(NSDate *)date forKey:(KeyType)aKey;

/**
 设小数

 @param precision 精确到小数点后几位
 */
- (void)setDouble:(double)aDouble precision:(NSUInteger)precision forKey:(KeyType)aKey;

@end

NS_ASSUME_NONNULL_END
