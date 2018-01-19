//
//  ZMJCellRange.m
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import "ZMJCellRange.h"

@interface ZMJCellRange
@property (nonatomic, strong, readonly) Location *from;
@property (nonatomic, strong, readonly) Location *to;

@property (nonatomic, assign, readonly) NSInteger columnCount;
@property (nonatomic, assign, readonly) NSInteger rowCount;
@end

@implementation ZMJCellRange
- (instancetype)initFromRow:(NSInteger)fromRow fromColumn:(NSInteger)fromColumn toRow:(NSInteger)toRow toColumn:(NSInteger)toColumn {
    
}
- (instancetype)initFromIndex:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
}
- (instancetype)initFromLocation:(Location *)fromLocation toLocation:(Location *)toLocation {
    self = [super init];
    if (self) {
        self.from = fromLocation;
        self.to   = toLocation;
        _columnCount = toLocation.column - fromLocation.column + 1;
        _rowCount    = toLocation.row - fromLocation.row + 1;
    }
    return self;
}

@end
