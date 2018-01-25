//
//  SpreadsheetView+CirclularScrolling.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import "SpreadsheetView+CirclularScrolling.h"
#import "Define.h"

@implementation SpreadsheetView (CirclularScrolling)
- (void)scrollToHorizontalCenter {
    State s = self.rowHeaderView.state;
    s.contentOffset.x = self.centerOffset.x;
    self.rowHeaderView.state = s;
    
    s = self.tableView.state;
    s.contentOffset.x = self.centerOffset.x;
    self.tableView.state = s;
}

- (void)scrollToVerticalCenter {
    State s = self.rowHeaderView.state;
    s.contentOffset.y = self.centerOffset.y;
    self.columnHeaderView.state = s;
    
    s = self.tableView.state;
    s.contentOffset.y = self.centerOffset.y;
    self.tableView.state = s;
}

- (void)recenterHorizontallyIfNecessary {
    CGPoint currentOffset = self.tableView.state.contentOffset;
    CGFloat distance = currentOffset.x - self.centerOffset.x;
    CGFloat threshold= self.tableView.state.contentSize.width / 4;
    if (fabs(distance) > threshold) {
        if (distance > 0) {
            State s = self.rowHeaderView.state;
            s.contentOffset.x = distance;
            self.rowHeaderView.state = s;
            
            s = self.tableView.state;
            s.contentOffset.x = distance;
            self.tableView.state = s;
        } else {
            CGFloat offset = self.centerOffset.x + (self.centerOffset.x - threshold);
            State s = self.rowHeaderView.state;
            s.contentOffset.x = offset;
            self.rowHeaderView.state = s;
            
            s = self.tableView.state;
            s.contentOffset.x = offset;
            self.tableView.state = s;
        }
    }
}

- (void)recenterVerticallyIfNecessary {
    CGPoint currentOffset = self.tableView.state.contentOffset;
    CGFloat distance = currentOffset.y - self.centerOffset.y;
    CGFloat threshold = self.tableView.state.contentSize.height / 4;
    if (fabs(distance) > threshold) {
        if (distance > 0) {
            State s = self.columnHeaderView.state;
            s.contentOffset.y = distance;
            self.columnHeaderView.state = s;
            
            s = self.tableView.state;
            s.contentOffset.y = distance;
            self.tableView.state = s;
        } else {
            CGFloat offset = self.centerOffset.y + (self.centerOffset.y - threshold);
            State s = self.columnHeaderView.state;
            s.contentOffset.y = offset;
            self.columnHeaderView.state = s;
            
            s = self.tableView.state;
            s.contentOffset.y = offset;
            self.tableView.state = s;
        }
    }
}

- (CircularScrollScalingFactor)determineCircularScrollScalingFactor {
    return CircularScrollScalingFactorMake([self determineHorizontalCircularScrollScalingFactor], [self determineVerticalCircularScrollScalingFactor]);
}

- (NSInteger)determineHorizontalCircularScrollScalingFactor {
    if ((self.circularScrollingOptions.direction & Direction_horizontally) == 0) {
        return 1;
    }
    CGFloat tableContentWidth = self.layoutProperties.columnWidth - self.layoutProperties.frozenColumnWidth;
    CGFloat tableWidth = self.frame.size.width - self.layoutProperties.frozenColumnWidth;
    NSInteger scalingFactor = 3;
    while (tableContentWidth > 0 && (NSInteger)(tableContentWidth) * scalingFactor < (NSInteger)(tableWidth) * 3) {
        scalingFactor += 3;
    }
    return scalingFactor;
}

- (NSInteger)determineVerticalCircularScrollScalingFactor {
    if ((self.circularScrollingOptions.direction & Direction_vertically) == 0) {
        return 1;
    }
    CGFloat tableContentHeight= self.layoutProperties.rowHeight - self.layoutProperties.frozenRowHeight;
    CGFloat tableHight = self.frame.size.height - self.layoutProperties.frozenRowHeight;
    NSInteger scalingFactor = 3;
    while (tableContentHeight> 0 && (NSInteger)(tableContentHeight) * scalingFactor < (NSInteger)(tableHight) * 3) {
        scalingFactor += 3;
    }
    return scalingFactor;
}

- (CGPoint)calculateCenterOffset {
    CGPoint centerOffset = CGPointZero;
    if (self.circularScrollingOptions.direction & Direction_horizontally) {
        for (int column = 0; column < self.layoutProperties.numberOfColumns; column++) {
            centerOffset.x += self.layoutProperties.columnWidthCache[column % self.numberOfColumns].floatValue + self.intercellSpacing.width;
        }
        if (self.circularScrollingOptions.tableStyle & TableStyle_columnHeaderNotRepeated) {
            for (int column = 0; column < self.layoutProperties.frozenColumns; column++) {
                centerOffset.x -= self.layoutProperties.columnWidthCache[column].floatValue;
            }
            centerOffset.x -= self.intercellSpacing.width * (CGFloat)(self.layoutProperties.frozenColumns);
        }
        centerOffset.x *= (CGFloat)(self.circularScrollScalingFactor.horizontal / 3);
    }
    if (self.circularScrollingOptions.direction & Direction_vertically) {
        for (int row = 0; row < self.layoutProperties.numberOfRows; row++) {
            centerOffset.y += self.layoutProperties.rowHeightCache[row % self.numberOfRows].floatValue + self.intercellSpacing.height;
        }
        if (self.circularScrollingOptions.tableStyle & TableStyle_rowHeaderNotRepeated) {
            for (int row = 0; row < self.layoutProperties.frozenRows; row++) {
                centerOffset.y -= self.layoutProperties.rowHeightCache[row].floatValue;
            }
            centerOffset.y -= self.intercellSpacing.height * (CGFloat)(self.layoutProperties.frozenRows);
        }
        centerOffset.y *= (CGFloat)(self.circularScrollScalingFactor.vertical / 3);
    }
    return centerOffset;
}
@end


















