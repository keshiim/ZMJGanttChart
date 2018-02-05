//
//  ZMJCells.m
//  ZMJClassData
//
//  Created by Jason on 2018/2/5.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import "ZMJCells.h"

@implementation HeaderCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.label = [UILabel new];
    self.label.frame = self.bounds;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.label.font = [UIFont boldSystemFontOfSize:14];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.numberOfLines = 2;
    [self.contentView addSubview:self.label];
    
    self.sortArrow = [UILabel new];
    self.sortArrow.text = @"";
    self.sortArrow.font = [UIFont boldSystemFontOfSize:14];
    self.sortArrow.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.sortArrow];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.label.frame = CGRectInset(self.bounds, 4, 2);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.sortArrow sizeToFit];
    CGRect frame = self.sortArrow.frame;
    frame.origin.x = self.frame.size.width - self.sortArrow.frame.size.width - 8;
    frame.origin.y = (self.frame.size.height - self.sortArrow.frame.size.height) / 2;
    self.sortArrow.frame = frame;
}
@end

@implementation TextCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.2f];
    self.selectedBackgroundView = backgroundView;
    
    self.label = [UILabel new];
    self.label.frame = self.bounds;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.label.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.label];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.label.frame = CGRectInset(self.bounds, 4, 2);
}

@end
