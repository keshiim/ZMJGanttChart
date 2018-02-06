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
    self.label.font = [UIFont boldSystemFontOfSize:14.f];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.label];
}

@end

@implementation TimeTitleCell : ZMJCell
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
    self.label.font = [UIFont boldSystemFontOfSize:12.f];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.label];
}

@end

@implementation TimeCell : ZMJCell
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
    self.label.font = [UIFont monospacedDigitSystemFontOfSize:12.f weight:UIFontWeightMedium];
    self.label.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.label];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.label.frame = CGRectInset(self.bounds, 6, 0);
}

@end

@implementation ScheduleCell : ZMJCell
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
    self.backgroundView = [UIView new];
    
    self.label = [UILabel new];
    self.label.frame = self.bounds;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.label.font = [UIFont boldSystemFontOfSize:12.f];
    self.label.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:self.label];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.label.frame = CGRectInset(self.bounds, 4, 0);
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.backgroundView.backgroundColor = color;
}
@end
