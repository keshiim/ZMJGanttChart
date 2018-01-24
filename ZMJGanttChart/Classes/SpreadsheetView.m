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

@interface SpreadsheetView ()
@property (nonatomic, strong) ZMJLayoutProperties *layoutProperties;

@property (nonatomic, strong) UIScrollView *rootView;
@property (nonatomic, strong) UIScrollView *overlayView;

@property (nonatomic, strong) ZMJScrollView *columnHeaderView;
@property (nonatomic, strong) ZMJScrollView *rowHeaderView;
@property (nonatomic, strong) ZMJScrollView *cornerView;
@property (nonatomic, strong) ZMJScrollView *tableView;

@property (nonatomic, strong) NSDictionary<NSString *, Class  > *cellClasses;
@property (nonatomic, strong) NSDictionary<NSString *, UINib *> *cellNibs;
@property (nonatomic, strong) NSDictionary<NSString *, ReuseQueue<ZMJCell *> *> *cellReuseQueues;
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
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {

}

- (void)reloadDataIfNeeded {
    
}

- (CGPoint)contentOffsetForScrollingToItemIndexPath:(NSIndexPath *)indexPath at:(ZMJScrollPosition)scrollPosition {
    
}

- (void)deselectAllItems:(BOOL)animated {
    
}

- (void)set_needsReload {
    _needsReload = YES;
    [self setNeedsLayout];
}

- (void)resetTouchHandlers:(NSArray<ZMJScrollView *> *)scrollViews {
    
}

- (NSIndexPath *)indexPathForItemAt:(CGPoint)location scrollView:(ZMJScrollView *)scrollView {
    return nil;
}

- (ZMJCellRange *)mergedCellFor:(Location *)indexPath {
    
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
