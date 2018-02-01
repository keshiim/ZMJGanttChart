//
//  SpreadsheetView+UIScrollViewDelegate.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/25.
//

#import "SpreadsheetView+UIScrollViewDelegate.h"
#import "SpreadsheetView+Layout.h"

@implementation SpreadsheetView (UIScrollViewDelegate)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.rowHeaderView.delegate    = nil;
    self.columnHeaderView.delegate = nil;
    self.tableView.delegate        = nil;
    
    __weak typeof(self)weak_self = self;
    void (^defer)(void) = ^(void) {
        weak_self.rowHeaderView.delegate    = weak_self;
        weak_self.columnHeaderView.delegate = weak_self;
        weak_self.tableView.delegate        = weak_self;
    };
    
    if (self.tableView.contentOffset.x < 0 && !self.stickyColumnHeader) {
        CGFloat offset = self.tableView.contentOffset.x * -1;
        CGRect frame = self.cornerView.frame;
        frame.origin.x = offset;
        self.cornerView.frame = frame;
        
        frame = self.columnHeaderView.frame;
        frame.origin.x = offset;
        self.columnHeaderView.frame = frame;;
    } else {
        CGRect frame = self.cornerView.frame;
        frame.origin.x = 0;
        self.cornerView.frame = frame;
        frame = self.columnHeaderView.frame;
        frame.origin.x = 0;
        self.columnHeaderView.frame = frame;
    }
    if (self.tableView.contentOffset.y < 0 && !self.stickyRowHeader) {
        CGFloat offset = self.tableView.contentOffset.y * -1;
        CGRect frame = self.cornerView.frame;
        frame.origin.y = offset;
        self.cornerView.frame = frame;
        frame = self.rowHeaderView.frame;
        frame.origin.y = offset;
        self.rowHeaderView.frame = frame;
    } else {
        CGRect frame = self.cornerView.frame;
        frame.origin.y = 0;
        self.cornerView.frame = frame;
        frame = self.rowHeaderView.frame;
        frame.origin.y = 0;
        self.rowHeaderView.frame = frame;
    }
    
    CGPoint offset = self.rowHeaderView.contentOffset;
    offset.x = self.tableView.contentOffset.x;
    self.rowHeaderView.contentOffset = offset;
    
    offset = self.columnHeaderView.contentOffset;
    offset.y = self.tableView.contentOffset.y;
    self.columnHeaderView.contentOffset = offset;
    
    [self setNeedsLayout];
    
    defer();
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.pendingSelectionIndexPath) {
        return;
    }
    NSIndexPath *indexPath =self.pendingSelectionIndexPath;
    [[self cellsForItemAt:indexPath] enumerateObjectsUsingBlock:^(ZMJCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [cell setSelected:YES animated:YES];
    }];
    ![self.delegate respondsToSelector:@selector(spreadsheetView:didSelectItemAt:)]?: [self.delegate spreadsheetView:self didSelectItemAt:indexPath];
    self.pendingSelectionIndexPath = nil;
}

#ifdef __IPHONE_11_0
- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    [self resetScrollViewFrame];
}
#endif

@end
