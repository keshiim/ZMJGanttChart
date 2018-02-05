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
#import "NSArray+BinarySearch.h"
#import "ZMJCellRange.h"

@implementation SpreadsheetView (Layout)
- (void)layoutSubviews {
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
    __weak typeof(self)weak_self = self;
    void(^defer)(void) = ^(void){
        weak_self.cornerView.contentSize       = weak_self.cornerView.state.contentSize;
        weak_self.columnHeaderView.contentSize = weak_self.columnHeaderView.state.contentSize;
        weak_self.rowHeaderView.contentSize    = weak_self.rowHeaderView.state.contentSize;
        weak_self.tableView.contentSize        = weak_self.tableView.state.contentSize;
        
        weak_self.cornerView.contentOffset       = weak_self.cornerView.state.contentOffset;
        weak_self.columnHeaderView.contentOffset = weak_self.columnHeaderView.state.contentOffset;
        weak_self.rowHeaderView.contentOffset    = weak_self.rowHeaderView.state.contentOffset;
        weak_self.tableView.contentOffset        = weak_self.tableView.state.contentOffset;
        
        weak_self.tableView.delegate        = weak_self;
        weak_self.columnHeaderView.delegate = weak_self;
        weak_self.rowHeaderView.delegate    = weak_self;
        weak_self.cornerView.delegate       = weak_self;
    };
    
    [self reloadDataIfNeeded];
    
    if (self.numberOfColumns <= 0 || self.numberOfRows <= 0) {
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
    CGPointMake([(NSNumber *)[[self.layoutProperties.columnWidthCache subarrayWithRange:NSMakeRange(0, self.frozenColumns)] wbg_reduce:@(0) with:^NSNumber* _Nonnull(NSNumber* _Nullable prev, NSNumber * _Nonnull curr) {
        return @(prev.floatValue + curr.floatValue);
    }] floatValue] + self.intercellSpacing.width * self.layoutProperties.frozenColumns, 0) :
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

    NSInteger numberOfColumns = [self.dataSource respondsToSelector:@selector(numberOfColumns:)] ?
                                [self.dataSource numberOfColumns:self] :
                                0;
    NSInteger numberOfRows    = [self.dataSource respondsToSelector:@selector(numberOfRows:)] ?
                                [self.dataSource numberOfRows:self] :
                                0;
    
    NSInteger frozenColumns = [self.dataSource respondsToSelector:@selector(frozenColumns:)] ?
                              [self.dataSource frozenColumns:self] :
                              0;
    NSInteger frozenRows    = [self.dataSource respondsToSelector:@selector(frozenRows:)] ?
                              [self.dataSource frozenRows:self] :
                              0;
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

    NSArray<ZMJCellRange *> *mergedCells = [self.dataSource respondsToSelector:@selector(mergedCells:)] ?
                                           [self.dataSource mergedCells:self] : @[];
    NSDictionary<Location *, ZMJCellRange *> *mergedCellLayouts = ^NSDictionary<Location *, ZMJCellRange *> *(void) {
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
    }();
    
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
                                              mergedCellLayouts:mergedCellLayouts];
}

- (void)resetContentSize:(ZMJScrollView *)scrollView {
    void (^defer)(void) = ^(void) {
        scrollView.contentSize = scrollView.state.contentSize;
    };
    [scrollView.columnRecords removeAllObjects];
    [scrollView.rowRecords removeAllObjects];
    
    NSInteger startColumn = scrollView.layoutAttributes.startColumn;
    NSInteger columnCount = scrollView.layoutAttributes.columnCount;
    CGFloat width = 0;
    for (NSInteger column = startColumn; column < columnCount; column++) {
        [scrollView.columnRecords addObject:@(width)];
        NSInteger index = column % self.numberOfColumns;
        if (!(self.circularScrollingOptions.tableStyle & TableStyle_columnHeaderNotRepeated) ||
            index >= startColumn) {
            width += self.layoutProperties.columnWidthCache[index].floatValue + self.intercellSpacing.width;
        }
    }
    
    NSInteger startRow = scrollView.layoutAttributes.startRow;
    NSInteger rowCount = scrollView.layoutAttributes.rowCount;
    CGFloat height = 0;
    for (NSInteger row = startRow; row < rowCount; row++) {
        [scrollView.rowRecords addObject:@(height)];
        NSInteger index = row % self.numberOfRows;
        if (!(self.circularScrollingOptions.tableStyle & TableStyle_rowHeaderNotRepeated) ||
            index >= startRow) {
            height += self.layoutProperties.rowHeightCache[index].floatValue + self.intercellSpacing.height;
        }
    }
    
    State state = scrollView.state;
    state.contentSize = CGSizeMake(width + self.intercellSpacing.width, height + self.intercellSpacing.height);
    scrollView.state = state;
    defer();
}

- (void)resetScrollViewFrame {
    __weak typeof(self)weak_self = self;
    void (^defer)(void) = ^(void) {
        weak_self.cornerView.frame       = weak_self.cornerView.state.frame;
        weak_self.columnHeaderView.frame = weak_self.columnHeaderView.state.frame;
        weak_self.rowHeaderView.frame    = weak_self.rowHeaderView.state.frame;
        weak_self.tableView.frame        = weak_self.tableView.state.frame;
    };
    UIEdgeInsets contentInset;

    if (@available(iOS 11.0, *)) {
#ifdef __IPHONE_11_0
        contentInset = self.rootView.adjustedContentInset;
#endif
    } else {
        contentInset = self.rootView.contentInset;
    }
    CGFloat horizontalInset = contentInset.left + contentInset.right;
    CGFloat verticalInset   = contentInset.top + contentInset.bottom;
    
    State state = self.cornerView.state;
    state.frame = CGRectMake(0, 0, self.cornerView.state.contentSize.width, self.cornerView.state.contentSize.height);
    self.cornerView.state = state;
    
    state = self.columnHeaderView.state;
    state.frame = CGRectMake(0, 0, self.columnHeaderView.state.contentSize.width, self.frame.size.height);
    self.columnHeaderView.state = state;
    
    state = self.rowHeaderView.state;
    state.frame = CGRectMake(0, 0, self.frame.size.width, self.rowHeaderView.state.contentSize.height);
    self.rowHeaderView.state = state;
    
    state = self.tableView.state;
    state.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.tableView.state = state;
    
    if (self.frozenColumns > 0) {
        State state = self.tableView.state;
        state.frame.origin.x = self.columnHeaderView.state.frame.size.width - self.intercellSpacing.width;
        state.frame.size.width = (self.frame.size.width - horizontalInset) - (self.columnHeaderView.state.frame.size.width - self.intercellSpacing.width);
        self.tableView.state = state;
        
        if (self.circularScrollingOptions.headerStyle != HeaderStyle_rowHeaderStartsFirstColumn) {
            State rhv_state = self.rowHeaderView.state;
            rhv_state.frame.origin.x = self.tableView.state.frame.origin.x;
            rhv_state.frame.size.width = self.tableView.state.frame.size.width;
            self.rowHeaderView.state = rhv_state;
        }
    } else {
        State state = self.tableView.state;
        state.frame.size.width = self.frame.size.width - horizontalInset;
    }
    if (self.frozenRows > 0) {
        State state = self.tableView.state;
        state.frame.origin.y = self.rowHeaderView.state.frame.size.height - self.intercellSpacing.height;
        state.frame.size.height = (self.frame.size.height - verticalInset) - (self.rowHeaderView.state.frame.size.height - self.intercellSpacing.height);
        self.tableView.state = state;
        
        if (self.circularScrollingOptions.headerStyle != HeaderStyle_columnHeaderStartsFirstRow) {
            State chv_state = self.columnHeaderView.state;
            chv_state.frame.origin.y = self.tableView.state.frame.origin.y;
            chv_state.frame.size.height = self.tableView.state.frame.size.height;
            self.columnHeaderView.state = chv_state;
        }
    } else {
        State state = self.tableView.state;
        state.frame.size.height = self.frame.size.height - verticalInset;
    }
    
    [self resetOverlayViewContentSize:contentInset];
    defer();
}

- (void)resetOverlayViewContentSize:(UIEdgeInsets)contentInset {
    CGFloat width = contentInset.left + contentInset.right + self.tableView.state.frame.origin.x + self.tableView.state.contentSize.width;
    CGFloat hight = contentInset.top + contentInset.bottom + self.tableView.state.frame.origin.y + self.tableView.state.contentSize.height;
    
    self.overlayView.contentSize = CGSizeMake(width, hight);
    CGPoint contentOffset = self.overlayView.contentOffset;
    contentOffset.x = self.tableView.state.contentOffset.x - contentInset.left;
    contentOffset.y = self.tableView.state.contentOffset.y - contentInset.top;
    self.overlayView.contentOffset = contentOffset;
}

- (void)resetScrollViewArrangement {
    [self.tableView removeFromSuperview];
    [self.columnHeaderView removeFromSuperview];
    [self.rowHeaderView removeFromSuperview];
    [self.cornerView removeFromSuperview];
    
    if (self.circularScrollingOptions.headerStyle == HeaderStyle_columnHeaderStartsFirstRow) {
        [self.rootView addSubview:self.tableView];
        [self.rootView addSubview:self.rowHeaderView];
        [self.rootView addSubview:self.columnHeaderView];
        [self.rootView addSubview:self.cornerView];
    } else {
        [self.rootView addSubview:self.tableView];
        [self.rootView addSubview:self.columnHeaderView];
        [self.rootView addSubview:self.rowHeaderView];
        [self.rootView addSubview:self.cornerView];
    }
}

- (NSInteger)findIndex:(NSArray<NSNumber *> *)records offset:(CGFloat)offset {
    NSInteger index = [records insertionIndexOfObject:@(offset)];
    return index == 0 ? 0 : index - 1;
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
