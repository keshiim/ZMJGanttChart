//
//  OverlayView.m
//  DoubleConversion
//
//  Created by ms on 2019/12/2.
//

#import "OverlayView.h"

@implementation OverlayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
     self.isEndAnimation = false;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.isEndAnimation = true;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGSize headerSize = self.tableHeaderView.frame.size;
    BOOL isTouchOnHeader = point.y < headerSize.height;
    if (self.touchOnHeader != nil && self.isEndAnimation == true) {
        self.touchOnHeader(isTouchOnHeader);
    }
    return [super hitTest:point withEvent:event];
}




@end
