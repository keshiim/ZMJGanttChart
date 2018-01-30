//
//  SpreadsheetView.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import <UIKit/UIKit.h>
#import "SpreadsheetViewDataSource.h"
#import "SpreadsheetViewDelegate.h"
#import "Gridlines.h"
#import "CircualrScrolling.h"
#import "ZMJScrollView.h"
#import "ZMJLayoutEngine.h"

typedef struct CircularScrollScalingFactor {
    NSInteger horizontal;
    NSInteger vertical;
} CircularScrollScalingFactor;

static inline CircularScrollScalingFactor
CircularScrollScalingFactorMake(NSInteger horizontal, NSInteger vertical)
{
    CircularScrollScalingFactor factor;
    factor.horizontal = horizontal;
    factor.vertical   = vertical;
    return factor;
}

@interface SpreadsheetView : UIView
/// The object that provides the data for the collection view.
///
/// - Note: The data source must adopt the `SpreadsheetViewDataSource` protocol.
///   The spreadsheet view maintains a weak reference to the data source object.
@property (nonatomic, weak) id<SpreadsheetViewDataSource> dataSource;

/// The object that acts as the delegate of the spreadsheet view.
/// - Note: The delegate must adopt the `SpreadsheetViewDelegate` protocol.
///   The spreadsheet view maintains a weak reference to the delegate object.
///
///   The delegate object is responsible for managing selection behavior and interactions with individual items.
@property (nonatomic, weak) id<SpreadsheetViewDelegate> delegate;

/// The horizontal and vertical spacing between cells.
///
/// - Note: The default spacing is `(1.0, 1.0)`. Negative values are not supported.
@property (nonatomic, assign) CGSize     intercellSpacing;
@property (nonatomic, strong) GridStyle *gridStyle;

/// A Boolean value that indicates whether users can select cells in the spreadsheet view.
///
/// - Note: If the value of this property is `true` (the default), users can select cells.
///   If you want more fine-grained control over the selection of cells,
///   you must provide a delegate object and implement the appropriate methods of the `SpreadsheetViewDelegate` protocol.
///
/// - SeeAlso: `allowsMultipleSelection`
@property (nonatomic, assign) BOOL allowsSelection;


/// A Boolean value that determines whether users can select more than one cell in the spreadsheet view.
///
/// - Note: This property controls whether multiple cells can be selected simultaneously.
///   The default value of this property is `false`.
///
///   When the value of this property is true, tapping a cell adds it to the current selection (assuming the delegate permits the cell to be selected).
///   Tapping the cell again removes it from the selection.
///
/// - SeeAlso: `allowsSelection`
@property (nonatomic, assign) BOOL allowsMultipleSelection;

/// A Boolean value that controls whether the vertical scroll indicator is visible.
///
/// The default value is `true`. The indicator is visible while tracking is underway and fades out after tracking.
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;

/// A Boolean value that controls whether the horizontal scroll indicator is visible.
///
/// The default value is `true`. The indicator is visible while tracking is underway and fades out after tracking.
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;


/// A Boolean value that controls whether the scroll-to-top gesture is enabled.
///
/// - Note: The scroll-to-top gesture is a tap on the status bar. When a user makes this gesture,
/// the system asks the scroll view closest to the status bar to scroll to the top.
/// If that scroll view has `scrollsToTop` set to `false`, its delegate returns false from `scrollViewShouldScrollToTop(_:)`,
/// or the content is already at the top, nothing happens.
///
/// After the scroll view scrolls to the top of the content view, it sends the delegate a `scrollViewDidScrollToTop(_:)` message.
///
/// The default value of scrollsToTop is `true`.
///
/// On iPhone, the scroll-to-top gesture has no effect if there is more than one scroll view on-screen that has `scrollsToTop` set to `true`.
@property (nonatomic, assign) BOOL scrollsToTop;

@property (nonatomic, strong) id<CircularScrollingConfiguration> circularScrolling;
@property (nonatomic, strong) Options *circularScrollingOptions;
@property (nonatomic, assign) CircularScrollScalingFactor circularScrollScalingFactor;
@property (nonatomic, assign) CGPoint centerOffset;

/// The view that provides the background appearance.
///
/// - Note: The view (if any) in this property is positioned underneath all of the other content and sized automatically to fill the entire bounds of the spreadsheet view.
/// The background view does not scroll with the spreadsheet view’s other content. The spreadsheet view maintains a strong reference to the background view object.
///
/// This property is nil by default, which displays the background color of the spreadsheet view.
@property (nonatomic, strong) UIView *backgroundView;


/// Returns an array of visible cells currently displayed by the spreadsheet view.
///
/// - Note: This method returns the complete list of visible cells displayed by the collection view.
///
/// - Returns: An array of `Cell` objects. If no cells are visible, this method returns an empty array.
@property (nonatomic, strong, readonly) NSArray<ZMJCell *> *visibleCells;

/// An array of the visible items in the collection view.
/// - Note: The value of this property is a sorted array of IndexPath objects, each of which corresponds to a visible cell in the spreadsheet view.
/// If there are no visible items, the value of this property is an empty array.
///
/// - SeeAlso: `visibleCells`
@property (nonatomic, strong) NSArray<NSIndexPath *> *indexPathsForVisibleItems;
@property (nonatomic, strong) NSIndexPath *indexPathForSelectedItem;

/// The index paths for the selected items.
/// - Note: The value of this property is an array of IndexPath objects, each of which corresponds to a single selected item.
/// If there are no selected items, the value of this property is nil.
@property (nonatomic, strong) NSArray<NSIndexPath *> *indexPathsForSelectedItems;

/// A Boolean value that determines whether scrolling is disabled in a particular direction.
/// - Note: If this property is `false`, scrolling is permitted in both horizontal and vertical directions.
/// If this property is `true` and the user begins dragging in one general direction (horizontally or vertically), the scroll view disables scrolling in the other direction.
/// If the drag direction is diagonal, then scrolling will not be locked and the user can drag in any direction until the drag completes.
/// The default value is `false`
@property (nonatomic, assign, getter=isDirectionalLockEnabled) BOOL directionalLockEnabled;

/// A Boolean value that controls whether the scroll view bounces past the edge of content and back again.
/// - Note: If the value of this property is `true`, the scroll view bounces when it encounters a boundary of the content.
/// Bouncing visually indicates that scrolling has reached an edge of the content.
/// If the value is `false`, scrolling stops immediately at the content boundary without bouncing.
/// The default value is `true`.
///
/// - SeeAlso: `alwaysBounceHorizontal`, `alwaysBounceVertical`
@property (nonatomic, assign) BOOL bounces;

/// A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.
/// - Note: If this property is set to true and `bounces` is `true`, vertical dragging is allowed even if the content is smaller than the bounds of the scroll view.
/// The default value is `false`.
///
/// - SeeAlso: `alwaysBounceHorizontal`
@property (nonatomic, assign) BOOL alwaysBounceVertical;

/// A Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.
/// - Note: If this property is set to `true` and `bounces` is `true`, horizontal dragging is allowed even if the content is smaller than the bounds of the scroll view.
/// The default value is `false`.
///
/// - SeeAlso: `alwaysBounceVertical`
@property (nonatomic, assign) BOOL alwaysBounceHorizontal;

/// A Boolean value that determines wheather the row header always sticks to the top.
/// - Note: `bounces` has to be `true` and there has to be at least one `frozenRow`.
/// The default value is `false`.
///
/// - SeeAlso: `stickyColumnHeader`
@property (nonatomic, assign) BOOL stickyRowHeader;

/// A Boolean value that determines wheather the column header always sticks to the top.
/// - Note: `bounces` has to be `true` and there has to be at least one `frozenColumn`.
/// The default value is `false`.
///
/// - SeeAlso: `stickyRowHeader`
@property (nonatomic, assign) BOOL stickyColumnHeader;

/// A Boolean value that determines whether paging is enabled for the scroll view.
/// - Note: If the value of this property is `true`, the scroll view stops on multiples of the scroll view’s bounds when the user scrolls.
/// The default value is false.
@property (nonatomic, assign, getter=isPagingEnabled) BOOL pagingEnabled;

/// A Boolean value that determines whether scrolling is enabled.
/// - Note: If the value of this property is `true`, scrolling is enabled, and if it is `false`, scrolling is disabled. The default is `true`.
///
/// When scrolling is disabled, the scroll view does not accept touch events; it forwards them up the responder chain.
@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;

/// The style of the scroll indicators.
/// - Note: The default style is `default`. See `UIScrollViewIndicatorStyle` for descriptions of these constants.
@property (nonatomic, assign) UIScrollViewIndicatorStyle indicatorStyle;

/// A floating-point value that determines the rate of deceleration after the user lifts their finger.
/// - Note: Your application can use the `UIScrollViewDecelerationRateNormal` and UIScrollViewDecelerationRateFast` constants as reference points for reasonable deceleration rates.
@property (nonatomic, assign) CGFloat decelerationRate;

@property (nonatomic, assign, readonly) NSInteger numberOfColumns;
@property (nonatomic, assign, readonly) NSInteger numberOfRows;
@property (nonatomic, assign, readonly) NSInteger frozenColumns;
@property (nonatomic, assign, readonly) NSInteger frozenRows;
@property (nonatomic, assign, readonly) NSArray<ZMJCellRange *> *mergedCells;

@property (nonatomic, strong) NSString *blankCellReuseIdentifier;

@property (nonatomic, assign, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) ReuseQueue<Gridline *> *horizontalGridlineReuseQueue;
@property (nonatomic, strong) ReuseQueue<Gridline *> *verticalGridlineReuseQueue;
@property (nonatomic, strong) ReuseQueue<Border *>  *borderReuseQueue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, ReuseQueue<ZMJCell *> *> *cellReuseQueues;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

- (void)registerNib:(UINib *)cellNib forCellWithReuseIdentifier:(NSString *)identifier;

- (void)reloadData;

- (ZMJCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier  forIndexPath:(NSIndexPath *)indexPath;

- (void)scrollToItemIndexPath:(NSIndexPath *)indexPath at:(ZMJScrollPosition)scrollPosition animated:(BOOL)animated;

- (void)selectItemIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(ZMJScrollPosition)scrollPosition;

- (void)deselectItemIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

- (NSIndexPath *)indexPathForItemAt:(CGPoint)point;

- (ZMJCell *)cellForItemAt:(NSIndexPath *)indexPath;

- (NSArray<ZMJCell *> *)cellsForItemAt:(NSIndexPath *)indexPath;

- (CGRect)rectForItemAt:(NSIndexPath *)indexPath;

- (ZMJCellRange *)mergedCellFor:(Location *)indexPath;


/// For category
@property (nonatomic, strong) NSMutableOrderedSet<NSIndexPath *> *highlightedIndexPaths;
@property (nonatomic, strong) NSMutableOrderedSet<NSIndexPath *> *selectedIndexPaths;
@property (nonatomic, strong) UITouch              *currentTouch;

@property (nonatomic, strong) ZMJScrollView *columnHeaderView;
@property (nonatomic, strong) ZMJScrollView *rowHeaderView;
@property (nonatomic, strong) ZMJScrollView *cornerView;
@property (nonatomic, strong) ZMJScrollView *tableView;
@property (nonatomic, strong) UIScrollView  *overlayView;
@property (nonatomic, strong) UIScrollView  *rootView;
@property (nonatomic, strong) ZMJLayoutProperties *layoutProperties;
@property (nonatomic, strong) NSIndexPath          *pendingSelectionIndexPath;

@end

@interface SpreadsheetView (ForCategory) <UIScrollViewDelegate>
- (void)reloadDataIfNeeded;
@end
