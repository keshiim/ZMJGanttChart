//
//  ZMJCells.m
//  ZMJSchedule
//
//  Created by Jason on 2018/2/6.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import "ZMJCells.h"

@implementation DateCell : ZMJCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupviews];
    }
    return self;
}

- (void)setupviews {
    self.label = [UILabel new];
    self.label.frame = self.bounds;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.label.font = [UIFont boldSystemFontOfSize:10.f];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.label];
}

@end

@implementation DayTitleCell : ZMJCell

@end

@implementation TimeTitleCell : ZMJCell

@end

@implementation TimeCell : ZMJCell

@end

@implementation ScheduleCell : ZMJCell

@end
