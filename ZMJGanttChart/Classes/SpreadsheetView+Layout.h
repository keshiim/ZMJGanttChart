//
//  SpreadsheetView+Layout.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import "SpreadsheetView.h"
#import "ZMJScrollView.h"
#import "ZMJLayoutEngine.h"

@interface SpreadsheetView (Layout)

- (LayoutAttributes)layoutAttributeForCornerView;
- (LayoutAttributes)layoutAttributeForColumnHeaderView;
- (LayoutAttributes)layoutAttributeForRowHeaderView;
- (LayoutAttributes)layoutAttributeForTableView;
- (ZMJLayoutProperties *)resetLayoutProperties;

- (void)resetContentSize:(ZMJScrollView *)scrollView;
- (void)resetScrollViewFrame;
- (void)resetOverlayViewContentSize:(UIEdgeInsets)contentInset;
- (void)resetScrollViewArrangement;
- (NSInteger)findIndex:(NSArray<NSNumber *> *)records offset:(CGFloat)offset;

@end
