//
//  ZMJLayoutEngine.m
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import "ZMJLayoutEngine.h"
#import "ZMJCellRange.h"
#import "Location.h"
#import "NSIndexPath+column.h"
#import "Gridlines.h"
#import "CircualrScrolling.h"
#import "Address.h"
#import "SpreadsheetView.h"
#import "SpreadsheetView+Layout.h"

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

@interface ZMJLayoutEngine ()
@property (nonatomic, strong) SpreadsheetView *spreadsheetView;
@property (nonatomic, strong) ZMJScrollView   *scrollView;

@property (nonatomic, assign) CGSize     intercellSpacing;
@property (nonatomic, strong) GridStyle *defaultGridStyle;
@property (nonatomic, strong) Options   *circularScrollingOptions;
@property (nonatomic, copy  ) NSString  *blankCellReuseIdentifier;
@property (nonatomic, strong) NSSet<NSIndexPath *> *highlightedIndexPaths;
@property (nonatomic, strong) NSSet<NSIndexPath *> *selectedIndexPaths;

@property (nonatomic, assign) NSInteger frozenColumns;
@property (nonatomic, assign) NSInteger frozenRows;

/// NSNumber who wrapper of <CGFloat>
@property (nonatomic, strong) NSArray<NSNumber *> *columnWidthCache;
@property (nonatomic, strong) NSArray<NSNumber *> *rowHeightCache;

@property (nonatomic, assign) CGRect visibleRect;
@property (nonatomic, assign) CGPoint cellOrigin;

@property (nonatomic, assign) NSInteger startColumn;
@property (nonatomic, assign) NSInteger startRow;
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) CGPoint   insets;

/// NSNumber who wrapper of <CGFloat>
@property (nonatomic, strong) NSArray<NSNumber *> *columnRecords;
@property (nonatomic, strong) NSArray<NSNumber *> *rowRecords;

@property (nonatomic, strong) NSMutableOrderedSet<Address *>            *mergedCellAddress;
@property (nonatomic, strong) NSMutableDictionary<Address *, NSValue *> *mergedCellRects;  /// NSValue who wrapper of <CGRect>

@property (nonatomic, strong) NSMutableOrderedSet<Address *> *visibleCellAddresses;

@property (nonatomic, strong) NSMutableDictionary<Address *, ZMJGridLayout *> *horizontalGridLayouts; /// NSValue who wrapper of <GridLayout>
@property (nonatomic, strong) NSMutableDictionary<Address *, ZMJGridLayout *> *verticalGridLayouts;   /// NSValue who wrapper of <GridLayout>

@property (nonatomic, strong) NSMutableOrderedSet<Address *> *visibleHorizontalGridAddresses;
@property (nonatomic, strong) NSMutableOrderedSet<Address *> *visibleVerticalGridAddresses;
@property (nonatomic, strong) NSMutableOrderedSet<Address *> *visibleBorderAddresses;
@end

@implementation ZMJLayoutEngine
- (instancetype)initWithSpreadsheetView:(SpreadsheetView *)spreadsheetView scrollView:(ZMJScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.spreadsheetView = spreadsheetView;
        self.scrollView = scrollView;
        
        self.intercellSpacing = spreadsheetView.intercellSpacing;
        self.defaultGridStyle = spreadsheetView.gridStyle;
        self.circularScrollingOptions = spreadsheetView.circularScrollingOptions;
        self.blankCellReuseIdentifier = spreadsheetView.blankCellReuseIdentifier;
        self.highlightedIndexPaths    = spreadsheetView.highlightedIndexPaths.set;
        self.selectedIndexPaths       = spreadsheetView.selectedIndexPaths.set;
        
        self.frozenColumns = spreadsheetView.layoutProperties.frozenColumns;
        self.frozenRows    = spreadsheetView.layoutProperties.frozenRows;
        self.columnWidthCache = spreadsheetView.layoutProperties.columnWidthCache.copy;
        self.rowHeightCache   = spreadsheetView.layoutProperties.rowHeightCache.copy;
        
        self.visibleRect = CGRectMake(scrollView.state.contentOffset.x,
                                      scrollView.state.contentOffset.y,
                                      scrollView.state.frame.size.width,
                                      scrollView.state.frame.size.height);
        self.cellOrigin = CGPointZero;
        
        self.startColumn     = scrollView.layoutAttributes.startColumn;
        self.startRow        = scrollView.layoutAttributes.startRow;
        self.numberOfColumns = scrollView.layoutAttributes.numberOfColumns;
        self.numberOfRows    = scrollView.layoutAttributes.numberOfRows;
        self.columnCount     = scrollView.layoutAttributes.columnCount;
        self.rowCount        = scrollView.layoutAttributes.rowCount;
        self.insets          = scrollView.layoutAttributes.insets;
    
        self.columnRecords = scrollView.columnRecords;
        self.rowRecords    = scrollView.rowRecords;
    }
    return self;
}

+ (instancetype)spreadsheetView:(SpreadsheetView *)spreadsheetView scrollView:(ZMJScrollView *)scrollView {
    return [[self alloc] initWithSpreadsheetView:spreadsheetView scrollView:scrollView];
}

- (void)layout {
    if (_startColumn == _columnCount || _startRow == _rowCount) {
        return;
    }
    NSInteger startRowIndex = [self.spreadsheetView findIndex:self.scrollView.rowRecords offset:self.visibleRect.origin.y - self.insets.y];
    CGPoint cellOrigin = self.cellOrigin;
    cellOrigin.y = self.insets.y + self.scrollView.rowRecords[startRowIndex].floatValue + self.intercellSpacing.height;
    self.cellOrigin = cellOrigin;
    
    for (NSInteger rowIndex = startRowIndex+self.startRow; rowIndex < self.rowCount; rowIndex++) {
        NSInteger row = rowIndex % self.numberOfRows;
        if ((self.circularScrollingOptions.tableStyle & TableStyle_rowHeaderNotRepeated) &&
            self.startRow > 0 &&
            row < self.frozenRows)
        {
            continue;
        }
        BOOL stop = [self enumerateColumns:row rowIndex:rowIndex];
        if (stop) { break; }
        
        CGPoint cellOrigin = self.cellOrigin;
        cellOrigin.y += self.rowHeightCache[row].floatValue + self.intercellSpacing.height;
        self.cellOrigin = cellOrigin;
    }
    
    [self renderMergedCells];
    [self renderVerticalGridlines];
    [self renderHorizontalGridlines];
    [self renderBorders];
    [self returnReusableResouces];
}

#pragma mark - Private Method
- (BOOL)enumerateColumns:(NSInteger)row rowIndex:(NSInteger)rowIndex {
    NSInteger startColumnIndex = [self.spreadsheetView findIndex:self.columnRecords offset:self.visibleRect.origin.x - self.insets.x];
    CGPoint cellOrigin = self.cellOrigin;
    cellOrigin.x = self.insets.x + self.columnRecords[startColumnIndex].floatValue + self.intercellSpacing.width;
    
    __block NSInteger columnIndex = startColumnIndex + self.startColumn;
    while (columnIndex < self.columnCount) {
        NSInteger columnStep = 1;
        void (^defer)(void) = ^(void) {
            columnIndex += columnStep;
        };
        
        NSInteger column = columnIndex % self.numberOfColumns;
        if ((self.circularScrollingOptions.tableStyle & TableStyle_columnHeaderNotRepeated) &&
            self.startColumn > 0 &&
            column < self.frozenColumns)
        {
            continue;
        }
        
        CGFloat columnWidth = self.columnWidthCache[column].floatValue;
        ZMJCellRange *mergedCell = [self.spreadsheetView mergedCellFor:[Location locationWithRow:row column:column]];
        if (mergedCell) {
            CGFloat cellWidth = 0;
            CGFloat cellHeight = 0;
            CGSize cellSize = mergedCell.size;
            if (!CGSizeEqualToSize(cellSize, CGSizeZero)) {
                cellWidth = cellSize.width;
                cellHeight= cellSize.height;
            } else {
                for (NSInteger column = mergedCell.from.column; column <=  mergedCell.to.column; column++) {
                    cellWidth += self.columnWidthCache[column].floatValue + self.intercellSpacing.width;
                }
                for (NSInteger row = mergedCell.from.row; row <= mergedCell.to.row; row++) {
                    cellHeight += self.rowHeightCache[row].floatValue + self.intercellSpacing.height;
                }
            }
            
            columnStep += (mergedCell.columnCount - (column - mergedCell.from.column)) - 1;
            Address *address = [Address addressWithRow:mergedCell.from.row
                                                column:mergedCell.from.column
                                              rowIndex:rowIndex - (row - mergedCell.from.row)
                                           columnIndex:columnIndex - (column - mergedCell.from.column)];
            
            if (column < self.columnRecords.count) {
                CGFloat offsetWidth = self.columnRecords[column - self.startColumn].floatValue - self.columnRecords[mergedCell.from.column - self.startColumn].floatValue;
                CGPoint cellOrigin = self.cellOrigin;
                cellOrigin.x -= offsetWidth;
                self.cellOrigin = cellOrigin;
            } else {
                NSInteger fromColumn = mergedCell.from.column;
                NSInteger endColumn  = self.columnRecords.count - 1;
                
                CGFloat offsetWidth = self.columnRecords.count - 1;
                for (NSInteger c = endColumn; c < column; c++) {
                    offsetWidth += self.columnWidthCache[c].floatValue + self.intercellSpacing.width;
                }
                if (fromColumn < self.columnRecords.count) {
                    offsetWidth -= self.columnRecords[mergedCell.from.column].floatValue;
                } else {
                    offsetWidth -= self.columnRecords[endColumn].floatValue;
                    for (NSInteger c = endColumn; c < fromColumn; c++) {
                        offsetWidth -= self.columnWidthCache[c].floatValue + self.intercellSpacing.width;
                    }
                }
                CGPoint cellOrigin = self.cellOrigin;
                cellOrigin.x -= offsetWidth;
                self.cellOrigin = cellOrigin;
            }
            if ([self.visibleCellAddresses containsObject:address]) {
                if (self.cellOrigin.x > CGRectGetMaxX(self.visibleRect)) {
                    CGPoint cellOrigin = self.cellOrigin;
                    cellOrigin.x += cellWidth;
                    self.cellOrigin = cellOrigin;
                    return NO;
                }
                if (self.cellOrigin.y > CGRectGetMaxY(self.visibleRect)) {
                    return YES;
                }
                CGPoint cellOrigin = self.cellOrigin;
                cellOrigin.x += cellWidth;
                self.cellOrigin = cellOrigin;
                continue;
            }
            CGFloat offsetHeight = 0;
            if (row < self.rowRecords.count) {
                offsetHeight = self.rowRecords[row - self.startRow].floatValue - self.rowRecords[mergedCell.from.row - self.startRow].floatValue;
            } else {
                NSInteger fromRow = mergedCell.from.row;
                NSInteger endRow  = self.rowRecords.count - 1;
                
                offsetHeight = self.rowRecords[endRow].floatValue;
                for (NSInteger r = endRow; r < row; r++) {
                    offsetHeight += self.rowHeightCache[r].floatValue + self.intercellSpacing.height;
                }
                if (fromRow < self.rowRecords.count) {
                    offsetHeight -= self.rowRecords[fromRow].floatValue;
                } else {
                    offsetHeight -= self.rowHeightCache[endRow].floatValue;
                    for (NSInteger r = endRow; r < fromRow; r++) {
                        offsetHeight -= self.rowHeightCache[r].floatValue + self.intercellSpacing.height;
                    }
                }
            }
            
            if (self.cellOrigin.x + cellWidth - self.intercellSpacing.width <= CGRectGetMinX(self.visibleRect)) {
                CGPoint cellOrigin = self.cellOrigin;
                cellOrigin.x += cellWidth;
                self.cellOrigin = cellOrigin;
                continue;
            }
            if (self.cellOrigin.x > CGRectGetMaxX(self.visibleRect)) {
                CGPoint cellOrigin = self.cellOrigin;
                cellOrigin.x += cellWidth;
                self.cellOrigin = cellOrigin;
                return NO;
            }
            if (self.cellOrigin.y - offsetHeight + cellHeight - self.intercellSpacing.height <= CGRectGetMinY(self.visibleRect)) {
                CGPoint cellOrigin = self.cellOrigin;
                cellOrigin.x += cellWidth;
                self.cellOrigin = cellOrigin;
                continue;
            }
            if (self.cellOrigin.y - offsetHeight > CGRectGetMaxY(self.visibleRect)) {
                return YES;
            }
            
            [self.visibleCellAddresses addObject:address];
            [self.mergedCellAddress addObject:address];
            self.mergedCellRects[address] = [NSValue valueWithCGRect:CGRectMake(self.cellOrigin.x,
                                                                                self.cellOrigin.y - offsetHeight,
                                                                                cellWidth - self.intercellSpacing.width,
                                                                                cellHeight - self.intercellSpacing.height)];
            CGPoint cellOrigin = self.cellOrigin;
            cellOrigin.x += cellWidth;
            self.cellOrigin = cellOrigin;
            continue;
        }
        
        CGFloat rowHeight = self.rowHeightCache[row].floatValue;
        
        if (self.cellOrigin.x + columnWidth <= CGRectGetMinX(self.visibleRect)) {
            CGPoint cellOrigin = self.cellOrigin;
            cellOrigin.x += columnWidth + self.intercellSpacing.width;
            self.cellOrigin = cellOrigin;
            continue;
        }
        if (self.cellOrigin.x > CGRectGetMaxX(self.visibleRect)) {
            CGPoint cellOrigin = self.cellOrigin;
            cellOrigin.x += columnWidth + self.intercellSpacing.width;
            self.cellOrigin = cellOrigin;
            return NO;
        }
        if (self.cellOrigin.y + rowHeight <= CGRectGetMinY(self.visibleRect)) {
            CGPoint cellOrigin = self.cellOrigin;
            cellOrigin.x += columnWidth + self.intercellSpacing.width;
            self.cellOrigin = cellOrigin;
            continue;
        }
        if (self.cellOrigin.y > CGRectGetMaxY(self.visibleRect)) {
            return YES;
        }
        
        Address *address = [Address addressWithRow:row column:column rowIndex:rowIndex columnIndex:columnIndex];
        [self.visibleCellAddresses addObject:address];
        
        CGSize cellSize = CGSizeMake(columnWidth, rowHeight);
        [self layoutCell:address frame:CGRectMake(self.cellOrigin.x,
                                                  self.cellOrigin.y,
                                                  cellSize.width,
                                                  cellSize.height)];
        CGPoint cellOrigin = self.cellOrigin;
        cellOrigin.x += columnWidth + self.intercellSpacing.width;
        self.cellOrigin = cellOrigin;
        
        defer();
    }
    return NO;
}

- (void)layoutCell:(Address *)address frame:(CGRect)frame {
    id<SpreadsheetViewDataSource> dataSource = self.spreadsheetView.dataSource;
    if (dataSource == nil) {
        return;
    }
    
    Gridlines *gridlines = nil;
    Borders   *borders   = nil;

    if ([self.scrollView.visibleCells contains:address]) {
        ZMJCell *cell = [self.scrollView.visibleCells objectForKeyedSubscript:address];
        if (cell) {
            cell.frame = frame;
            gridlines = cell.gridlines;
            borders = cell.borders;
            borders.hasBorders = cell.borders.hasBorders;
        } else {
            gridlines = nil;
            borders = nil;
        }
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathWithRow:address.row column:address.column];
        
        ZMJCell *cell = [dataSource spreadsheetView:self.spreadsheetView cellForItemAt:indexPath] ?: [self.spreadsheetView dequeueReusableCellWithReuseIdentifier:self.blankCellReuseIdentifier forIndexPath:indexPath];
        if (cell.restorationIdentifier == nil) {
            [NSException exceptionWithName:@"" reason:@"the cell returned from `spreadsheetView(_:cellForItemAt:)` does not have a `reuseIdentifier` - cells must be retrieved by calling `dequeueReusableCell(withReuseIdentifier:for:)`" userInfo:nil];
        }
        cell.indexPath = indexPath;
        cell.frame = frame;
        cell.highlighted = [self.highlightedIndexPaths containsObject:indexPath];
        cell.selected    = [self.selectedIndexPaths containsObject:indexPath];
        
        gridlines = cell.gridlines;
        borders   = cell.borders;
        borders.hasBorders = cell.hasBorder;
        
        [self.scrollView insertSubview:cell atIndex:0];
        [self.scrollView.visibleCells setObject:cell forKeyedSubscript:address];
    }
    
    if (borders.hasBorders) {
        [self.visibleBorderAddresses addObject:address];
    }
    if (gridlines) {
        [self layoutGridlines:address frame:frame gridlines:gridlines];
    }
}

- (void)layoutGridlines:(Address *)address frame:(CGRect)frame gridlines:(Gridlines *)gridlines {
    CGFloat topWidth, topPriority;
    UIColor *topColor;
    [self extractGridStyle:gridlines.top outWidth:&topWidth outColor:&topColor outPriority:&topPriority];
    
    CGFloat bottomWidth, bottomPriority;
    UIColor *bottomColor;
    [self extractGridStyle:gridlines.bottom outWidth:&bottomWidth outColor:&bottomColor outPriority:&bottomPriority];
    
    CGFloat leftWidth, leftPriority;
    UIColor *leftColor;
    [self extractGridStyle:gridlines.left outWidth:&leftWidth outColor:&leftColor outPriority:&leftPriority];
    
    CGFloat rightWidth, rightPriority;
    UIColor *rightColor;
    [self extractGridStyle:gridlines.right outWidth:&rightWidth outColor:&rightColor outPriority:&rightPriority];
    
    if (self.horizontalGridLayouts[address]) {
        ZMJGridLayout *gridLayout = self.horizontalGridLayouts[address];
        if (topPriority > gridLayout.priority) {
            self.horizontalGridLayouts[address] = [ZMJGridLayout gridLayoutWithGridWidth:topWidth
                                                                               gridColor:topColor
                                                                                  origin:frame.origin
                                                                                  length:frame.size.width
                                                                                    edge:RectEdgeMake(UIPopoverArrowDirectionUp, 0, leftWidth, 0, rightWidth)
                                                                                priority:topPriority];
        }
    } else {
        self.horizontalGridLayouts[address]    = [ZMJGridLayout gridLayoutWithGridWidth:topWidth
                                                                              gridColor:topColor
                                                                                 origin:frame.origin
                                                                                 length:frame.size.width
                                                                                   edge:RectEdgeMake(UIPopoverArrowDirectionUp, 0, leftWidth, 0, rightWidth)
                                                                               priority:topPriority];
    }
    
    Address *underCellAddress = [Address addressWithRow:address.row + 1
                                                 column:address.column
                                               rowIndex:address.rowIndex + 1
                                            columnIndex:address.columnIndex];
    if (self.horizontalGridLayouts[underCellAddress]) {
        ZMJGridLayout *gridLayout = self.horizontalGridLayouts[underCellAddress];
        if (bottomPriority > gridLayout.priority) {
            self.horizontalGridLayouts[underCellAddress] = [ZMJGridLayout gridLayoutWithGridWidth:bottomWidth
                                                                                        gridColor:bottomColor
                                                                                           origin:CGPointMake(frame.origin.x, CGRectGetMaxY(frame))
                                                                                           length:frame.size.width
                                                                                             edge:RectEdgeMake(UIPopoverArrowDirectionDown, 0, leftWidth, 0, rightWidth)
                                                                                         priority:bottomPriority];
        }
    } else {
        self.horizontalGridLayouts[underCellAddress] = [ZMJGridLayout gridLayoutWithGridWidth:bottomWidth
                                                                                    gridColor:bottomColor
                                                                                       origin:CGPointMake(frame.origin.x, CGRectGetMaxY(frame))
                                                                                       length:frame.size.width
                                                                                         edge:RectEdgeMake(UIPopoverArrowDirectionDown, 0, leftWidth, 0, rightWidth)
                                                                                     priority:bottomPriority];
    }
    
    if (self.verticalGridLayouts[address]) {
        ZMJGridLayout *gridLayout = self.verticalGridLayouts[address];
        if (leftPriority > gridLayout.priority) {
            self.verticalGridLayouts[address] = [ZMJGridLayout gridLayoutWithGridWidth:leftWidth
                                                                             gridColor:leftColor
                                                                                origin:frame.origin
                                                                                length:frame.size.height
                                                                                  edge:RectEdgeMake(UIPopoverArrowDirectionLeft, topWidth, 0, bottomWidth, 0)
                                                                              priority:leftPriority];
        }
    } else {
        self.verticalGridLayouts[address] = [ZMJGridLayout gridLayoutWithGridWidth:leftWidth
                                                                         gridColor:leftColor
                                                                            origin:frame.origin
                                                                            length:frame.size.height
                                                                              edge:RectEdgeMake(UIPopoverArrowDirectionLeft, topWidth, 0, bottomWidth, 0)
                                                                          priority:leftPriority];
        
    }
    Address *nextCellAddress = [Address addressWithRow:address.row
                                                column:address.column + 1
                                              rowIndex:address.rowIndex
                                           columnIndex:address.columnIndex + 1];
    if (self.verticalGridLayouts[nextCellAddress]) {
        ZMJGridLayout *gridLayout = self.verticalGridLayouts[nextCellAddress];
        if (rightPriority > gridLayout.priority) {
            self.verticalGridLayouts[nextCellAddress] = [ZMJGridLayout gridLayoutWithGridWidth:rightWidth
                                                                                     gridColor:rightColor
                                                                                        origin:CGPointMake(CGRectGetMaxX(frame), frame.origin.y)
                                                                                        length:frame.size.height
                                                                                          edge:RectEdgeMake(UIPopoverArrowDirectionRight, topWidth, 0, bottomWidth, 0)
                                                                                      priority:rightPriority];
        }
    } else {
        self.verticalGridLayouts[nextCellAddress] = [ZMJGridLayout gridLayoutWithGridWidth:rightWidth
                                                                                 gridColor:rightColor
                                                                                    origin:CGPointMake(CGRectGetMaxX(frame), frame.origin.y)
                                                                                    length:frame.size.height
                                                                                      edge:RectEdgeMake(UIPopoverArrowDirectionRight, topWidth, 0, bottomWidth, 0)
                                                                                  priority:rightPriority];
    }
}

- (void)renderMergedCells {
    [self.mergedCellAddress.array enumerateObjectsUsingBlock:^(Address * _Nonnull address, NSUInteger idx, BOOL * _Nonnull stop) {
        NSValue *frameValue = self.mergedCellRects[address];
        if (frameValue) {
            [self layoutCell:address frame:frameValue.CGRectValue];
        }
    }];
}

- (void)renderHorizontalGridlines {
    
}

- (void)renderVerticalGridlines {
    
}

- (void)renderBorders {
    
    
}

- (void)extractGridStyle:(GridStyle *)style outWidth:(CGFloat *)width outColor:(UIColor **)color outPriority:(CGFloat *)priority {
    
}

- (void)returnReusableResouces {
    
}

#pragma mark - getters

- (NSMutableOrderedSet<Address *> *)mergedCellAddress {
    if (!_mergedCellAddress) {
        _mergedCellAddress = [NSMutableOrderedSet orderedSet];
    }
    return _mergedCellAddress;
}
- (NSMutableDictionary<Address *, NSValue *> *)mergedCellRects {
    if (!_mergedCellRects) {
        _mergedCellRects = [NSMutableDictionary dictionary];
    }
    return _mergedCellRects;
}
- (NSMutableDictionary<Address *, ZMJGridLayout *> *)horizontalGridLayouts {
    if (!_horizontalGridLayouts) {
        _horizontalGridLayouts = [NSMutableDictionary dictionary];
    }
    return _horizontalGridLayouts;
}
- (NSMutableDictionary<Address *, ZMJGridLayout *> *)verticalGridLayouts {
    if (!_verticalGridLayouts) {
        _verticalGridLayouts = [NSMutableDictionary dictionary];
    }
    return _verticalGridLayouts;
}
- (NSMutableOrderedSet<Address *> *)visibleCellAddresses {
    if (!_visibleCellAddresses) {
        _visibleCellAddresses = [NSMutableOrderedSet orderedSet];
    }
    return _visibleCellAddresses;
}
- (NSMutableOrderedSet<Address *> *)visibleHorizontalGridAddresses {
    if (!_visibleHorizontalGridAddresses) {
        _visibleHorizontalGridAddresses = [NSMutableOrderedSet orderedSet];
    }
    return _visibleHorizontalGridAddresses;
}
- (NSMutableOrderedSet<Address *> *)visibleVerticalGridAddresses {
    if (!_visibleVerticalGridAddresses) {
        _visibleVerticalGridAddresses = [NSMutableOrderedSet orderedSet];
    }
    return _visibleVerticalGridAddresses;
}
- (NSMutableOrderedSet<Address *> *)visibleBorderAddresses {
    if (!_visibleBorderAddresses) {
        _visibleBorderAddresses = [NSMutableOrderedSet orderedSet];
    }
    return _visibleBorderAddresses;
}

@end









