//
//  ZMJLayoutEngine.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <Foundation/Foundation.h>
#import "ZMJScrollView.h"
#import "Define.h"

@class ZMJCellRange;
@class Location;
@class ZMJScrollView;
@class SpreadsheetView;
#pragma mark - Class interface
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


@interface ZMJLayoutEngine : NSObject
- (instancetype)initWithSpreadsheetView:(SpreadsheetView *)spreadsheetView scrollView:(ZMJScrollView *)scrollView;
+ (instancetype)spreadsheetView:(SpreadsheetView *)spreadsheetView scrollView:(ZMJScrollView *)scrollView;

- (void)layout;
@end

