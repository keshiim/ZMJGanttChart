//
//  SpreadsheetView+Layout.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import "SpreadsheetView+Layout.h"
#import "SpreadsheetView+CirclularScrolling.h"
#import "ZMJLayoutEngine.h"
#import "NSArray+WBGAddition.h"

@implementation SpreadsheetView (Layout)
/// Override
- (void)layoutSubViews {
    [super layoutSubviews];
    
    self.tableView.delegate         = nil;
    self.columnHeaderView.delegate  = nil;
    self.rowHeaderView.delegate     = nil;
    self.cornerView.delegate        = nil;
    
    State state = self.cornerView.state;
    state.frame = self.cornerView.frame;
    state.contentSize = self.cornerView.contentSize;
    state.contentOffset = self.cornerView.contentOffset;
    self.cornerView.state = state;
    
    state = self.columnHeaderView.state;
    state.frame = self.columnHeaderView.frame;
    state.contentSize = self.columnHeaderView.contentSize;
    state.contentOffset = self.columnHeaderView.contentOffset;
    self.columnHeaderView.state = state;
    
    state = self.rowHeaderView.state;
    state.frame = self.rowHeaderView.frame;
    state.contentSize = self.rowHeaderView.contentSize;
    state.contentOffset = self.rowHeaderView.contentOffset;
    self.rowHeaderView.state = state;
    
    state = self.tableView.state;
    state.frame = self.tableView.frame;
    state.contentSize = self.tableView.contentSize;
    state.contentOffset = self.tableView.contentOffset;
    self.tableView.state = state;
    
    void(^defer)(void) = ^(void){
        self.cornerView.contentSize = self.cornerView.state.contentSize;
        self.columnHeaderView.contentSize = self.columnHeaderView.state.contentSize;
        self.rowHeaderView.contentSize = self.rowHeaderView.state.contentSize;
        self.tableView.contentSize = self.tableView.state.contentSize;
        
        self.cornerView.contentOffset = self.cornerView.state.contentOffset;
        self.columnHeaderView.contentOffset = self.columnHeaderView.state.contentOffset;
        self.rowHeaderView.contentOffset = self.rowHeaderView.state.contentOffset;
        self.tableView.contentOffset = self.tableView.state.contentOffset;
        
        self.tableView.delegate = self;
        self.columnHeaderView.delegate = self;
        self.rowHeaderView.delegate = self;
        self.cornerView.delegate = self;
    };
    
    [self reloadDataIfNeeded];
    
    if (self.numberOfColumns <= 0 && self.numberOfRows <= 0) {
        defer();
        return;
    }
    if (self.circularScrollingOptions.direction & Direction_horizontally) {
        [self recenterHorizontallyIfNecessary];
    }
    if (self.circularScrollingOptions.direction & Direction_vertically) {
        [self recenterVerticallyIfNecessary];
    }
    
    [self layoutCornerView];
    [self layoutRowHeaderView];
    [self layoutColumnHeaderView];
    [self layoutTableView];
    // end function
    defer();
}

#pragma mark - Public method
- (LayoutAttributes)layoutAttributeForCornerView {
    LayoutAttributes layout;
    layout.startColumn = 0;
    layout.startRow = 0;
    layout.numberOfColumns = self.frozenColumns;
    layout.numberOfRows = self.frozenRows;
    layout.columnCount = self.frozenColumns;
    layout.rowCount = self.frozenRows;
    layout.insets = CGPointZero;
    return layout;
}

- (LayoutAttributes)layoutAttributeForColumnHeaderView {
    CGPoint insets =  self.circularScrollingOptions.headerStyle == HeaderStyle_columnHeaderStartsFirstRow ?
    CGPointMake(0, [(NSNumber *)[[self.layoutProperties.rowHeightCache subarrayWithRange:NSMakeRange(0, self.frozenRows)] wbg_reduce:@(0) with:^NSNumber* _Nonnull(NSNumber* _Nullable prev, NSNumber * _Nonnull curr) {
        return @(prev.floatValue + curr.floatValue);
    }] floatValue] + self.intercellSpacing.height * self.layoutProperties.frozenRows) :
    CGPointZero;
    
    LayoutAttributes layout;
    layout.startColumn = 0;
    layout.startRow = self.layoutProperties.frozenRows;
    layout.numberOfColumns = self.layoutProperties.numberOfColumns;
    layout.numberOfRows = self.layoutProperties.numberOfRows;
    layout.columnCount = self.layoutProperties.frozenColumns;
    layout.rowCount = self.layoutProperties.numberOfRows * self.circularScrollScalingFactor.vertical;
    layout.insets = insets;
    return layout;
}

- (LayoutAttributes)layoutAttributeForRowHeaderView {
    CGPoint insets =  self.circularScrollingOptions.headerStyle == HeaderStyle_rowHeaderStartsFirstColumn ?
    CGPointMake(0, [(NSNumber *)[[self.layoutProperties.columnWidthCache subarrayWithRange:NSMakeRange(0, self.frozenColumns)] wbg_reduce:@(0) with:^NSNumber* _Nonnull(NSNumber* _Nullable prev, NSNumber * _Nonnull curr) {
        return @(prev.floatValue + curr.floatValue);
    }] floatValue] + self.intercellSpacing.width * self.layoutProperties.frozenColumns) :
    CGPointZero;
    
    LayoutAttributes layout;
    layout.startColumn = self.layoutProperties.frozenColumns;
    layout.startRow = 0;
    layout.numberOfColumns = self.layoutProperties.numberOfColumns;
    layout.numberOfRows = self.layoutProperties.frozenRows;
    layout.columnCount = self.layoutProperties.numberOfColumns * self.circularScrollScalingFactor.horizontal;
    layout.rowCount = self.layoutProperties.frozenRows;
    layout.insets = insets;
    return layout;
}

- (LayoutAttributes)layoutAttributeForTableView {
    LayoutAttributes layout;
    layout.startColumn = self.layoutProperties.frozenColumns;
    layout.startRow = self.layoutProperties.frozenRows;
    layout.numberOfColumns = self.layoutProperties.numberOfColumns;
    layout.numberOfRows = self.layoutProperties.numberOfRows;
    layout.columnCount = self.layoutProperties.numberOfColumns * self.circularScrollScalingFactor.horizontal;
    layout.rowCount = self.layoutProperties.numberOfRows * self.circularScrollScalingFactor.vertical;
    layout.insets = CGPointZero;
    return layout;
}

- (ZMJLayoutProperties *)resetLayoutProperties {
    if (self.dataSource == nil) {
        return [ZMJLayoutProperties new];
    }
    
    NSInteger numberOfColumns = [self.dataSource numberOfColumns:self];
    NSInteger numberOfRows    = [self.dataSource numberOfRows:self];
    
    NSInteger frozenColumns = [self.dataSource frozenColumns:self];
    NSInteger frozenRows    = [self.dataSource frozenRows:self];
    if (numberOfColumns < 0) {
        [NSException exceptionWithName:@"" reason:@"`numberOfColumns(in:)` must return a value greater than or equal to 0" userInfo:nil];
    }
    if (numberOfRows < 0) {
        [NSException exceptionWithName:@"" reason:@"`numberOfRows(in:)` must return a value greater than or equal to 0" userInfo:nil];
    }
    if (frozenColumns < 0) {
        [NSException exceptionWithName:@"" reason:@"`frozenColumns(in:)` must return a value greater than or equal to 0" userInfo:nil];
    }
    if (frozenRows < 0) {
        [NSException exceptionWithName:@"" reason:@"`frozenRows(in:)` must return a value greater than or equal to 0" userInfo:nil];
    }

    NSArray<ZMJCellRange *> *mergedCells = [self.dataSource mergedCells:self];
    NSDictionary<Location *, ZMJCellRange *> * (^mergedCellLayouts)(void) = ^NSDictionary<Location *, ZMJCellRange *> *(void) {
        NSMutableDictionary<Location *, ZMJCellRange *> *layouts = [NSMutableDictionary dictionary];
        
        for (ZMJCellRange *mergedCell in mergedCells) {
            if ((mergedCell.from.column < frozenColumns && mergedCell.to.column >= frozenColumns) ||
                (mergedCell.from.row < frozenRows && mergedCell.to.row >= frozenRows)) {
                [NSException exceptionWithName:@"" reason:@"`cannot merge frozen and non-frozen column or rows" userInfo:nil];
            }
            for (NSInteger column = mergedCell.from.column; column <= mergedCell.to.column; column++ ) {
                for (NSInteger row = mergedCell.from.row; row <= mergedCell.to.row; row++) {
                    if (column >= numberOfColumns || row >= numberOfRows) {
                        [NSException exceptionWithName:@"" reason:@"the range of `mergedCell` cannot exceed the total column or row count" userInfo:nil];
                    }
                    Location *location = [Location locationWithRow:row column:column];
                    
                    ZMJCellRange *existingMergedCell = layouts[location];
                    if (existingMergedCell) {
                        if ([existingMergedCell containsCellRange:mergedCell]) {
                            continue;
                        }
                        if ([mergedCell containsCellRange:existingMergedCell]) {
                            [layouts removeObjectForKey:location];
                        } else {
                            [NSException exceptionWithName:@"" reason:@"cannot merge cells in a range that overlap existing merged cells" userInfo:nil];
                        }
                    }
                    mergedCell.size = CGSizeZero;
                    layouts[location] = mergedCell;
                }
            }
        }
        
        return layouts.copy;
    };
    
    NSMutableArray<NSNumber *> *columnWidthCache = [NSMutableArray array];
    CGFloat frozenColumnWidth = 0;
    for (NSInteger column = 0; column < frozenColumns; column++) {
        CGFloat width = [self.dataSource spreadsheetView:self widthForColumn:column];
        [columnWidthCache addObject:@(width)];
        frozenColumnWidth += width;
    }
    CGFloat tableWidth = 0;
    for (NSInteger column = frozenColumns; column < numberOfColumns; column++) {
        CGFloat width = [self.dataSource spreadsheetView:self widthForColumn:column];
        [columnWidthCache addObject:@(width)];
        tableWidth += width;
    }
    CGFloat columnWidth = frozenColumnWidth + tableWidth;
    
    NSMutableArray<NSNumber *> *rowHeightCache = [NSMutableArray array];
    CGFloat frozenRowHeight = 0;
    for (NSInteger row = 0; row < frozenRows; row++) {
        CGFloat height = [self.dataSource spreadsheetView:self heightForRow:row];
        [rowHeightCache addObject:@(height)];
        frozenRowHeight += height;
    }
    CGFloat tableHeight = 0;
    for (NSInteger row = frozenRows; row < numberOfRows; row++) {
        CGFloat height = [self.dataSource spreadsheetView:self heightForRow:row];
        [rowHeightCache addObject:@(height)];
        tableHeight += height;
    }
    CGFloat rowHeight = frozenRowHeight + tableHeight;
 
    return [[ZMJLayoutProperties alloc] initWithNumberOfColumns:numberOfColumns
                                                   numberOfRows:numberOfRows
                                                  frozenColumns:frozenColumns
                                                     frozenRows:frozenRows
                                              frozenColumnWidth:frozenColumnWidth
                                                frozenRowHeight:frozenRowHeight
                                                    columnWidth:columnWidth
                                                      rowHeight:rowHeight
                                               columnWidthCache:columnWidthCache
                                                 rowHeightCache:rowHeightCache
                                                    mergedCells:mergedCells
                                              mergedCellLayouts:mergedCellLayouts()];
}

- (void)resetContentSize:(ZMJScrollView *)scrollView {
    void (^defer)(void) = ^(void) {
        scrollView.contentSize = scrollView.state.contentSize;
    };
    
    defer();
}

#pragma mark - Private method
- (void)layout:(ZMJScrollView *)scrollView {
    ZMJLayoutEngine *layoutEngine = [ZMJLayoutEngine spreadsheetView:self scrollView:scrollView];
    [layoutEngine layout];
}

- (void)layoutCornerView {
    if (self.frozenColumns <= 0 || self.frozenRows <= 0 || self.circularScrollingOptions.headerStyle != HeaderStyle_none) {
        self.cornerView.hidden = YES;
        return;
    }
    self.cornerView.hidden = NO;
    [self layout:self.cornerView];
}

- (void)layoutColumnHeaderView {
    if (self.frozenColumns <= 0) {
        self.columnHeaderView.hidden = YES;
        return;
    }
    self.columnHeaderView.hidden = NO;
    [self layout:self.columnHeaderView];
}

- (void)layoutRowHeaderView {
    if (self.frozenRows <= 0) {
        self.rowHeaderView.hidden = YES;
        return;
    }
    self.rowHeaderView.hidden =  NO;
    [self layout:self.rowHeaderView];
}

- (void)layoutTableView {
    [self layout:self.tableView];
}

@end
