//
//  ZMJCells.m
//  ZMJGanttChart_Example
//
//  Created by Jason on 2018/1/29.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import "ZMJCells.h"

@implementation ZMJHeaderCell : ZMJCell

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
    }
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0];
        
        self.label.frame = self.bounds;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.label.font = [UIFont boldSystemFontOfSize:10.f];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
@end

@implementation ZMJTextCell : ZMJCell
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
    }
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label.frame = self.bounds;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.label.font = [UIFont boldSystemFontOfSize:10.f];
        self.label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
@end

@implementation ZMJTaskCell : ZMJCell
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
    }
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label.frame = self.bounds;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.label.font = [UIFont boldSystemFontOfSize:10.f];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.numberOfLines = 0;
        
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectInset(self.bounds, 2, 2);
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
@end

@implementation ZMJChartBarCell : ZMJCell
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
    }
    return _label;
}

- (UIView *)colorBarView {
    if (!_colorBarView) {
        _colorBarView = [UIView new];
    }
    return _colorBarView;
}

- (void)setColor:(UIColor *)color {
    if (color) {
        _color = color;
        self.colorBarView.backgroundColor = color;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.colorBarView.frame = CGRectInset(self.bounds, 2, 2);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.colorBarView];
        
        self.label.frame = self.bounds;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.label.font = [UIFont boldSystemFontOfSize:10.f];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
@end

