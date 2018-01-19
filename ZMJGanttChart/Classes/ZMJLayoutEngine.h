//
//  ZMJLayoutEngine.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <Foundation/Foundation.h>
@class ZMJCellRange;

@interface ZMJLayoutEngine : NSObject
- (instancetype)initWithNumberOfColumns:(NSInteger)NumberOfColumns
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
                      mergedCellLayouts:(NSArray<ZMJCellRange *> *)mergedCellLayouts;
@end
