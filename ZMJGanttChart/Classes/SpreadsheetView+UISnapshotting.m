//
//  SpreadsheetView+UISnapshotting.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/25.
//

#import "SpreadsheetView+UISnapshotting.h"

@implementation SpreadsheetView (UISnapshotting)

- (UIView *)resizableSnapshotViewFromRect:(CGRect)rect afterScreenUpdates:(BOOL)afterUpdates withCapInsets:(UIEdgeInsets)capInsets {
    if (CGRectIntersectsRect(self.cornerView.frame, [self.cornerView convertRect:rect toView:self])) {
        return [self.cornerView resizableSnapshotViewFromRect:CGRectOffset(rect, -self.cornerView.frame.origin.x, -self.cornerView.frame.origin.y)
                                           afterScreenUpdates:afterUpdates
                                                withCapInsets:capInsets];
    }
    
    if (CGRectIntersectsRect(self.columnHeaderView.frame, [self.columnHeaderView convertRect:rect toView:self])) {
        return [self.columnHeaderView resizableSnapshotViewFromRect:CGRectOffset(rect, -self.columnHeaderView.frame.origin.x, -self.columnHeaderView.frame.origin.y)
                                                 afterScreenUpdates:afterUpdates
                                                      withCapInsets:capInsets];
    }
    
    if (CGRectIntersectsRect(self.rowHeaderView.frame, [self.rowHeaderView convertRect:rect toView:self])) {
        return [self.rowHeaderView resizableSnapshotViewFromRect:CGRectOffset(rect, -self.rowHeaderView.frame.origin.x, -self.rowHeaderView.frame.origin.y)
                                              afterScreenUpdates:afterUpdates
                                                   withCapInsets:capInsets];
    }
    
    if (CGRectIntersectsRect(self.tableView.frame, [self.tableView convertRect:rect toView:self])) {
        return [self.tableView resizableSnapshotViewFromRect:CGRectOffset(rect, -self.tableView.frame.origin.x, -self.tableView.frame.origin.y)
                                          afterScreenUpdates:afterUpdates
                                               withCapInsets:capInsets];
    }
    return [super resizableSnapshotViewFromRect:rect
                             afterScreenUpdates:afterUpdates
                                  withCapInsets:capInsets];
}

@end
