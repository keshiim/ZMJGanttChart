//
//  ZMJCells.m
//  ZMJTimeable
//
//  Created by Jason on 2018/2/5.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import "ZMJCells.h"

@implementation HourCell
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
    self.label = [UILabel new];
    self.label.frame = self.bounds;
    
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.label.backgroundColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.3 alpha:1];
    self.label.font = [UIFont systemFontOfSize:12];
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 2;
    [self addSubview:self.label];
}

@end

@implementation ChannelCell

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
    self.label = [UILabel new];
    self.label.frame = self.bounds;
    
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.label.backgroundColor = [UIColor darkGrayColor];
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.textColor = [[UIColor lightTextColor] colorWithAlphaComponent:.7];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 2;
    [self addSubview:self.label];
}

- (void)setChannel:(NSString *)channel {
    _channel = channel;
    self.label.text = channel;
}
@end

@implementation SlotCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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

- (void)setMinutes:(NSInteger)minutes {
    _minutes = minutes;
    self.minutesLabel.text = [NSString stringWithFormat:@"%02ld", (long)minutes];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTableHighlight:(NSString *)tableHighlight {
    _tableHighlight = tableHighlight;
    self.tableHighlightLabel.text = tableHighlight;
}

@end

@implementation MyBlankCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return self;
}
@end
