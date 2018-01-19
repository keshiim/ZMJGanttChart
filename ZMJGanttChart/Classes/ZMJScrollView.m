//
//  ZMJScrollView.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/19.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "ZMJScrollView.h"
#import "ReuseQueue.h"
#import "Gridlines.h"
#import "Borders.h"
#import "ZMJCell.h"

@interface ZMJScrollView() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnRecords; // number -> CGFloat
@property (nonatomic, strong) NSMutableArray<NSNumber *> *rowRecords;    // number -> CGFloat

@property (nonatomic, strong) ReusableCollection<ZMJCell *>  *visibleCells;
@property (nonatomic, strong) ReusableCollection<Gridline *> *visibleVerticalGridlines;
@property (nonatomic, strong) ReusableCollection<Gridline *> *visibleHorizontalGridlines;
@property (nonatomic, strong) ReusableCollection<Border *>   *visibleBorders;

@property (nonatomic, copy) TouchHandler touchesBegan;
@property (nonatomic, copy) TouchHandler touchesEnded;
@property (nonatomic, copy) TouchHandler touchesCancelled;

@end

@implementation ZMJScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _columnRecords = [NSMutableArray new];
        _rowRecords    = [NSMutableArray new];
        
        _visibleCells               = [ReusableCollection new];
        _visibleVerticalGridlines   = [ReusableCollection new];
        _visibleHorizontalGridlines = [ReusableCollection new];
        _visibleBorders             = [ReusableCollection new];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
