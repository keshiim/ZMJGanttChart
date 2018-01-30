//
//  ZMJCellRange.m
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import "ZMJCellRange.h"
#import "NSIndexPath+column.h"

@interface ZMJCellRange ()
@property (nonatomic, strong) Location *from;
@property (nonatomic, strong) Location *to;

@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) NSInteger rowCount;
@end

@implementation ZMJCellRange

+ (instancetype)cellRangeFrom:(Location *)from to:(Location *)to {
    return [[self alloc] initFromLocation:from toLocation:to];
}

- (instancetype)initFromRow:(NSInteger)fromRow fromColumn:(NSInteger)fromColumn toRow:(NSInteger)toRow toColumn:(NSInteger)toColumn {
    return [self initFromLocation:[Location locationWithRow:fromRow column:fromColumn]
                       toLocation:[Location locationWithRow:toRow column:toColumn]];
}
- (instancetype)initFromIndex:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    return [self initFromLocation:[Location locationWithRow:fromIndexPath.row column:fromIndexPath.column]
                       toLocation:[Location locationWithRow:toIndexPath.row column:toIndexPath.column]];
}
- (instancetype)initFromLocation:(Location *)fromLocation toLocation:(Location *)toLocation {
    self = [super init];
    if (self) {
        NSAssert(fromLocation.column <= toLocation.column && fromLocation.row <= toLocation.row, @"the value of `from` must be less than or equal to the value of `to`");
        self.from = fromLocation;
        self.to   = toLocation;
        _columnCount = toLocation.column - fromLocation.column + 1;
        _rowCount    = toLocation.row - fromLocation.row + 1;
    }
    return self;
}

- (BOOL)containsIndexPath:(NSIndexPath *)indexPath {
    return
    self.from.column <= indexPath.column &&
    self.to.column >= indexPath.column &&
    self.from.row <= indexPath.row &&
    self.to.row >= indexPath.row;
}
- (BOOL)containsCellRange:(ZMJCellRange *)cellRange {
    return
    self.from.column <= cellRange.from.column &&
    self.to.column >= cellRange.to.column &&
    self.from.row <= cellRange.from.row &&
    self.to.row >= cellRange.to.row;
}

- (NSUInteger)hash {
    return self.from.hash;
}
- (BOOL)isEqual:(ZMJCellRange *)object {
    return [object isKindOfClass:self.class] && [self.from isEqual:object.from];
}

- (NSString *)description {
    return [self debugDescription];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"R%ldC%ld:R%ldC%ld", (long)self.from.row, (long)self.from.column, (long)self.to.row, (long)self.to.column];;
}

@end
