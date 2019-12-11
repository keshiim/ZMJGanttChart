//
//  OverlayView.m
//  DoubleConversion
//
//  Created by ms on 2019/12/2.
//

#import "OverlayView.h"

@implementation OverlayView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGSize headerSize = self.tableHeaderView.frame.size;
    BOOL isTouchOnHeader = point.y < headerSize.height;
    if (self.touchOnHeader != nil && self.isAnimation == false && isTouchOnHeader == YES) {
        self.touchOnHeader(isTouchOnHeader);
    }
    return [super hitTest:point withEvent:event];
}




@end
