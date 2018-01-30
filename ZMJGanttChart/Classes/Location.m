//
//  Location.m
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import "Location.h"
#import "NSIndexPath+column.h"

@implementation Location
- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column {
    self = [super init];
    if (self) {
        _row = row;
        _column = column;
    }
    return self;
}

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath {
    return [self initWithRow:indexPath.row column:indexPath.column];
}

+ (instancetype)locationWithRow:(NSInteger)row column:(NSInteger)column {
    return [[self alloc] initWithRow:row column:column];
}

+ (instancetype)indexPath:(NSIndexPath *)indexPath {
    return [[self alloc] initWithIndexPath:indexPath];
}

- (NSUInteger)hash {
    return 32768 * _row * _column;
}

- (BOOL)isEqual:(Location *)object {
    return [object isKindOfClass:self.class] && self.row == object.row && self.column == object.column;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    Location *copy = [Location allocWithZone:zone];
    if (copy) {
        copy.row     = self.row;
        copy.column  = self.column;
    }
    return copy;
}

- (NSString *)description {
    return [self debugDescription];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"row:%ld | column:%ld", (long)_row, (long)_column];
}

@end
