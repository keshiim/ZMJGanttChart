//
//  SpreadsheetView.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import "SpreadsheetView.h"
#import "ReuseQueue.h"
#import "NSArray+WBGAddition.h"
#import "NSDictionary+WBGAdd.h"
#import "SpreadsheetView+Layout.h"
#import "SpreadsheetView+CirclularScrolling.h"
#import "SpreadsheetView+Touches.h"
#import "NSIndexPath+column.h"
#import "Address.h"
#import "Location.h"
#import "ZMJCellRange.h"

@interface SpreadsheetView ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, Class  > *cellClasses;
@property (nonatomic, strong) NSMutableDictionary<NSString *, UINib *> *cellNibs;

@property (nonatomic, assign) BOOL needsReload;

@property (nonatomic, strong) NSArray<ZMJCell *> *visibleCells;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation SpreadsheetView

@synthesize bounces = _bounces;
@synthesize alwaysBounceVertical   = _alwaysBounceVertical;
@synthesize alwaysBounceHorizontal = _alwaysBounceHorizontal;
@synthesize pagingEnabled    = _pagingEnabled;
@synthesize scrollEnabled    = _scrollEnabled;
@synthesize indicatorStyle   = _indicatorStyle;
@synthesize decelerationRate = _decelerationRate;

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.intercellSpacing = CGSizeMake(1, 1);
    
    self.allowsSelection = YES;
    self.allowsMultipleSelection = NO;
    
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = YES;
    
    self.scrollsToTop = YES;
    
    self.circularScrolling = [Configuration instance].none;
    self.circularScrollingOptions = [Configuration instance].none.options;
    self.circularScrollScalingFactor = CircularScrollScalingFactorMake(1, 1);
    self.centerOffset = CGPointZero;
    
    self.directionalLockEnabled = NO;
    
    self.stickyRowHeader    = NO;
    self.stickyColumnHeader = NO;
    
    self.layoutProperties = [ZMJLayoutProperties new];

    self.needsReload = YES;
    ////////////////////////////////////////////////////////
    self.rootView.frame = self.bounds;
    self.rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.rootView.showsHorizontalScrollIndicator = NO;
    self.rootView.showsVerticalScrollIndicator = NO;
    self.rootView.delegate = self;
    [super addSubview:self.rootView];
    
    self.tableView.frame = self.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.autoresizesSubviews = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    
    CGRect frame = self.bounds;
    frame.size.width = 0;
    self.columnHeaderView.frame = frame;
    self.columnHeaderView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.columnHeaderView.autoresizesSubviews = NO;
    self.columnHeaderView.showsHorizontalScrollIndicator = NO;
    self.columnHeaderView.showsVerticalScrollIndicator = NO;
    self.columnHeaderView.hidden = YES;
    self.columnHeaderView.delegate = self;
    
    frame = self.bounds;
    frame.size.height = 0;
    self.rowHeaderView.frame = frame;
    self.rowHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.rowHeaderView.autoresizesSubviews = NO;
    self.rowHeaderView.showsHorizontalScrollIndicator = NO;
    self.rowHeaderView.showsVerticalScrollIndicator = NO;
    self.rowHeaderView.hidden = YES;
    self.rowHeaderView.delegate = self;
    
    self.cornerView.autoresizesSubviews = NO;
    self.cornerView.hidden = YES;
    self.cornerView.delegate = self;
    
    self.overlayView.frame = self.bounds;
    self.overlayView.autoresizingMask    = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.overlayView.autoresizesSubviews = NO;
    self.overlayView.userInteractionEnabled = NO;
    
    [self.rootView addSubview:self.tableView];
    [self.rootView addSubview:self.columnHeaderView];
    [self.rootView addSubview:self.rowHeaderView];
    [self.rootView addSubview:self.cornerView];
    [super addSubview:self.overlayView];
    
    __weak typeof(self)weak_self = self;
    [@[self.tableView, self.columnHeaderView, self.rowHeaderView, self.cornerView, self.overlayView] enumerateObjectsUsingBlock:^(UIScrollView* _Nonnull scrollView, NSUInteger idx, BOOL * _Nonnull stop) {
        //FIXME: HERE💥
        [weak_self addGestureRecognizer:scrollView.panGestureRecognizer];
        if (IOS_VERSION_11_OR_LATER && [scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            if (@available(iOS 11.0, *)) {
                scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
    }];
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    self.cellClasses[identifier] = cellClass;
}

- (void)registerNib:(UINib *)cellNib forCellWithReuseIdentifier:(NSString *)identifier {
    self.cellNibs[identifier] = cellNib;
}

- (void)reloadData {
    self.layoutProperties            = [self resetLayoutProperties];
    self.circularScrollScalingFactor = [self determineCircularScrollScalingFactor];
    self.centerOffset = [self calculateCenterOffset];
    
    self.cornerView.layoutAttributes       = [self layoutAttributeForCornerView];
    self.columnHeaderView.layoutAttributes = [self layoutAttributeForColumnHeaderView];
    self.rowHeaderView.layoutAttributes    = [self layoutAttributeForRowHeaderView];
    self.tableView.layoutAttributes        = [self layoutAttributeForTableView];
    
    [self.cornerView       resetReusableObjects];
    [self.columnHeaderView resetReusableObjects];
    [self.rowHeaderView    resetReusableObjects];
    [self.tableView        resetReusableObjects];
    
    [self resetContentSize:self.cornerView];
    [self resetContentSize:self.columnHeaderView];
    [self resetContentSize:self.rowHeaderView];
    [self resetContentSize:self.tableView];
    
    [self resetScrollViewFrame];
    [self resetScrollViewArrangement];
    
    if ((self.circularScrollingOptions.direction & Direction_horizontally) && self.tableView.contentOffset.x == 0) {
        [self scrollToHorizontalCenter];
    }
    if ((self.circularScrollingOptions.direction & Direction_vertically) && self.tableView.contentOffset.y == 0) {
        [self scrollToVerticalCenter];
    }
    
    self.needsReload = NO;
    [self setNeedsLayout];
}

- (void)reloadDataIfNeeded {
    if (self.needsReload) {
        [self reloadData];
    }
}

- (void)set_needsReload {
    self.needsReload = YES;
    [self setNeedsLayout];
}

- (ZMJCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    ReuseQueue<ZMJCell *> * reuseQueue = [self.cellReuseQueues objectForKey:identifier];
    if (reuseQueue) {
        ZMJCell *cell = [reuseQueue dequeue];
        if (cell) {
            [cell preppareForReuse];
            return cell;
        }
    } else {
        reuseQueue = [ReuseQueue new];
        self.cellReuseQueues[identifier] = reuseQueue;
    }
    
    if ([identifier isEqualToString:self.blankCellReuseIdentifier]) {
        ZMJCell *cell = [BlankCell new];
        cell.reuseIdentifier = self.blankCellReuseIdentifier;
        return cell;
    }
    Class clazz = [self.cellClasses objectForKey:identifier];
    if (clazz) {
        ZMJCell *cell = [clazz new];
        cell.reuseIdentifier = identifier;
        return cell;
    }
    UINib *nib = [self.cellNibs objectForKey:identifier];
    if (nib) {
        ZMJCell *cell = (ZMJCell *)[nib instantiateWithOwner:nil options:nil].firstObject;
        if (cell) {
            cell.reuseIdentifier = identifier;
            return cell;
        }
    }
    
    [NSException exceptionWithName:@"" reason:@"could not dequeue a view with identifier cell - must register a nib or a class for the identifier" userInfo:nil];
    return nil;
}

- (void)resetTouchHandlers:(NSArray<ZMJScrollView *> *)scrollViews {
    __weak typeof(self)weak_self = self;
    [scrollViews enumerateObjectsUsingBlock:^(ZMJScrollView * _Nonnull scrollView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.dataSource) {
            scrollView.touchesBegan = ^(NSSet<UITouch *> *touches, UIEvent *event){
                [weak_self touchesBegan:touches event:event];
            };
            scrollView.touchesEnded = ^(NSSet<UITouch *> *touches, UIEvent *event) {
                [weak_self touchesEnded:touches event:event];
            };
            scrollView.touchesCancelled = ^(NSSet<UITouch *> *touches, UIEvent *event) {
                [weak_self touchesCancelled:touches event:event];
            };
        } else {
            scrollView.touchesBegan     = nil;
            scrollView.touchesEnded     = nil;
            scrollView.touchesCancelled = nil;
        }
    }];
}

- (void)scrollToItemIndexPath:(NSIndexPath *)indexPath at:(ZMJScrollPosition)scrollPosition animated:(BOOL)animated {
    CGPoint contentOffset = [self contentOffsetForScrollingToItem:indexPath scrollPosition:scrollPosition];
    [self.tableView setContentOffset:contentOffset animated:animated];
}

- (CGPoint)contentOffsetForScrollingToItem:(NSIndexPath *)indexPath scrollPosition:(ZMJScrollPosition)scrollPosition {
    NSInteger column = indexPath.column;
    NSInteger row    = indexPath.row;
    
    if (column >= self.numberOfColumns || row >= self.numberOfRows) {
        [NSException exceptionWithName:@"" reason:[NSString stringWithFormat:@"attempt to scroll to invalid index path: {column = %ld, row = %ld}", (long)column, (long)row] userInfo:nil];
    }
    
    NSMutableArray<NSNumber *> *columnRecords = [NSMutableArray new];
    NSMutableArray<NSNumber *> *rowRecords = [NSMutableArray new];
    [columnRecords addObjectsFromArray:self.columnHeaderView.columnRecords];
    [columnRecords addObjectsFromArray:self.tableView.columnRecords];
    [rowRecords addObjectsFromArray:self.rowHeaderView.rowRecords];
    [rowRecords addObjectsFromArray:self.tableView.rowRecords];
    
    CGPoint contentOffset = CGPointMake(columnRecords[column].floatValue, rowRecords[row].floatValue);
    CGFloat width;
    CGFloat height;
    ZMJCellRange *mergedCell = [self mergedCellFor:[Location indexPath:indexPath]];
    if (mergedCell) {
        width = [[self.layoutProperties.columnWidthCache wbg_reduceWithIndex:^NSNumber* _Nonnull(NSNumber* _Nullable prev, NSNumber * _Nonnull curr, NSUInteger idx) {
            CGFloat total = 0.f;
            if (idx >= mergedCell.from.column && idx <= mergedCell.to.column) {
                total = prev.floatValue + curr.floatValue;
            }
            return @(total);
        }] floatValue] + self.intercellSpacing.width;
        height = [[self.layoutProperties.rowHeightCache wbg_reduceWithIndex:^NSNumber* _Nonnull(NSNumber* _Nullable prev, NSNumber * _Nonnull curr, NSUInteger idx) {
            CGFloat total = 0.0f;
            if (idx >= mergedCell.from.row && idx <= mergedCell.to.row) {
                total = prev.floatValue + curr.floatValue;
            }
            return @(total);
        }] floatValue] + self.intercellSpacing.height;
    } else {
        width = self.layoutProperties.columnWidthCache[indexPath.column].floatValue;
        height = self.layoutProperties.rowHeightCache[indexPath.row].floatValue;
    }
    
    if (self.circularScrollingOptions.direction & Direction_horizontally) {
        if (contentOffset.x > self.centerOffset.x) {
            contentOffset.x -= self.centerOffset.x;
        } else {
            contentOffset.x += self.centerOffset.x;
        }
    }
    NSInteger horizontalGroupCount = 0;
    if (scrollPosition & ScrollPosition_left) {
        horizontalGroupCount += 1;
    }
    if (scrollPosition & ScrollPosition_centeredHorizontally) {
        horizontalGroupCount += 1;
        contentOffset.x = MAX(self.tableView.contentOffset.x + (contentOffset.x - (self.tableView.contentOffset.x + (self.tableView.frame.size.width - (width + self.intercellSpacing.width * 2)) / 2)), 0);
    }
    if (scrollPosition & ScrollPosition_right) {
        horizontalGroupCount += 1;
        contentOffset.x = MAX(contentOffset.x - self.tableView.frame.size.width + width + self.intercellSpacing.width * 2, 0);
    }
    
    if (self.circularScrollingOptions.direction & Direction_vertically) {
        if (contentOffset.y > self.centerOffset.y) {
            contentOffset.y -= self.centerOffset.y;
        } else {
            contentOffset.y += self.centerOffset.y;
        }
    }
    NSInteger verticalGroupCount = 0;
    if (scrollPosition & ScrollPosition_top) {
        verticalGroupCount += 1;
    }
    if (scrollPosition & ScrollPosition_centeredVertiically) {
        verticalGroupCount += 1;
        contentOffset.y = MAX(self.tableView.contentOffset.y + contentOffset.y - (self.tableView.contentOffset.y + (self.tableView.frame.size.height - (height + self.intercellSpacing.height * 2)) / 2), 0);
    }
    if (scrollPosition & ScrollPosition_bottom) {
        verticalGroupCount += 1;
        contentOffset.y = MAX(contentOffset.y - self.tableView.frame.size.height + height + self.intercellSpacing.height * 2, 0);
    }
    
    CGFloat distanceFromRightEdge = self.tableView.contentSize.width - contentOffset.x;
    if (distanceFromRightEdge < self.tableView.frame.size.width) {
        contentOffset.x -= self.tableView.frame.size.width - distanceFromRightEdge;
    }
    CGFloat distanceFromBottomEdge = self.tableView.contentSize.height - contentOffset.y;
    if (distanceFromBottomEdge < self.tableView.frame.size.height) {
        contentOffset.y -= self.tableView.frame.size.height - distanceFromBottomEdge;
    }
    
    if (horizontalGroupCount > 1) {
        [NSException exceptionWithName:@"" reason:@"attempt to use a scroll position with multiple horizontal positioning styles" userInfo:nil];
    }
    if (verticalGroupCount > 1) {
        [NSException exceptionWithName:@"" reason:@"attempt to use a scroll position with multiple vertical positioning styles" userInfo:nil];
    }
    if (contentOffset.x < 0) {
        contentOffset.x = 0;
    }
    if (contentOffset.y < 0) {
        contentOffset.y = 0;
    }
    return contentOffset;
}

- (void)selectItemIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(ZMJScrollPosition)scrollPosition {
    if (!indexPath) {
        [self deselectAllItems:animated];
        return;
    }
    if (!self.allowsSelection) {
        return;
    }
    if (!self.allowsMultipleSelection) { //single select
        [self.selectedIndexPaths removeObject:indexPath];
        [self deselectAllItems:animated];
    }
    
    //mutable select
    [self.selectedIndexPaths addObject:indexPath];
    if (scrollPosition != 0) {
        [self scrollToItemIndexPath:indexPath at:scrollPosition animated:animated];
        if (animated) {
            self.pendingSelectionIndexPath = indexPath;
            return;
        }
    }
    [[self cellsForItemAt:indexPath] enumerateObjectsUsingBlock:^(ZMJCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell setSelected:YES animated:animated]; // set selected State
    }];
}

- (void)deselectItemIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [[self cellsForItemAt:indexPath] enumerateObjectsUsingBlock:^(ZMJCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell setSelected:NO animated:animated];
    }];
    [self.selectedIndexPaths removeObject:indexPath];
}

- (void)deselectAllItems:(BOOL)animated {
    [self.selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        [self deselectItemIndexPath:indexPath animated:animated];
    }];
}

- (NSIndexPath *)indexPathForItemAt:(CGPoint)point {
    NSInteger row =0, column = 0;
    
    NSIndexPath *indexPath;
    if (CGRectContainsPoint([self.tableView convertRect:self.tableView.bounds toView:self], point) &&
        (indexPath = [self indexPathForItemAt:point scrollView:self.tableView]))
    {
        row = indexPath.row + self.frozenRows;
        column = indexPath.column + self.frozenColumns;
    } else if (CGRectContainsPoint([self.rowHeaderView convertRect:self.rowHeaderView.bounds toView:self], point) &&
               (indexPath = [self indexPathForItemAt:point scrollView:self.rowHeaderView]))
    {
        row = indexPath.row;
        column = indexPath.column + self.frozenColumns;
    } else if (CGRectContainsPoint([self.columnHeaderView convertRect:self.columnHeaderView.bounds toView:self], point) &&
               (indexPath = [self indexPathForItemAt:point scrollView:self.columnHeaderView]))
    {
        row = indexPath.row + self.frozenRows;
        column = indexPath.column;
    } else {
        return nil;
    }
    
    row = row % self.numberOfRows;
    column = column % self.numberOfColumns;
    
    Location *location = [Location locationWithRow:row column:column];
    ZMJCellRange *mergedCell = [self mergedCellFor:location];
    if (mergedCell) {
        return [NSIndexPath indexPathWithRow:mergedCell.from.row column:mergedCell.from.column];
    }
    return [NSIndexPath indexPathWithRow:location.row column:location.column];
}

- (NSIndexPath *)indexPathForItemAt:(CGPoint)location scrollView:(ZMJScrollView *)scrollView {
    CGFloat insetX = scrollView.layoutAttributes.insets.x;
    CGFloat insetY = scrollView.layoutAttributes.insets.y;
    
    __weak typeof(self)weak_self = self;
    BOOL(^isPointInColumn)(CGFloat x, NSInteger column) = ^BOOL(CGFloat x, NSInteger column) {
        if (column >= scrollView.columnRecords.count) {
            return NO;
        }
        CGFloat minX = scrollView.columnRecords[column].floatValue + weak_self.intercellSpacing.width;
        CGFloat maxX = minX + weak_self.layoutProperties.columnWidthCache[(column + scrollView.layoutAttributes.startColumn) % weak_self.numberOfColumns].floatValue;
        return x >= minX && x <= maxX;
    };
    
    BOOL(^isPointInRow)(CGFloat y, NSInteger row) = ^BOOL(CGFloat y, NSInteger row) {
        if (row >= scrollView.rowRecords.count) {
            return NO;
        }
        CGFloat minY = scrollView.rowRecords[row].floatValue + weak_self.intercellSpacing.height;
        CGFloat maxY = minY + weak_self.layoutProperties.rowHeightCache[(row + scrollView.layoutAttributes.startRow) % weak_self.numberOfRows].floatValue;
        return y >= minY && y <= maxY;
    };
    
    CGPoint point    = [self convertPoint:location toView:scrollView];
    NSInteger column = [self findIndex:scrollView.columnRecords offset:point.x - insetX];
    NSInteger row    = [self findIndex:scrollView.rowRecords offset:point.y - insetY];
    BOOL pointInColumn = isPointInColumn(point.x - insetX, column);
    BOOL pointInRow    = isPointInRow(point.y, row);
    if (pointInColumn && pointInRow) {
        return [NSIndexPath indexPathWithRow:row column:column];
    } else if (pointInColumn && pointInRow == NO) {
        if (isPointInRow(point.y - insetY, column)) {
            return [NSIndexPath indexPathWithRow:row + 1 column:column];
        }
        return nil;
    } else if (pointInColumn == NO && pointInRow) {
        if (isPointInColumn(point.x - insetX, column + 1)) {
            return [NSIndexPath indexPathWithRow:row column:column + 1];
        }
        return nil;
    } else if (pointInColumn == NO && pointInRow == NO) {
        if (isPointInColumn(point.x - insetX, column + 1) && isPointInRow(point.y - insetY, row + 1)) {
            return [NSIndexPath indexPathWithRow:row + 1 column:column + 1];
        }
        return nil;
    }
    return nil;
}

- (ZMJCell *)cellForItemAt:(NSIndexPath *)indexPath {
    ZMJCell *cell = nil;
    if ((cell = [[self.tableView.visibleCells.pairs wbg_filter:^BOOL(Address * _Nonnull key, ZMJCell* _Nonnull obj) {
        return key.row == indexPath.row && key.column == indexPath.column;
    }] wbg_toArray:^id _Nonnull(Address * _Nonnull key, ZMJCell* _Nonnull obj) {
        return obj;
    }].firstObject)) {
        return cell;
    }
    
    if ((cell = [[self.rowHeaderView.visibleCells.pairs wbg_filter:^BOOL(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return key.row == indexPath.row && key.column == indexPath.column;
    }] wbg_toArray:^id _Nonnull(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return obj;
    }].firstObject)) {
        return cell;
    }
    
    if ((cell = [[self.columnHeaderView.visibleCells.pairs wbg_filter:^BOOL(Address * _Nonnull key, ZMJCell* _Nonnull obj) {
        return key.row == indexPath.row && key.column == indexPath.column;
    }] wbg_toArray:^id _Nonnull(Address * _Nonnull key, ZMJCell* _Nonnull obj) {
        return obj;
    }].firstObject)) {
        return cell;
    }
    
    if ((cell = [[self.cornerView.visibleCells.pairs wbg_filter:^BOOL(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return key.row == indexPath.row && key.column == indexPath.column;
    }] wbg_toArray:^id _Nonnull(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return obj;
    }].firstObject)) {
        return cell;
    }
    
    return nil;
}

- (NSArray<ZMJCell *> *)cellsForItemAt:(NSIndexPath *)indexPath {
    NSMutableArray<ZMJCell *> *cells = [NSMutableArray array];
    [cells addObjectsFromArray:[[self.tableView.visibleCells.pairs wbg_filter:^BOOL(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return key.row == indexPath.row && key.column == indexPath.column;
    }] wbg_toArray:^id _Nonnull(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return obj;
    }]];
    [cells addObjectsFromArray:[[self.rowHeaderView.visibleCells.pairs wbg_filter:^BOOL(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return key.row == indexPath.row && key.column == indexPath.column;
    }] wbg_toArray:^id _Nonnull(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return obj;
    }]];
    [cells addObjectsFromArray:[[self.columnHeaderView.visibleCells.pairs wbg_filter:^BOOL(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return key.row == indexPath.row && key.column == indexPath.column;
    }] wbg_toArray:^id _Nonnull(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return obj;
    }]];
    [cells addObjectsFromArray:[[self.cornerView.visibleCells.pairs wbg_filter:^BOOL(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return key.row == indexPath.row && key.column == indexPath.column;
    }] wbg_toArray:^id _Nonnull(Address * _Nonnull key, ZMJCell * _Nonnull obj) {
        return obj;
    }]];
    return cells;
}

- (CGRect)rectForItemAt:(NSIndexPath *)indexPath {
    NSInteger column = indexPath.column, row = indexPath.row;
    if (column < 0 || column >= self.numberOfColumns || row < 0 || row >= self.numberOfRows) {
        return CGRectZero;
    }
    
    NSMutableArray<NSNumber *> *columnRecords = [NSMutableArray array];
    [columnRecords addObjectsFromArray:self.columnHeaderView.columnRecords];
    [columnRecords addObjectsFromArray:self.tableView.columnRecords];
    
    NSMutableArray<NSNumber *> *rowRecords = [NSMutableArray array];
    [rowRecords addObjectsFromArray:self.columnHeaderView.rowRecords];
    [rowRecords addObjectsFromArray:self.tableView.rowRecords];
    
    CGPoint origin;
    CGSize  size;
    CGPoint (^originForColumnAndRow)(NSInteger, NSInteger) = ^CGPoint(NSInteger column, NSInteger row) {
        CGFloat x = columnRecords[column].floatValue + (column >= self.frozenColumns ? self.tableView.frame.origin.x : 0) + self.intercellSpacing.width;
        CGFloat y = rowRecords[row].floatValue + (row >= self.frozenRows ? self.tableView.frame.origin.y : 0) + self.intercellSpacing.height;
        return CGPointMake(x, y);
    };
    ZMJCellRange *mergedCell = [self mergedCellFor:[Location locationWithRow:row column:column]];
    if (mergedCell) {
        origin = originForColumnAndRow(mergedCell.from.column, mergedCell.from.row);
        CGFloat width  = 0;
        CGFloat height = 0;
        for (NSInteger i = mergedCell.from.column; i <= mergedCell.to.column; i++) {
            width += self.layoutProperties.columnWidthCache[i].floatValue;
        }
        for (NSInteger i = mergedCell.from.row; i <= mergedCell.to.row; i++) {
            height += self.layoutProperties.rowHeightCache[i].floatValue;
        }
        size = CGSizeMake(width + self.intercellSpacing.width * (mergedCell.columnCount - 1),
                          height + self.intercellSpacing.height * (mergedCell.rowCount - 1));
    } else {
        origin = originForColumnAndRow(column, row);
        CGFloat width  = self.layoutProperties.columnWidthCache[column].floatValue;
        CGFloat height = self.layoutProperties.rowHeightCache[row].floatValue;
        size = CGSizeMake(width, height);
    }
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

- (ZMJCellRange *)mergedCellFor:(Location *)indexPath {
    return self.layoutProperties.mergedCellLayouts[indexPath];
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
- (void)safeAreaInsetsDidChange {
    if (self.backgroundView) {
        [self.backgroundView removeFromSuperview];
        [super insertSubview:self.backgroundView atIndex:0];
    }
}
#endif

#pragma mark - Setter && Getter
- (void)setDataSource:(id<SpreadsheetViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self resetTouchHandlers:@[self.tableView,
                               self.columnHeaderView,
                               self.rowHeaderView,
                               self.cornerView]];
    [self set_needsReload];
}

- (GridStyle *)gridStyle {
    if (!_gridStyle) {
        _gridStyle = [[GridStyle alloc] initWithStyle:GridStyle_solid width:1 color:[UIColor lightGrayColor]];
    }
    return _gridStyle;
}

- (void)setAllowsSelection:(BOOL)allowsSelection {
    _allowsSelection = allowsSelection;
    if (!_allowsSelection) {
        _allowsMultipleSelection = NO;
    }
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    _allowsMultipleSelection = allowsMultipleSelection;
    if (_allowsMultipleSelection) {
        _allowsSelection = YES;
    }
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator {
    _showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    self.overlayView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator {
    _showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    self.overlayView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

- (void)setScrollsToTop:(BOOL)scrollsToTop {
    _scrollsToTop = scrollsToTop;
    self.tableView.scrollsToTop = scrollsToTop;
}

- (void)setCircularScrolling:(id<CircularScrollingConfiguration>)circularScrolling {
    _circularScrolling = circularScrolling;
    
    self.circularScrollingOptions = _circularScrolling.options;
    if (self.circularScrollingOptions.direction & Direction_horizontally) {
        self.showsHorizontalScrollIndicator = NO;
    }
    if (self.circularScrollingOptions.direction & Direction_vertically) {
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
    }
}

- (void)setBackgroundView:(UIView *)backgroundView {
    [_backgroundView removeFromSuperview];
    _backgroundView = backgroundView;
    if (backgroundView) {
        backgroundView.frame = self.bounds;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if (IOS_VERSION_11_OR_LATER) {
            [super insertSubview:backgroundView atIndex:0];
        }
    }
}

- (NSArray<ZMJCell *> *)visibleCells {
    NSMutableArray<ZMJCell *> *cells = [NSMutableArray new];
    [cells addObjectsFromArray:self.columnHeaderView.visibleCells.array];
    [cells addObjectsFromArray:self.rowHeaderView.visibleCells.array];
    [cells addObjectsFromArray:self.cornerView.visibleCells.array];
    [cells addObjectsFromArray:self.tableView.visibleCells.array];
    [cells sortUsingComparator:^NSComparisonResult(ZMJCell*  _Nonnull obj1, ZMJCell*  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    _visibleCells = [cells copy];
    return _visibleCells;
}

- (NSArray<NSIndexPath *> *)indexPathsForVisibleItems {
    return _indexPathsForVisibleItems = [self.visibleCells wbg_map:^id _Nullable(ZMJCell * _Nonnull stuff) {
        return stuff.indexPath;
    }];
}

- (NSIndexPath *)indexPathForSelectedItem {
    return _indexPathForSelectedItem = [self.selectedIndexPaths.array sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath*  _Nonnull obj1, NSIndexPath*  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }].firstObject;
}

- (NSArray<NSIndexPath *> *)indexPathsForSelectedItems {
    return _indexPathsForSelectedItems = [self.selectedIndexPaths.array sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath*  _Nonnull obj1, NSIndexPath*  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
}

- (void)setDirectionalLockEnabled:(BOOL)directionalLockEnabled {
    _directionalLockEnabled = directionalLockEnabled;
    self.tableView.directionalLockEnabled = directionalLockEnabled;
}

- (BOOL)bounces {
    return self.tableView.bounces;
}
- (void)setBounces:(BOOL)bounces {
    self.tableView.bounces = bounces;
}

- (BOOL)alwaysBounceHorizontal {
    return self.tableView.alwaysBounceHorizontal;
}
- (void)setAlwaysBounceHorizontal:(BOOL)alwaysBounceHorizontal  {
    self.tableView.alwaysBounceHorizontal = alwaysBounceHorizontal;
}

- (BOOL)alwaysBounceVertical {
    return self.tableView.alwaysBounceVertical;
}
- (void)setAlwaysBounceVertical:(BOOL)alwaysBounceVertical {
    self.tableView.alwaysBounceVertical = alwaysBounceVertical;
}

- (BOOL)isPagingEnabled {
    return self.tableView.isPagingEnabled;
}
- (void)setPagingEnabled:(BOOL)pagingEnabled {
    self.tableView.pagingEnabled = pagingEnabled;
}

- (BOOL)isScrollEnabled {
    return self.tableView.isScrollEnabled;
}
- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.tableView.scrollEnabled = scrollEnabled;
    self.overlayView.scrollEnabled = scrollEnabled;
}

- (BOOL)isIndicatorStyle {
    return self.overlayView.indicatorStyle;
}
- (void)setIndicatorStyle:(UIScrollViewIndicatorStyle)indicatorStyle {
    self.overlayView.indicatorStyle = indicatorStyle;
}

- (CGFloat)decelerationRate {
    return self.tableView.decelerationRate;
}
- (void)setDecelerationRate:(CGFloat)decelerationRate {
    self.tableView.decelerationRate = decelerationRate;
}

- (NSInteger)numberOfColumns {
    return self.layoutProperties.numberOfColumns;
}
- (NSInteger)numberOfRows {
    return self.layoutProperties.numberOfRows;
}
- (NSInteger)frozenColumns {
    return self.layoutProperties.frozenColumns;
}
- (NSInteger)frozenRows {
    return self.layoutProperties.frozenRows;
}
- (NSArray<ZMJCellRange *> *)mergedCells {
    return self.layoutProperties.mergedCells;
}

- (UIScrollView *)scrollView {
    return self.overlayView;
}

- (UIScrollView *)rootView {
    if (!_rootView) {
        _rootView = [UIScrollView new];
    }
    return _rootView;
}

- (UIScrollView *)overlayView {
    if (!_overlayView) {
        _overlayView = [UIScrollView new];
    }
    return _overlayView;
}

- (ZMJScrollView *)columnHeaderView {
    if (!_columnHeaderView) {
        _columnHeaderView = [ZMJScrollView new];
    }
    return _columnHeaderView;
}
- (ZMJScrollView *)rowHeaderView {
    if (!_rowHeaderView) {
        _rowHeaderView = [ZMJScrollView new];
    }
    return _rowHeaderView;
}
- (ZMJScrollView *)cornerView {
    if (!_cornerView) {
        _cornerView = [ZMJScrollView new];
    }
    return _cornerView;
}
- (ZMJScrollView *)tableView {
    if (!_tableView) {
        _tableView = [ZMJScrollView new];
    }
    return _tableView;
}

- (NSMutableDictionary<NSString *, Class  > *)cellClasses {
    if (!_cellClasses) {
        _cellClasses = [NSMutableDictionary new];
    }
    return _cellClasses;
}

- (NSMutableDictionary<NSString *, UINib *> *)cellNibs {
    if (!_cellNibs) {
        _cellNibs = [NSMutableDictionary dictionary];
    }
    return _cellNibs;
}

- (NSMutableDictionary<NSString *, ReuseQueue<ZMJCell *> *> *)cellReuseQueues {
    if (!_cellReuseQueues) {
        _cellReuseQueues = [NSMutableDictionary dictionary];
    }
    return _cellReuseQueues;
}

- (NSString *)blankCellReuseIdentifier {
    if (!_blankCellReuseIdentifier) {
        _blankCellReuseIdentifier = [NSUUID UUID].UUIDString;
    }
    return _blankCellReuseIdentifier;
}

- (ReuseQueue<Gridline *> *)horizontalGridlineReuseQueue {
    if (!_horizontalGridlineReuseQueue) {
        _horizontalGridlineReuseQueue = [ReuseQueue new];
    }
    return _horizontalGridlineReuseQueue;
}

- (ReuseQueue<Gridline *> *)verticalGridlineReuseQueue {
    if (!_verticalGridlineReuseQueue) {
        _verticalGridlineReuseQueue = [ReuseQueue new];
    }
    return _verticalGridlineReuseQueue;
}

- (ReuseQueue<Border *>  *)borderReuseQueue {
    if (!_borderReuseQueue) {
        _borderReuseQueue = [ReuseQueue new];
    }
    return _borderReuseQueue;
}

- (NSMutableOrderedSet<NSIndexPath *> *)highlightedIndexPaths {
    if (!_highlightedIndexPaths) {
        _highlightedIndexPaths = [NSMutableOrderedSet orderedSet];
    }
    return _highlightedIndexPaths;
}

- (NSMutableOrderedSet<NSIndexPath *> *)selectedIndexPaths {
    if (!_selectedIndexPaths) {
        _selectedIndexPaths = [NSMutableOrderedSet orderedSet];
    }
    return _selectedIndexPaths;
}

@end
