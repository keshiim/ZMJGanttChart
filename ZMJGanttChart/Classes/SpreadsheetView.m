//
//  SpreadsheetView.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import "SpreadsheetView.h"
#import "ZMJScrollView.h"
#import "ReuseQueue.h"
#import "NSArray+WBGAddition.h"
#import "ZMJLayoutEngine.h"
#import "SpreadsheetView+Layout.h"
#import "SpreadsheetView+CirclularScrolling.h"
#import "SpreadsheetView+Touches.h"
#import "NSIndexPath+column.h"

@interface SpreadsheetView () <UIScrollViewDelegate>
@property (nonatomic, strong) ZMJLayoutProperties *layoutProperties;

@property (nonatomic, strong) UIScrollView *rootView;
@property (nonatomic, strong) UIScrollView *overlayView;

@property (nonatomic, strong) ZMJScrollView *columnHeaderView;
@property (nonatomic, strong) ZMJScrollView *rowHeaderView;
@property (nonatomic, strong) ZMJScrollView *cornerView;
@property (nonatomic, strong) ZMJScrollView *tableView;

@property (nonatomic, strong) NSMutableDictionary<NSString *, Class  > *cellClasses;
@property (nonatomic, strong) NSMutableDictionary<NSString *, UINib *> *cellNibs;
@property (nonatomic, strong) NSMutableDictionary<NSString *, ReuseQueue<ZMJCell *> *> *cellReuseQueues;
@property (nonatomic, strong) NSString *blankCellReuseIdentifier;

@property (nonatomic, strong) ReuseQueue<Gridline *> *horizontalGridlineReuseQueue;
@property (nonatomic, strong) ReuseQueue<Gridline *> *verticalGridlineReuseQueue;
@property (nonatomic, strong) ReuseQueue<Borders *> *borderReuseQueue;

@property (nonatomic, strong) NSSet<NSIndexPath *> *highlightedIndexPaths;
@property (nonatomic, strong) NSSet<NSIndexPath *> *selectedIndexPaths;
@property (nonatomic, strong) NSIndexPath          *pendingSelectionIndexPath;
@property (nonatomic, strong) UITouch              *currentTouch;

@property (nonatomic, assign) BOOL needsReload;

@property (nonatomic, strong) NSArray<ZMJCell *> *visibleCells;
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
    
    self.circularScrolling = Configuration.none;
    self.circularScrollingOptions = Configuration.none.options;
    self.circularScrollScalingFactor = CircularScrollScalingFactorMake(1, 1);
    self.centerOffset = CGPointZero;
    
    self.directionalLockEnabled = NO;
    
    self.stickyRowHeader    = NO;
    self.stickyColumnHeader = NO;
    
    self.layoutProperties = [ZMJLayoutProperties new];
    
    self.rootView    = [UIScrollView new];
    self.overlayView = [UIScrollView new];
    
    self.columnHeaderView = [ZMJScrollView new];
    self.rowHeaderView    = [ZMJScrollView new];
    self.cornerView       = [ZMJScrollView new];
    self.tableView        = [ZMJScrollView new];
    
    self.cellClasses = [NSMutableDictionary new];
    self.cellNibs    = [NSMutableDictionary new];
    self.cellReuseQueues          = [NSMutableDictionary new];
    self.blankCellReuseIdentifier = [NSUUID UUID].UUIDString;
    
    self.horizontalGridlineReuseQueue = [ReuseQueue new];
    self.verticalGridlineReuseQueue   = [ReuseQueue new];
    self.borderReuseQueue             = [ReuseQueue new];
    
    self.highlightedIndexPaths = [NSSet new];
    self.selectedIndexPaths    = [NSSet new];

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
    self.columnHeaderView.frame = frame;
    self.columnHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.columnHeaderView.autoresizesSubviews = NO;
    self.columnHeaderView.showsHorizontalScrollIndicator = NO;
    self.columnHeaderView.showsVerticalScrollIndicator = NO;
    self.columnHeaderView.hidden = YES;
    self.columnHeaderView.delegate = self;
    
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
    
    [@[self.tableView, self.columnHeaderView, self.rowHeaderView, self.cornerView, self.overlayView] enumerateObjectsUsingBlock:^(UIScrollView* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addGestureRecognizer:obj.panGestureRecognizer];
        if (IOS_VERSION_11_OR_LATER && [obj respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            if (@available(iOS 11.0, *)) {
                obj.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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
    
    [self.cornerView resetReusableObjects];
    [self.columnHeaderView resetReusableObjects];
    [self.rowHeaderView resetReusableObjects];
    [self.tableView resetReusableObjects];
    
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
    
    if (self.blankCellReuseIdentifier) {
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
    
    [NSExpression expressionWithFormat:@"could not dequeue a view with identifier cell - must register a nib or a class for the identifier"];
    return nil;
}

- (void)resetTouchHandlers:(NSArray<ZMJScrollView *> *)scrollViews {
    __weak typeof(self)weak_self = self;
    [scrollViews enumerateObjectsUsingBlock:^(ZMJScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.dataSource) {
            obj.touchesBegan = ^(NSSet<UITouch *> *touches, UIEvent *event){
                [weak_self touchesBegan:touches event:event];
            };
            obj.touchesEnded = ^(NSSet<UITouch *> *touches, UIEvent *event) {
                [weak_self touchesEnded:touches event:event];
            };
            obj.touchesCancelled = ^(NSSet<UITouch *> *touches, UIEvent *event) {
                [weak_self touchesCancelled:touches event:event];
            };
        } else {
            obj.touchesBegan     = nil;
            obj.touchesEnded     = nil;
            obj.touchesCancelled = nil;
        }
    }];
}

- (void)scrollToItemIndexPath:(NSIndexPath *)indexPath at:(ZMJScrollPosition)scrollPosition animated:(BOOL)animated {
    
}

- (CGPoint)contentOffsetForScrollingToItem:(NSIndexPath *)indexPath scrollPosition:(ZMJScrollPosition)scrollPosition {
    NSInteger column = indexPath.column;
    NSInteger row    = indexPath.row;
    
    if (column >= self.numberOfColumns || row >= self.numberOfRows) {
        [NSExpression expressionWithFormat:@"attempt to scroll to invalid index path: {column = %ld, row = %ld}", (long)column, (long)row];
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
    
}

- (NSIndexPath *)indexPathForItemAt:(CGPoint)location scrollView:(ZMJScrollView *)scrollView {
    return nil;
}

- (ZMJCellRange *)mergedCellFor:(Location *)indexPath {
    
}

- (CGPoint)contentOffsetForScrollingToItemIndexPath:(NSIndexPath *)indexPath at:(ZMJScrollPosition)scrollPosition {
    
}

- (void)deselectAllItems:(BOOL)animated {
    
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
        self.showsHorizontalScrollIndicator = NO;
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
    return _indexPathForSelectedItem = [self.selectedIndexPaths.allObjects sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath*  _Nonnull obj1, NSIndexPath*  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }].firstObject;
}

- (NSArray<NSIndexPath *> *)indexPathsForSelectedItems {
    return _indexPathsForSelectedItems = [self.selectedIndexPaths.allObjects sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath*  _Nonnull obj1, NSIndexPath*  _Nonnull obj2) {
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
