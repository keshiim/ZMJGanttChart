//
//  ZMJLayoutEngine.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <Foundation/Foundation.h>
@class ZMJCellRange;
@class Location;

#pragma mark - Defines
struct ZMJDirect {
    CGFloat left;
    CGFloat right;
    CGFloat top;
    CGFloat bottom;
};
typedef struct ZMJDirect Direct;

struct ZMJRectEdge {
    //top || bottom
    Direct top;
    Direct bottom;
    
    //left || right
    Direct left;
    Direct right;
};
typedef struct ZMJRectEdge RectEdge;

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

#pragma mark - Class interface
@interface ZMJLayoutEngine : NSObject

@end

@interface ZMJLayoutProperties: NSObject
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) NSInteger frozenColumns;
@property (nonatomic, assign) NSInteger frozenRows;

@property (nonatomic, assign) CGFloat frozenColumnWidth;
@property (nonatomic, assign) CGFloat frozenRowHeight;
@property (nonatomic, assign) CGFloat columnWidth;
@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnWidthCache; //number -> CGFloat
@property (nonatomic, strong) NSMutableArray<NSNumber *> *rowHeightCache;   //number -> CGFloat

@property (nonatomic, strong) NSMutableArray<ZMJCellRange *> *mergedCells;
@property (nonatomic, strong) NSMutableDictionary<Location *, ZMJCellRange *> *mergedCellLayouts;

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
                      mergedCellLayouts:(NSDictionary<Location *, ZMJCellRange *> *)mergedCellLayouts;
@end
