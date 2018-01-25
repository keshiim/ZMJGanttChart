//
//  NSDictionary+WBGAdd.m
//  WBGNetworkingDemo
//
//  Created by LiMing on 16/7/6.
//  Copyright © 2016年 LiMing. All rights reserved.
//

#import "NSDictionary+WBGAdd.h"
#import "NSArray+WBGAddition.h"

#define KeyType id

@implementation NSDictionary (WBGAdd)

+ (id)getObjectFromDictionary:(NSDictionary*)dict path:(NSString*) path default:(id)defaultValue
{
    if(dict==nil||path==nil)
        return defaultValue;
    
    NSRange range = [path rangeOfString:@"/"];
    NSString* parentKey = range.length==0 ? path : [path substringToIndex:range.location];
    NSString* subkey = range.length==0 ? nil : [path substringFromIndex:(range.location+1)];
    
    if (range.location == 0) {  // path为"/report"样式
        return [[self class] getObjectFromDictionary:dict path:subkey default:defaultValue];
    }
    
    id obj = nil ;
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        obj = [dict objectForKey:parentKey];
    } else if ([dict isKindOfClass:[NSArray class]]) {
        NSArray* ary = (NSArray*) dict ;
        int index = [parentKey intValue];
        
        if (ary.count > index && index >= 0)
            obj = [ary objectAtIndex:index];
    } else {
        NSLog(@"NSDictionary+WBGAdd: 数据解析出错!!!");
    }
    
    if (range.length==0 || obj==nil) {
        return obj==nil ? defaultValue : obj ;
    }
    
    return [[self class] getObjectFromDictionary:obj path:subkey default:defaultValue];
}

+ (nullable NSDate *)_wbg_toDate:(id)value default:(nullable NSDate *)def
{
    if (value==nil) {
        return def;
    } else if (
               [value respondsToSelector:@selector(longLongValue)]
               // [value isKindOfClass:[NSString class]] ||
               // [value isKindOfClass:[NSNumber class]]
               ) {
        long long longlong = [value longLongValue];
        if (longlong == 0) {
            return def;
        }
        return [NSDate dateWithTimeIntervalSince1970:longlong / 1000];
    } else if ([value isKindOfClass:[NSDate class]]) {
        return value;
    } else {
        return def;
    }
}

- (nullable NSDictionary *)dictionaryValueForKey:(nonnull NSString *)key default:(nullable NSDictionary *)def
{
    return [self valueForKey:key ofKind:[NSDictionary class] default:def];
}

- (nullable NSArray *)arrayValueForKey:(nonnull NSString *)key default:(nullable NSArray *)def
{
    return [self valueForKey:key ofKind:[NSArray class] default:def];
}

- (nullable NSDate *)dateValueForKey:(NSString *)key default:(nullable NSDate *)def
{
    return [self.class _wbg_toDate:[self valueForKey:key ofKind:nil default:def]
                           default:def];
}
- (NSString *)stringValueForKey:(NSString *)key default:(NSString *)def {
    if (!key) return def;
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSString class]]) return value;
    if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value).description;
    return def;
}


- (id)blockValueForKey:(NSString *)key default:(id)def
{
    id block = [self valueForKey:key ofKind:nil default:nil];
    if ([block isKindOfClass:NSClassFromString(@"NSBlock")]) {
        return block;
    } else {
        return def;
    }
}

- (nullable id)valueForKey:(NSString *)key ofKind:(nullable Class)kind default:(nullable id)def
{
    if (!key) {
        return def;
    }
    
    id value = self[key];
    if ([value isKindOfClass:kind] || kind == nil) {
        return value;
    } else {
        return def;
    }
}

static NSNumber *__NSNumberFromID_wbg(id value) {
    static NSCharacterSet *dot;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
    });
    if (!value || value == [NSNull null]) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSString *lower = ((NSString *)value).lowercaseString;
        if ([lower isEqualToString:@"true"] || [lower isEqualToString:@"yes"]) return @(YES);
        if ([lower isEqualToString:@"false"] || [lower isEqualToString:@"no"]) return @(NO);
        if ([lower isEqualToString:@"nil"] || [lower isEqualToString:@"null"]) return nil;
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            return @(((NSString *)value).doubleValue);
        } else {
            return @(((NSString *)value).longLongValue);
        }
    }
    return nil;
}

#define RETURN_VALUE(_type_)                                                            \
id value = [[self class] getObjectFromDictionary:self path:path default:[NSNull null]]; \
if (!value || value == [NSNull null]) return def;                                       \
if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value)._type_;          \
if ([value isKindOfClass:[NSString class]]) return __NSNumberFromID_wbg(value)._type_;  \
return def;

- (BOOL)boolValueForPath:(NSString *)path default:(BOOL)def {
    RETURN_VALUE(boolValue);
}

- (char)charValueForPath:(NSString *)path default:(char)def {
    RETURN_VALUE(charValue);
}

- (unsigned char)unsignedCharValueForPath:(NSString *)path default:(unsigned char)def {
    RETURN_VALUE(unsignedCharValue);
}

- (short)shortValueForPath:(NSString *)path default:(short)def {
    RETURN_VALUE(shortValue);
}

- (unsigned short)unsignedShortValueForPath:(NSString *)path default:(unsigned short)def {
    RETURN_VALUE(unsignedShortValue);
}

- (int)intValueForPath:(NSString *)path default:(int)def {
    RETURN_VALUE(intValue);
}

- (unsigned int)unsignedIntValueForPath:(NSString *)path default:(unsigned int)def {
    RETURN_VALUE(unsignedIntValue);
}

- (long)longValueForPath:(NSString *)path default:(long)def {
    RETURN_VALUE(longValue);
}

- (unsigned long)unsignedLongValueForPath:(NSString *)path default:(unsigned long)def {
    RETURN_VALUE(unsignedLongValue);
}

- (long long)longLongValueForPath:(NSString *)path default:(long long)def {
    RETURN_VALUE(longLongValue);
}

- (unsigned long long)unsignedLongLongValueForPath:(NSString *)path default:(unsigned long long)def {
    RETURN_VALUE(unsignedLongLongValue);
}

- (float)floatValueForPath:(NSString *)path default:(float)def {
    RETURN_VALUE(floatValue);
}

- (double)doubleValueForPath:(NSString *)path default:(double)def {
    RETURN_VALUE(doubleValue);
}

- (NSInteger)integerValueForPath:(NSString *)path default:(NSInteger)def {
    RETURN_VALUE(integerValue);
}

- (NSUInteger)unsignedIntegerValueForPath:(NSString *)path default:(NSUInteger)def {
    RETURN_VALUE(unsignedIntegerValue);
}

- (NSNumber *)numberValueForPath:(NSString *)path default:(NSNumber *)def {
    id value = [[self class] getObjectFromDictionary:self path:path default:[NSNull null]];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) return __NSNumberFromID_wbg(value);
    return def;
}

- (NSString *)stringValueForPath:(NSString *)path default:(NSString *)def {
    id value = [[self class] getObjectFromDictionary:self path:path default:[NSNull null]];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSString class]]) return value;
    if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value).description;
    return def;
}

- (nullable NSDictionary *)dictionaryValueForPath:(NSString *)path default:(nullable NSDictionary *)def{
    NSDictionary* value = [[self class] getObjectFromDictionary:self path:path default:[NSNull null]];
    if (value==nil || ![value isKindOfClass:[NSDictionary class]]) return def;
    return value ;
}

- (nullable NSArray *)arrayValueForPath:(NSString *)path default:(nullable NSArray *)def{
    NSArray* value = [[self class] getObjectFromDictionary:self path:path default:[NSNull null]];
    if (value==nil || ![value isKindOfClass:[NSArray class]]) return def;
    return value ;
}

- (nullable NSDate *)dateValueForPath:(NSString *)path default:(nullable NSDate *)def {
    id value = [[self class] getObjectFromDictionary:self path:path default:[NSNull null]];
    return [self.class _wbg_toDate:value default:def];
}

- (nullable id)blockValueForPath:(NSString *)path default:(nullable id)def;
{
    id value = [[self class] getObjectFromDictionary:self path:path default:[NSNull null]];
    return [value isKindOfClass:NSClassFromString(@"NSBlock")] ? value : def;
}

- (nonnull NSDictionary *)dictionaryValueForPath:(NSString *)path
{
    return [self dictionaryValueForPath:path default:@{}];
}
- (nonnull NSArray *)arrayValueForPath:(NSString *)path
{
    return [self arrayValueForPath:path default:@[]];
}
- (nonnull NSString *)stringValueForPath:(NSString *)path
{
    return [self stringValueForPath:path default:@""];
}
- (nonnull NSDictionary *)dictionaryValueForKey:(NSString *)key
{
    return [self dictionaryValueForKey:key default:@{}];
}
- (nonnull NSArray *)arrayValueForKey:(NSString *)key
{
    return [self arrayValueForKey:key default:@[]];
}
- (nonnull NSString *)stringValueForKey:(NSString *)key
{
    return [self stringValueForKey:key default:@""];
}


# pragma mark - Array Like

- (NSDictionary *)wbg_map:(void (^)(id _Nonnull, id _Nonnull, WBGDictionaryReturnBlock _Nonnull))block
{
    if (!block) {
        return @{};
    }
    
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        block(key, obj, ^(id _key, id _obj){
            [m_dic setSafeObject:_obj forKey:_key];
        });
    }];
    return m_dic;
}

- (NSDictionary *)wbg_filter:(BOOL (^)(id _Nonnull, id _Nonnull))block
{
    if (!block) {
        return @{};
    }
    
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        !block(key, obj) ?: [m_dic setObject:obj forKey:key];
    }];
    return m_dic;
}

+ (NSDictionary *)wbg_forIn:(NSInteger)count block:(void (^)(NSInteger, WBGDictionaryReturnBlock _Nonnull))block
{
    if (!block) {
        return @{};
    }
    
    NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithCapacity:MIN(count, 1000)];
    for (NSInteger ii = 0; ii < count; ii++) {
        block(ii, ^(id key, id obj) {
            [m_dic setSafeObject:obj forKey:key];
        });
    }
    return m_dic;
}

- (NSArray<id> *)wbg_toArray:(id  _Nonnull (^)(id _Nonnull, id _Nonnull))block
{
    return [[self allKeys] wbg_map:^id _Nullable(id  _Nonnull stuff) {
        return block(stuff, self[stuff]);
    }];
}

- (NSDictionary *)wbg_dictionaryBySettingObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    NSMutableDictionary *m_dic = self.mutableCopy;
    [m_dic setSafeObject:anObject forKey:aKey];
    return m_dic;
}

- (NSDictionary *)wbg_dictionaryByRemovingNSNull
{
    return [self wbg_filter:^BOOL(id  _Nonnull key, id  _Nonnull obj) {
        return key != [NSNull null] && obj != [NSNull null];
    }];
}

@end

@implementation NSMutableDictionary (WBGAdd)

- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (!anObject || !aKey || (anObject == [NSNull null])
        || (aKey == [NSNull null])) {
        return;
    }
    [self setObject:anObject forKey:aKey];
}

- (void)setSafeInteger:(NSInteger)integer forKey:(id<NSCopying>)aKey defaultValue:(NSInteger)defaultValue {
    if (integer == defaultValue) { return; }
    
    [self setObject:@(integer).stringValue forKey:aKey];
}

- (void)setSafeDate:(NSDate *)date forKey:(KeyType)aKey;
{
    if (![date isKindOfClass:[NSDate class]] || !aKey) {
        return;
    }
    
    [self setObject:[NSString stringWithFormat:@"%.0f000",date.timeIntervalSince1970] forKey:aKey];
}

- (void)setDouble:(double)aDouble precision:(NSUInteger)precision forKey:(KeyType)aKey;
{
    NSString *format = [NSString stringWithFormat:@"%%.%@f", @(precision)];
    [self setSafeObject:[NSString stringWithFormat:format, aDouble] forKey:aKey];
}

@end
