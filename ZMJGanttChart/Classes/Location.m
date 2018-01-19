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

- (NSUInteger)hash {
    return 32768 * _row * _column;
}

- (BOOL)isEqual:(Location *)object {
    return self.row == object.row && self.column == object.column;
}

@end
