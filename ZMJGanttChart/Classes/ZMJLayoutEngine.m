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
@property (nonatomic, strong) NSString  *blankCellReuseIdentifier;
@property (nonatomic, strong) NSSet<NSIndexPath *> *highlightedIndexPaths;
@property (nonatomic, strong) NSSet<NSIndexPath *> *selectedIndexPaths;

@property (nonatomic, assign) NSInteger frozenColumn;
@property (nonatomic, assign) NSInteger frozenRows;

/// NSNumber who wrapper of <CGFloat>
@property (nonatomic, strong) NSNumber *columnWidthCache;
@property (nonatomic, strong) NSNumber *rowHeightCache;

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
@property (nonatomic, strong) NSNumber *columnRecords;
@property (nonatomic, strong) NSNumber *rowRecords;

@property (nonatomic, strong) NSSet<Address *>                   *mergedCellAddress;
@property (nonatomic, strong) NSDictionary<Address *, NSValue *> *mergedCellRects;  /// NSValue who wrapper of <CGRect>

@property (nonatomic, strong) NSSet<Address *> *visibleCellAddresses;

@property (nonatomic, strong) NSDictionary<Address *, NSValue *> *horizontalGridLayouts; /// NSValue who wrapper of <GridLayout>
@property (nonatomic, strong) NSDictionary<Address *, NSValue *> *verticalGridLayouts;   /// NSValue who wrapper of <GridLayout>

@property (nonatomic, strong) NSSet<Address *> *visibleHorizontalGridAddresses;
@property (nonatomic, strong) NSSet<Address *> *visibleVerticalGridAddresses;
@property (nonatomic, strong) NSSet<Address *> *visibleBorderAddresses;
@end

@implementation ZMJLayoutEngine
- (void)aa {
    GridLayout gl;
    [NSValue value:&gl withObjCType:@encode(GridLayout)];
}
@end

































