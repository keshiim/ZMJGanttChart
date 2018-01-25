//
//  SpreadsheetView+UIScrollView.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/25.
//

#import "SpreadsheetView.h"

@interface SpreadsheetView (UIScrollView)
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign) UIEdgeInsets scrollIndicatorInsets;
@property (nonatomic, assign, readonly) CGSize contentSize;
@property (nonatomic, assign) UIEdgeInsets contentInset;

#ifdef __IPHONE_11_0
@property (nonatomic, assign, readonly) UIEdgeInsets adjustedContentInset;
#endif


- (void)flashScrollIndicators;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;
@end
