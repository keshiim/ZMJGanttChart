//
//  ZMJScrollView.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/19.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "ZMJScrollView.h"

@interface ZMJScrollView() <UIGestureRecognizerDelegate>

@end

@implementation ZMJScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    _columnRecords = [NSMutableArray new];
    _rowRecords    = [NSMutableArray new];
    
    _visibleCells               = [ReusableCollection new];
    _visibleVerticalGridlines   = [ReusableCollection new];
    _visibleHorizontalGridlines = [ReusableCollection new];
    _visibleBorders             = [ReusableCollection new];
    
    _state = (State){CGRectZero, CGSizeZero, CGPointZero};
}

- (BOOL)hasDisplayedContent {
    return self.columnRecords.count > 0 || self.rowRecords.count > 0;
}

- (void)resetReusableObjects {
    for (ZMJCell *cell in _visibleCells) {
        [cell removeFromSuperview];
    }
    for (Gridline *gridline in _visibleVerticalGridlines) {
        [gridline removeFromSuperlayer];
    }
    for (Gridline *gridline in _visibleHorizontalGridlines) {
        [gridline removeFromSuperlayer];
    }
    for (Border *border in _visibleBorders) {
        [border removeFromSuperview];
    }
    _visibleCells               = [ReusableCollection new];
    _visibleVerticalGridlines   = [ReusableCollection new];
    _visibleHorizontalGridlines = [ReusableCollection new];
    _visibleBorders             = [ReusableCollection new];
}

#pragma mark - Gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

#pragma mark - UIScrollView override touches
- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    return self.hasDisplayedContent;
}

#pragma mark - UIResponse override touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.hasDisplayedContent) {
        return;
    }
    self.touchesBegan(touches, event);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.hasDisplayedContent) {
        return;
    }
    self.touchesEnded(touches, event);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.hasDisplayedContent) {
        return;
    }
    self.touchesCancelled(touches, event);
}

@end

