//
//  SpreadsheetView+CirclularScrolling.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import "SpreadsheetView.h"

@interface SpreadsheetView (CirclularScrolling)
- (void)scrollToHorizontalCenter;
- (void)scrollToVerticalCenter;
- (void)recenterHorizontallyIfNecessary;
- (void)recenterVerticallyIfNecessary;
- (CircularScrollScalingFactor)determineCircularScrollScalingFactor;
- (NSInteger)determineHorizontalCircularScrollScalingFactor;
- (NSInteger)determineVerticalCircularScrollScalingFactor;
- (CGPoint)calculateCenterOffset;
@end
