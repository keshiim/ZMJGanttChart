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
    self = [super init];
    if (self) {
        _row = 0;
        _column = 0;
        _rowIndex = 0;
        _columnIndex = 0;
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    Address *copy = [Address allocWithZone:zone];
    copy.row = self.row;
    copy.column = self.column;
    copy.rowIndex = self.rowIndex;
    copy.columnIndex = self.columnIndex;
    return copy;
}

- (NSUInteger)hash {
    return 32768 * _rowIndex + _columnIndex;
}

- (BOOL)isEqual:(Address *)object {
    return self.rowIndex == object.rowIndex && self.columnIndex == object.columnIndex;
}

@end
