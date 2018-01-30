//
//  SpreadsheetView+UIScrollView.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/25.
//

#import "SpreadsheetView+UIScrollView.h"
#import "SpreadsheetView+Layout.h"

@implementation SpreadsheetView (UIScrollView)

- (void)setContentOffset:(CGPoint)contentOffset {
    self.tableView.contentOffset = contentOffset;
}

- (CGPoint)contentOffset {
    return self.tableView.contentOffset;
}

- (void)setScrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets {
    self.overlayView.scrollIndicatorInsets = scrollIndicatorInsets;
}

- (UIEdgeInsets)scrollIndicatorInsets {
    return self.overlayView.scrollIndicatorInsets;
}

- (CGSize)contentSize {
    return self.overlayView.contentSize;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    self.rootView.contentInset = contentInset;
    self.overlayView.contentInset = contentInset;
}

- (UIEdgeInsets)contentInset {
    return self.rootView.contentInset;
}

#ifdef __IPHONE_11_0
- (UIEdgeInsets)adjustedContentInset {
    if (@available(iOS 11.0, *)) {
        return self.rootView.adjustedContentInset;
    } else {
        // Fallback on earlier versions
        return UIEdgeInsetsZero;
    }
}
#endif

#pragma mark - Method
- (void)flashScrollIndicators {
    [self.overlayView flashScrollIndicators];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    [self.tableView setContentOffset:contentOffset animated:animated];
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    [self.tableView scrollRectToVisible:rect animated:animated];
}

- (void)_notifyDidScroll {
    [self resetScrollViewFrame];
}

- (BOOL)isKindOfClass:(Class)aClass {
    if (@available(iOS 11.0, *)) {
        return [super isKindOfClass:aClass];
    } else {
        return [self.rootView isKindOfClass:aClass];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (@available(iOS 11.0, *)) {
        return [super forwardingTargetForSelector:aSelector];
    } else {
        if ([self.overlayView respondsToSelector:aSelector]) {
            return self.overlayView;
        } else {
            return [super forwardingTargetForSelector:aSelector];
        }
    }
}
@end
