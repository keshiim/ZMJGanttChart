//
//  Address.m
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import "Address.h"

@implementation Address

- (instancetype)init
{
    return [[self.class alloc] initWithRow:0 column:0 rowIndex:0 columnIndex:0];
}

- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex {
    self = [super init];
    if (self) {
        _row = row;
        _column = column;
        _rowIndex = rowIndex;
        _columnIndex = columnIndex;
    }
    return self;
}
+ (instancetype)addressWithRow:(NSInteger)row column:(NSInteger)column rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex {
    return [[self alloc] initWithRow:row column:column rowIndex:rowIndex columnIndex:columnIndex];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    Address *copy = [[Address allocWithZone:zone] init];
    if (copy) {
        copy.row = self.row;
        copy.column = self.column;
        copy.rowIndex = self.rowIndex;
        copy.columnIndex = self.columnIndex;
    }
    return copy;
}

- (NSUInteger)hash {
    return 32768 * _rowIndex + _columnIndex;
}

- (BOOL)isEqual:(Address *)object {
    return [object isKindOfClass:self.class] && self.rowIndex == object.rowIndex && self.columnIndex == object.columnIndex;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@:row=%ld,column=%ld,rowIndex=%ld,columnIndex=%ld",
            NSStringFromClass(self.class),
            (long)_row,
            (long)_column,
            (long)_rowIndex,
            (long)_columnIndex];
}

- (NSString *)description {
    return [self debugDescription];
}

@end
