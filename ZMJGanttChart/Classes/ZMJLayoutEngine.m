//
//  ZMJLayoutEngine.m
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import "ZMJLayoutEngine.h"
#import "ZMJCellRange.h"
#import "Location.h"

@implementation ZMJLayoutEngine

@end

@implementation ZMJLayoutProperties

- (instancetype)init
{
    self = [super init];
    if (self) {
        _numberOfColumns = 0;
        _numberOfRows    = 0;
        _frozenColumns   = 0;
        _frozenRows      = 0;
        
        _frozenColumnWidth = 0.f;
        _frozenRowHeight   = 0.f;
        _columnWidth       = 0.f;
        _rowHeight         = 0.f;
        
        _columnWidthCache = [NSMutableArray new];
        _rowHeightCache   = [NSMutableArray new];
        
        _mergedCells      = [NSMutableArray new];
        _mergedCellLayouts= [NSMutableDictionary new];
    }
    return self;
}

- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
                           numberOfRows:(NSInteger)numberOfRows
                          frozenColumns:(NSInteger)frozenColumns
                             frozenRows:(NSInteger)frozenRows
                      frozenColumnWidth:(CGFloat)frozenColumnWidth
                        frozenRowHeight:(CGFloat)frozenRowHeight
                            columnWidth:(CGFloat)columnWidth
                              rowHeight:(CGFloat)rowHeight
                       columnWidthCache:(NSArray<NSNumber *> *)columnWidthCache
                         rowHeightCache:(NSArray<NSNumber *> *)rowHeightCache
                            mergedCells:(NSArray<ZMJCellRange *> *)mergedCells
                      mergedCellLayouts:(NSDictionary<Location *, ZMJCellRange *> *)mergedCellLayouts
{
    self = [super init];
    if (self) {
        self.numberOfColumns = numberOfColumns;
        self.numberOfRows    = numberOfRows;
        self.frozenColumns   = frozenColumns;
        self.frozenRows      = frozenRows;
        
        self.frozenColumnWidth = frozenColumnWidth;
        self.frozenRowHeight   = frozenRowHeight;
        self.columnWidth  = columnWidth;
        self.rowHeight    = rowHeight;
        self.columnWidthCache = columnWidthCache.mutableCopy;
        self.rowHeightCache   = rowHeightCache.mutableCopy;
        
        self.mergedCells      = mergedCells.mutableCopy;
        self.mergedCellLayouts= mergedCellLayouts.mutableCopy;
    }
    return self;
}

@end
