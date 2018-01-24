//
//  SpreadsheetView.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import "SpreadsheetView.h"

@implementation SpreadsheetView

#pragma mark - Setter
- (void)setDataSource:(id<SpreadsheetViewDataSource>)dataSource {
    _dataSource = dataSource;
    
}

- (void)setAllowsSelection:(BOOL)allowsSelection {
    _allowsSelection = allowsSelection;
    if (!_allowsSelection) {
        _allowsMultipleSelection = NO;
    }
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    _allowsMultipleSelection = allowsMultipleSelection;
    if (_allowsMultipleSelection) {
        _allowsSelection = YES;
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
- (void)safeAreaInsetsDidChange {
    if (self.backgroundView) {
        [self.backgroundView removeFromSuperview];
        [super insertSubview:self.backgroundView atIndex:0];
    }
}
#endif
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
