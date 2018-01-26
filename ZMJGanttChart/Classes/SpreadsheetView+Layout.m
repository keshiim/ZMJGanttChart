//
//  SpreadsheetView+Layout.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import "SpreadsheetView+Layout.h"
#import "SpreadsheetView+CirclularScrolling.h"
#import "ZMJLayoutEngine.h"

@implementation SpreadsheetView (Layout)
/// Override
- (void)layoutSubViews {
    [super layoutSubviews];
    
    self.tableView.delegate         = nil;
    self.columnHeaderView.delegate  = nil;
    self.rowHeaderView.delegate     = nil;
    self.cornerView.delegate        = nil;
    
    State state = self.cornerView.state;
    state.frame = self.cornerView.frame;
    state.contentSize = self.cornerView.contentSize;
    state.contentOffset = self.cornerView.contentOffset;
    self.cornerView.state = state;
    
    state = self.columnHeaderView.state;
    state.frame = self.columnHeaderView.frame;
    state.contentSize = self.columnHeaderView.contentSize;
    state.contentOffset = self.columnHeaderView.contentOffset;
    self.columnHeaderView.state = state;
    
    state = self.rowHeaderView.state;
    state.frame = self.rowHeaderView.frame;
    state.contentSize = self.rowHeaderView.contentSize;
    state.contentOffset = self.rowHeaderView.contentOffset;
    self.rowHeaderView.state = state;
    
    state = self.tableView.state;
    state.frame = self.tableView.frame;
    state.contentSize = self.tableView.contentSize;
    state.contentOffset = self.tableView.contentOffset;
    self.tableView.state = state;
    
    void(^defer)(void) = ^(void){
        self.cornerView.contentSize = self.cornerView.state.contentSize;
        self.columnHeaderView.contentSize = self.columnHeaderView.state.contentSize;
        self.rowHeaderView.contentSize = self.rowHeaderView.state.contentSize;
        self.tableView.contentSize = self.tableView.state.contentSize;
        
        self.cornerView.contentOffset = self.cornerView.state.contentOffset;
        self.columnHeaderView.contentOffset = self.columnHeaderView.state.contentOffset;
        self.rowHeaderView.contentOffset = self.rowHeaderView.state.contentOffset;
        self.tableView.contentOffset = self.tableView.state.contentOffset;
        
        self.tableView.delegate = self;
        self.columnHeaderView.delegate = self;
        self.rowHeaderView.delegate = self;
        self.cornerView.delegate = self;
    };
    
    [self reloadDataIfNeeded];
    
    if (self.numberOfColumns <= 0 && self.numberOfRows <= 0) {
        defer();
        return;
    }
    if (self.circularScrollingOptions.direction & Direction_horizontally) {
        [self recenterHorizontallyIfNecessary];
    }
    if (self.circularScrollingOptions.direction & Direction_vertically) {
        [self recenterVerticallyIfNecessary];
    }
    
    [self layoutCornerView];
    [self layoutRowHeaderView];
    [self layoutColumnHeaderView];
    [self layoutTableView];
    // end function
    defer();
}

- (void)layout:(ZMJScrollView *)scrollView {
    ZMJLayoutEngine *layoutEngine = [ZMJLayoutEngine spreadsheetView:self scrollView:scrollView];
    [layoutEngine layout];
}

- (void)layoutCornerView {
    
}

- (void)layoutColumnHeaderView {
    
}

- (void)layoutRowHeaderView {
    
}

- (void)layoutTableView {
    
}

@end
