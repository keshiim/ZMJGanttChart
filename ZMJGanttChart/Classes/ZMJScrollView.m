//
//  ZMJScrollView.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/19.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import "ZMJScrollView.h"

@interface ZMJScrollView() <UIGestureRecognizerDelegate>
@property (nonatomic, copy) NSMutableArray<NSNumber *> *columnRecords; // number -> CGFloat
@property (nonatomic, copy) NSMutableArray<NSNumber *> *rowRecords;    // number -> CGFloat
@end

@implementation ZMJScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
