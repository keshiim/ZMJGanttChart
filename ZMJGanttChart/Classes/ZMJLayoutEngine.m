//
//  ZMJLayoutEngine.m
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import "ZMJLayoutEngine.h"
#import "ZMJCellRange.h"

typedef NS_ENUM(NSInteger, RectEdge) {
    top,
    bottom,
    left,
    right,
};

struct ZMJLayoutAttributes {
    NSInteger startColumn;
    NSInteger startRow;
    NSInteger numberOfColumns;
    NSInteger numberOfRows;
    NSInteger columnCount;
    NSInteger rowCount;
    CGPoint insets;
};
typedef struct ZMJLayoutAttributes LayoutAttributes;

struct ZMJGridLayout {
    CGFloat gridWidth;
    __unsafe_unretained UIColor* gridColor;
    CGPoint origin;
    CGFloat length;
    RectEdge edge;
    CGFloat priority;
};
typedef struct ZMJGridLayout GridLayout;



@implementation ZMJLayoutEngine

- (instancetype)initWithNumberOfColumns:(NSInteger)NumberOfColumns
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
                      mergedCellLayouts:(NSArray<ZMJCellRange *> *)mergedCellLayouts
{
    
}

@end
