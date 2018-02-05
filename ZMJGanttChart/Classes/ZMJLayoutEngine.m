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
#define CGPOINT_SETX(point, x_value) { \
CGPoint tempPoint = point;         \
tempPoint.x = (x_value);           \
point = tempPoint;                 \
}
- (BOOL)enumerateColumns:(NSInteger)row rowIndex:(NSInteger)rowIndex {
    NSInteger startColumnIndex = [self.spreadsheetView findIndex:self.columnRecords offset:self.visibleRect.origin.x - self.insets.x];
    CGPOINT_SETX(self.cellOrigin, self.insets.x + self.columnRecords[startColumnIndex].floatValue + self.intercellSpacing.width);
    
    __block NSInteger columnIndex = startColumnIndex + self.startColumn;
    
    while (columnIndex < self.columnCount) {
        __block NSInteger columnStep = 1;
        void(^defer)(void) = ^(void){
            columnIndex += columnStep;
        };
        
        NSInteger column = columnIndex % self.numberOfColumns;
        if ((self.circularScrollingOptions.tableStyle & TableStyle_columnHeaderNotRepeated) && self.startColumn > 0 && column < self.frozenColumns) {
            defer();
            continue;
        }
        
        CGFloat columnWidth = self.columnWidthCache[column].floatValue;
        
        ZMJCellRange *mergedCell = [self.spreadsheetView mergedCellFor:[Location locationWithRow:row column:column]];
        if (mergedCell) {
            CGFloat cellWidth  = 0;
            CGFloat cellHeight = 0;
            if (!CGSizeEqualToSize(CGSizeZero, mergedCell.size)) {
                cellWidth  = mergedCell.size.width;
                cellHeight = mergedCell.size.height;
            } else {
                for (NSInteger col = mergedCell.from.column; col <= mergedCell.to.column; ++col) {
                    cellWidth += self.columnWidthCache[column].floatValue + self.intercellSpacing.width;
                }
                for (NSInteger r = mergedCell.from.row; r <= mergedCell.to.row; ++r) {
                    cellHeight += self.rowHeightCache[r].floatValue + self.intercellSpacing.height;
                }
                mergedCell.size = CGSizeMake(cellWidth, cellHeight);
            }
            
            columnStep += (mergedCell.columnCount - (column - mergedCell.from.column)) - 1;
            Address *address = [Address addressWithRow:mergedCell.from.row
                                                column:mergedCell.from.column
                                              rowIndex:rowIndex - (row - mergedCell.from.row)
                                           columnIndex:columnIndex - (column - mergedCell.from.column)];
            
            if (column < self.columnRecords.count) {
                CGFloat offsetWidth = self.columnRecords[column - self.startColumn].floatValue - self.columnRecords[mergedCell.from.column - self.startColumn].floatValue;
                CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x - offsetWidth);
            } else {
                NSInteger fromColumn = mergedCell.from.column;
                NSInteger endColumn  = self.columnRecords.count - 1;
                
                CGFloat offsetWidth = self.columnRecords[endColumn].floatValue;
                for (NSInteger col = endColumn; col < column; ++col) {
                    offsetWidth += self.columnWidthCache[column].floatValue + self.intercellSpacing.width;
                }
                if (fromColumn < self.columnRecords.count) {
                    offsetWidth -= self.columnRecords[mergedCell.from.column].floatValue;
                } else {
                    offsetWidth -= self.columnRecords[endColumn].floatValue;
                    for (NSInteger col = endColumn; col < fromColumn; ++col) {
                        offsetWidth -= self.columnWidthCache[column].floatValue + self.intercellSpacing.width;
                    }
                }
                
                CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x - offsetWidth);
            }
            
            if ([self.visibleCellAddresses containsObject:address]) {
                if (self.cellOrigin.x > CGRectGetMaxX(self.visibleRect)) {
                    CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x + cellWidth);
                    defer();
                    return NO;
                }
                if (self.cellOrigin.y > CGRectGetMaxY(self.visibleRect)) {
                    defer();
                    return YES;
                }
                CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x + cellWidth);
                
                defer();
                continue;
            }
            
            CGFloat offsetHeight = 0;
            if (row < self.rowRecords.count) {
                offsetHeight = self.rowRecords[row - self.startRow].floatValue - self.rowRecords[mergedCell.from.row - self.startRow].floatValue;
            } else {
                NSInteger fromRow = mergedCell.from.row;
                NSInteger endRow  = self.rowRecords.count - 1;
                
                offsetHeight = self.rowRecords[endRow].floatValue;
                for (NSInteger r = endRow; r < row; ++r) {
                    offsetHeight += self.rowHeightCache[row].floatValue + self.intercellSpacing.height;
                }
                if (fromRow < self.rowRecords.count) {
                    offsetHeight -= self.rowRecords[fromRow].floatValue;
                } else {
                    offsetHeight -= self.rowRecords[endRow].floatValue;
                    for (NSInteger r = endRow; r < fromRow; ++r) {
                        offsetHeight -= self.rowHeightCache[row].floatValue + self.intercellSpacing.height;
                    }
                }
            }
            
            if (self.cellOrigin.x + cellWidth - self.intercellSpacing.width <= CGRectGetMinX(self.visibleRect)) {
                CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x + cellWidth);
                
                defer();
                continue;
            }
            if (self.cellOrigin.x > CGRectGetMaxX(self.visibleRect)) {
                CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x + cellWidth);
                
                defer();
                return NO;
            }
            if ((self.cellOrigin.y - offsetHeight + cellHeight - self.intercellSpacing.height) <= CGRectGetMinY(self.visibleRect)) {
                CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x + cellWidth);
                
                defer();
                continue;
            }
            if (self.cellOrigin.y - offsetHeight > CGRectGetMaxY(self.visibleRect)) {
                defer();
                return YES;
            }
            
            [self.visibleCellAddresses addObject:address];
            [self.mergedCellAddress addObject:address];
            self.mergedCellRects[address] = [NSValue valueWithCGRect:CGRectMake(self.cellOrigin.x,
                                                                                self.cellOrigin.y - offsetHeight,
                                                                                cellWidth - self.intercellSpacing.width,
                                                                                cellHeight - self.intercellSpacing.height)];
            CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x + cellWidth);
            defer();
            continue;
        }
        
        CGFloat rowHeight = self.rowHeightCache[row].floatValue;
        
        if (self.cellOrigin.x + columnWidth <= CGRectGetMinX(self.visibleRect)) {
            CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x + columnWidth + self.intercellSpacing.width);
            defer();
            continue;
        }
        if (self.cellOrigin.x > CGRectGetMaxX(self.visibleRect)) {
            CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x + columnWidth + self.intercellSpacing.width);
            defer();
            return NO;
        }
        if (self.cellOrigin.y + rowHeight <= CGRectGetMinY(self.visibleRect)) {
            CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x + columnWidth + self.intercellSpacing.width);
            defer();
            continue;
        }
        if (self.cellOrigin.y > CGRectGetMaxY(self.visibleRect)) {
            defer();
            return YES;
        }
        
        Address *address = [Address addressWithRow:row column:column rowIndex:rowIndex columnIndex:columnIndex];
        [self.visibleCellAddresses addObject:address];
        
        CGSize cellSize = CGSizeMake(columnWidth, rowHeight);
        [self layoutCell:address frame:(CGRect){self.cellOrigin, cellSize}];
        
        CGPOINT_SETX(self.cellOrigin, self.cellOrigin.x + columnWidth + self.intercellSpacing.width);
        
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
                                                                                    edge:RectEdgeMake(RectEdgeDirectionUp, 0, leftWidth, 0, rightWidth)
                                                                                priority:topPriority];
        }
    } else {
        self.horizontalGridLayouts[address]    = [ZMJGridLayout gridLayoutWithGridWidth:topWidth
                                                                              gridColor:topColor
                                                                                 origin:frame.origin
                                                                                 length:frame.size.width
                                                                                   edge:RectEdgeMake(RectEdgeDirectionUp, 0, leftWidth, 0, rightWidth)
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
                                                                                             edge:RectEdgeMake(RectEdgeDirectionDown, 0, leftWidth, 0, rightWidth)
                                                                                         priority:bottomPriority];
        }
    } else {
        self.horizontalGridLayouts[underCellAddress] = [ZMJGridLayout gridLayoutWithGridWidth:bottomWidth
                                                                                    gridColor:bottomColor
                                                                                       origin:CGPointMake(frame.origin.x, CGRectGetMaxY(frame))
                                                                                       length:frame.size.width
                                                                                         edge:RectEdgeMake(RectEdgeDirectionDown, 0, leftWidth, 0, rightWidth)
                                                                                     priority:bottomPriority];
    }
    
    if (self.verticalGridLayouts[address]) {
        ZMJGridLayout *gridLayout = self.verticalGridLayouts[address];
        if (leftPriority > gridLayout.priority) {
            self.verticalGridLayouts[address] = [ZMJGridLayout gridLayoutWithGridWidth:leftWidth
                                                                             gridColor:leftColor
                                                                                origin:frame.origin
                                                                                length:frame.size.height
                                                                                  edge:RectEdgeMake(RectEdgeDirectionLeft, topWidth, 0, bottomWidth, 0)
                                                                              priority:leftPriority];
        }
    } else {
        self.verticalGridLayouts[address] = [ZMJGridLayout gridLayoutWithGridWidth:leftWidth
                                                                         gridColor:leftColor
                                                                            origin:frame.origin
                                                                            length:frame.size.height
                                                                              edge:RectEdgeMake(RectEdgeDirectionLeft, topWidth, 0, bottomWidth, 0)
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
                                                                                          edge:RectEdgeMake(RectEdgeDirectionRight, topWidth, 0, bottomWidth, 0)
                                                                                      priority:rightPriority];
        }
    } else {
        self.verticalGridLayouts[nextCellAddress] = [ZMJGridLayout gridLayoutWithGridWidth:rightWidth
                                                                                 gridColor:rightColor
                                                                                    origin:CGPointMake(CGRectGetMaxX(frame), frame.origin.y)
                                                                                    length:frame.size.height
                                                                                      edge:RectEdgeMake(RectEdgeDirectionRight, topWidth, 0, bottomWidth, 0)
                                                                                  priority:rightPriority];
    }
}

- (void)renderMergedCells {
    __weak typeof(self)weak_self = self;
    [self.mergedCellAddress enumerateObjectsUsingBlock:^(Address * _Nonnull address, NSUInteger idx, BOOL * _Nonnull stop) {
        NSValue *frameValue = weak_self.mergedCellRects[address];
        if (frameValue) {
            [weak_self layoutCell:address frame:frameValue.CGRectValue];
        }
    }];
}

- (void)renderHorizontalGridlines {
    __weak typeof(self)weak_self = self;
    [self.horizontalGridLayouts enumerateKeysAndObjectsUsingBlock:^(Address * _Nonnull address, ZMJGridLayout * _Nonnull gridLayout, BOOL * _Nonnull stop) {
        CGRect frame = CGRectZero;
        frame.origin = gridLayout.origin;
        if (gridLayout.edge.top.notNull == YES) {
            Direct top = gridLayout.edge.top;
            frame.origin.x -= top.left + (weak_self.intercellSpacing.width - top.left) / 2;
            frame.origin.y -= weak_self.intercellSpacing.height - (weak_self.intercellSpacing.height - gridLayout.gridWidth) / 2;
            frame.size.width = gridLayout.length + top.left + (weak_self.intercellSpacing.width - top.left) / 2 + top.right + (weak_self.intercellSpacing.width - top.right) / 2;
        }
        if (gridLayout.edge.bottom.notNull == YES) {
            Direct bottom = gridLayout.edge.bottom;
            frame.origin.x -= bottom.left + (weak_self.intercellSpacing.width - bottom.left) / 2;
            frame.origin.y -= (gridLayout.gridWidth - weak_self.intercellSpacing.height) / 2;
            frame.size.width = gridLayout.length + bottom.left + (weak_self.intercellSpacing.width - bottom.left) / 2 + bottom.right + (weak_self.intercellSpacing.width - bottom.right) / 2;
        }
        frame.size.height = gridLayout.gridWidth;
        
        if ([weak_self.scrollView.visibleHorizontalGridlines contains:address]) {
            Gridline * gridline = [weak_self.scrollView.visibleHorizontalGridlines objectForKeyedSubscript:address];
            if (gridline) {
                gridline.frame = frame;
                gridline.color = gridLayout.gridColor;
                gridline.zPosition = gridLayout.priority;
            }
        } else {
            Gridline *gridline = [weak_self.spreadsheetView.horizontalGridlineReuseQueue dequeueOrCreate:[Gridline class]];
            gridline.frame = frame;
            gridline.color = gridLayout.gridColor;
            gridline.zPosition = gridLayout.priority;
            
            [weak_self.scrollView.layer addSublayer:gridline];
            [weak_self.scrollView.visibleHorizontalGridlines setObject:gridline forKeyedSubscript:address];
        }
        [weak_self.visibleHorizontalGridAddresses addObject:address];
    }];
}

- (void)renderVerticalGridlines {
    __weak typeof(self)weak_self = self;
    [self.verticalGridLayouts enumerateKeysAndObjectsUsingBlock:^(Address * _Nonnull address, ZMJGridLayout * _Nonnull gridLayout, BOOL * _Nonnull stop) {
        CGRect frame = CGRectZero;
        frame.origin = gridLayout.origin;

        if (gridLayout.edge.left.notNull == YES) {
            Direct left = gridLayout.edge.left;
            frame.origin.x -= weak_self.intercellSpacing.width - (weak_self.intercellSpacing.width - gridLayout.gridWidth) / 2;
            frame.origin.y -= left.top + (weak_self.intercellSpacing.height - left.top) / 2;
            frame.size.height = gridLayout.length + left.top + (weak_self.intercellSpacing.height - left.top) / 2 + left.bottom + (weak_self.intercellSpacing.height - left.bottom) / 2;
        }
        if (gridLayout.edge.right.notNull == YES) {
            Direct right = gridLayout.edge.right;
            frame.origin.x -= (gridLayout.gridWidth - weak_self.intercellSpacing.width) / 2;
            frame.origin.y -= right.top + (weak_self.intercellSpacing.height - right.top) / 2;
            frame.size.height = gridLayout.length + right.top + (weak_self.intercellSpacing.height - right.top) / 2 + right.bottom + (weak_self.intercellSpacing.height - right.bottom) / 2;
        }
        frame.size.width = gridLayout.gridWidth;
        
        if ([weak_self.scrollView.visibleVerticalGridlines contains:address]) {
            Gridline *gridline = [weak_self.scrollView.visibleVerticalGridlines objectForKeyedSubscript:address];
            if (gridline) {
                gridline.frame = frame;
                gridline.color = gridLayout.gridColor;
                gridline.zPosition = gridLayout.priority;
            }
        } else {
            Gridline *gridline = [weak_self.spreadsheetView.verticalGridlineReuseQueue dequeueOrCreate:[Gridline class]];
            gridline.frame = frame;
            gridline.color = gridLayout.gridColor;
            gridline.zPosition = gridLayout.priority;
            
            [weak_self.scrollView.layer addSublayer:gridline];
            [weak_self.scrollView.visibleVerticalGridlines setObject:gridline forKeyedSubscript:address];
        }
        [weak_self.visibleVerticalGridAddresses addObject:address];
    }];
}

- (void)renderBorders {
    __weak typeof(self)weak_self = self;
    [self.visibleBorderAddresses enumerateObjectsUsingBlock:^(Address * _Nonnull address, NSUInteger idx, BOOL * _Nonnull stop) {
        ZMJCell *cell = [weak_self.scrollView.visibleCells objectForKeyedSubscript:address];
        if (cell) {
            if ([weak_self.scrollView.visibleBorders contains:address]) {
                Border *border = [weak_self.scrollView.visibleBorders objectForKeyedSubscript:address];
                if (border) {
                    border.borders = cell.borders;
                    border.frame = cell.frame;
                    [border setNeedsDisplay];
                }
            } else {
                Border *border = [weak_self.spreadsheetView.borderReuseQueue dequeueOrCreate:[Border class]];
                border.borders = cell.borders;
                border.frame   = cell.frame;
                [weak_self.scrollView addSubview:border];
                [weak_self.scrollView.visibleBorders setObject:border forKeyedSubscript:address];
            }
        }
    }];
}

- (void)extractGridStyle:(GridStyle *)style outWidth:(CGFloat *)width outColor:(UIColor **)color outPriority:(CGFloat *)priority {
    switch (style.styleEnum) {
        case GridStyle_default:
        {
            switch (self.defaultGridStyle.styleEnum) {
                case GridStyle_solid:
                {
                    *width = self.defaultGridStyle.width;
                    *color = self.defaultGridStyle.color;
                    *priority = 0;
                }
                    break;
                default:
                {
                    *width = 0;
                    *color = [UIColor clearColor];
                    *priority = 0;
                }
                    break;
            }
        }
            break;
        case GridStyle_solid:
        {
            *width = style.width;
            *color = style.color;
            *priority = 200;
        }
            break;
        case GridStyle_none:
        {
            *width = 0;
            *color = [UIColor clearColor];
            *priority = 100;
        }
            break;
        default:
            break;
    }
}

- (void)returnReusableResouces {
    [self.scrollView.visibleCells substract:self.visibleCellAddresses];
    __weak typeof(self)weak_self = self;
    [self.scrollView.visibleCells.addresses enumerateObjectsUsingBlock:^(Address * _Nonnull address, NSUInteger idx, BOOL * _Nonnull stop) {
        ZMJCell *cell = [weak_self.scrollView.visibleCells objectForKeyedSubscript:address];
        if (cell) {
            [cell removeFromSuperview];
            if (cell.reuseIdentifier && [weak_self.spreadsheetView.cellReuseQueues objectForKey:cell.reuseIdentifier]) {
                ReuseQueue *reuseQueue = [weak_self.spreadsheetView.cellReuseQueues objectForKey:cell.reuseIdentifier];
                [reuseQueue enqueue:cell];
            }
            [weak_self.scrollView.visibleCells removeObjectForKey:address];
        }
    }];
    
    self.scrollView.visibleCells.addresses = self.visibleCellAddresses;
    
    [self.scrollView.visibleVerticalGridlines substract:self.visibleVerticalGridAddresses];
    [self.scrollView.visibleVerticalGridlines.addresses enumerateObjectsUsingBlock:^(Address * _Nonnull address, NSUInteger idx, BOOL * _Nonnull stop) {
        Gridline * gridline = [weak_self.scrollView.visibleVerticalGridlines objectForKeyedSubscript:address];
        if (gridline) {
            [gridline removeFromSuperlayer];
            [weak_self.spreadsheetView.verticalGridlineReuseQueue enqueue:gridline];
            [weak_self.scrollView.visibleVerticalGridlines removeObjectForKey:address];
        }
    }];
    self.scrollView.visibleVerticalGridlines.addresses = self.visibleVerticalGridAddresses;
    
    [self.scrollView.visibleHorizontalGridlines substract:self.visibleHorizontalGridAddresses];
    [self.scrollView.visibleHorizontalGridlines.addresses enumerateObjectsUsingBlock:^(Address * _Nonnull address, NSUInteger idx, BOOL * _Nonnull stop) {
        Gridline *gridline = [weak_self.scrollView.visibleHorizontalGridlines objectForKeyedSubscript:address];
        if (gridline) {
            [gridline removeFromSuperlayer];
            [weak_self.spreadsheetView.horizontalGridlineReuseQueue enqueue:gridline];
            [weak_self.scrollView.visibleHorizontalGridlines removeObjectForKey:address];
        }
    }];
    self.scrollView.visibleHorizontalGridlines.addresses = self.visibleHorizontalGridAddresses;
    
    [self.scrollView.visibleBorders substract:self.visibleBorderAddresses];
    [self.scrollView.visibleBorders.addresses enumerateObjectsUsingBlock:^(Address * _Nonnull address, NSUInteger idx, BOOL * _Nonnull stop) {
        Border *border = [weak_self.scrollView.visibleBorders objectForKeyedSubscript:address];
        if (border) {
            [border removeFromSuperview];
            [weak_self.spreadsheetView.borderReuseQueue enqueue:border];
            [weak_self.scrollView.visibleBorders removeObjectForKey:address];
        }
    }];
    self.scrollView.visibleBorders.addresses =  self.visibleBorderAddresses;
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









