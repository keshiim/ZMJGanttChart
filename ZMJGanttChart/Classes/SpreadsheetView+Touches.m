//
//  SpreadsheetView+Touches.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import "SpreadsheetView+Touches.h"
#import <Foundation/Foundation.h>

@implementation SpreadsheetView (Touches)
- (void)touchesBegan:(NSSet<UITouch *> *)touches event:(UIEvent *)event {
    if (self.currentTouch) {
        return;
    }
    self.currentTouch = touches.anyObject;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self unhighlightAllItems];
    [self highlightItems:touches];
    
    NSIndexPath *indexPath = [self indexPathForItemAt:[self.currentTouch locationInView:self]];
    ZMJCell *cell = [self cellForItemAt:indexPath];
    if (!self.allowsMultipleSelection &&
        indexPath && cell && cell.isUserInteractionEnabled) {
        __weak typeof(self)weak_self = self;
        [self.selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
            [[weak_self cellsForItemAt:indexPath] enumerateObjectsUsingBlock:^(ZMJCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
                cell.selected = NO;
            }];
        }];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches event:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (!touch || touch != self.currentTouch) {
        return;
    }
    NSOrderedSet<NSIndexPath *> *highlightedItems = self.highlightedIndexPaths.copy;
    [self unhighlightAllItems];
    
    NSIndexPath *indexPath = [self indexPathForItemAt:[touch locationInView:self]];
    if (self.allowsMultipleSelection &&
        touch && indexPath &&
        [self.selectedIndexPaths containsObject:indexPath]) {
        if ([self.delegate respondsToSelector:@selector(spreadsheetView:shouldDeselectItemAt:)] ?
            [self.delegate spreadsheetView:self shouldDeselectItemAt:indexPath] : YES) {
            [self deselectItem:indexPath];
        }
    } else {
        [self selectItems:touches highlightedItems:highlightedItems.set];
    }
    [self performSelector:@selector(clearCurrentTouch) withObject:nil afterDelay:0];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches event:(UIEvent *)event {
    [self unhighlightAllItems];
    [self performSelector:@selector(restorePreviousSelection) withObject:touches afterDelay:0];
    [self performSelector:@selector(clearCurrentTouch) withObject:nil afterDelay:0];
}

- (void)restorePreviousSelection {
    __weak typeof(self) weak_self = self;
    [self.selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        [[weak_self cellsForItemAt:indexPath] enumerateObjectsUsingBlock:^(ZMJCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            cell.selected = YES;
        }];
    }];
}

- (void)clearCurrentTouch {
    self.currentTouch = nil;
}

#pragma mark - Private method
- (void)highlightItems:(NSSet<UITouch *> *)touches {
    if (!self.allowsSelection) {
        return ;
    }
    UITouch *touch = touches.anyObject;
    if (touch) {
        NSIndexPath *indexPath = [self indexPathForItemAt:[touch locationInView:self]];
        if (indexPath) {
            ZMJCell *cell = [self cellForItemAt:indexPath];
            if (!cell || cell.isUserInteractionEnabled == NO) {
                return;
            }
            if ([self.delegate respondsToSelector:@selector(spreadsheetView:shouldHighlightItemAt:)] ?
                [self.delegate spreadsheetView:self shouldHighlightItemAt:indexPath] : YES) {
                [self.highlightedIndexPaths addObject:indexPath];
                [[self cellsForItemAt:indexPath] enumerateObjectsUsingBlock:^(ZMJCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
                    cell.highlighted = YES;
                }];
                ![self.delegate respondsToSelector:@selector(spreadsheetView:didHighlightItemAt:)]?: [self.delegate spreadsheetView:self didHighlightItemAt:indexPath];
            }
        }
    }
}

- (void)unhighlightAllItems {
    __weak typeof(self)weak_self = self;
    [self.highlightedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        [[weak_self cellsForItemAt:indexPath] enumerateObjectsUsingBlock:^(ZMJCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            cell.highlighted = NO;
        }];
        ![self.delegate respondsToSelector:@selector(spreadsheetView:didUnhighlightItemAt:)]?: [self.delegate spreadsheetView:self didUnhighlightItemAt:indexPath];
    }];
    [self.highlightedIndexPaths removeAllObjects];
}

- (void)selectItems:(NSSet<UITouch *> *)touches highlightedItems:(NSSet<NSIndexPath *> *)highlightedItems {
    if (!self.allowsSelection) {
        return;
    }
    UITouch *touch = touches.anyObject;
    if (touch) {
        NSIndexPath *indexPath = [self indexPathForItemAt:[touch locationInView:self]];
        if (indexPath && [highlightedItems containsObject:indexPath]) {
            [self selectItem:indexPath];
        }
    }
}

- (void)selectItem:(NSIndexPath *)indexPath {
    NSArray<ZMJCell *> *cells = [self cellsForItemAt:indexPath];
    if (cells.count != 0 && [self.delegate respondsToSelector:@selector(spreadsheetView:shouldSelectItemAt:)] ?
        [self.delegate spreadsheetView:self shouldSelectItemAt:indexPath] : YES) {
        if (!self.allowsMultipleSelection) {
            [self.selectedIndexPaths removeObject:indexPath];
            [self deselectAllItems];
        }
        [cells enumerateObjectsUsingBlock:^(ZMJCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            cell.selected = YES;
        }];
        ![self.delegate respondsToSelector:@selector(spreadsheetView:didSelectItemAt:)]?: [self.delegate spreadsheetView:self didSelectItemAt:indexPath];
        [self.selectedIndexPaths addObject:indexPath];
    }
}

- (void)deselectItem:(NSIndexPath *)indexPath {
    NSArray<ZMJCell *> *cells = [self cellsForItemAt:indexPath];
    [cells enumerateObjectsUsingBlock:^(ZMJCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.selected = NO;
    }];
    ![self.delegate respondsToSelector:@selector(spreadsheetView:didDeselectItemAt:)]?: [self.delegate spreadsheetView:self didDeselectItemAt:indexPath];
    [self.selectedIndexPaths removeObject:indexPath];
}

- (void)deselectAllItems {
    __weak typeof(self)weak_self = self;
    [self.selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        [weak_self deselectItem:indexPath];
    }];
}
@end
