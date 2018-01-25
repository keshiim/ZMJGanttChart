//
//  SpreadsheetView+UIViewHierarchy.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/25.
//

#import "SpreadsheetView+UIViewHierarchy.h"

@implementation SpreadsheetView (UIViewHierarchy)

///Override
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [self.overlayView insertSubview:view atIndex:index];
}

- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2 {
    [self.overlayView exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
}

- (void)addSubview:(UIView *)view {
    [self.overlayView addSubview:view];
}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview {
    [self.overlayView insertSubview:view belowSubview:siblingSubview];
}

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
    [self.overlayView insertSubview:view aboveSubview:siblingSubview];
}

- (void)bringSubviewToFront:(UIView *)view {
    [self.overlayView bringSubviewToFront:view];
}

- (void)sendSubviewToBack:(UIView *)view {
    [self.overlayView sendSubviewToBack:view];
}

@end
