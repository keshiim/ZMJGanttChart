//
//  ZMJCells.m
//  ZMJGanttList
//
//  Created by Jason on 2018/2/26.
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

@interface ZMJChartBarCell ()
@property (nonatomic, strong) UIImageView *dashImageView;
@property (nonatomic, assign) CGSize intercellSize;
@end
@implementation ZMJChartBarCell : ZMJCell
- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
    }
    return _label;
}

- (UIImageView *)dashImageView {
    if (!_dashImageView) {
        _dashImageView = [[UIImageView alloc] init];
    }
    return _dashImageView;
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
- (void)preppareForReuse {
    self.dashImageView.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.direction) {
        case ZMJDashlineDirectionNone:
        {
            self.colorBarView.frame = CGRectInset(self.bounds, self.intercellSize.width, self.intercellSize.height);
            self.dashImageView.frame= CGRectZero;
        }
            break;
        case ZMJDashlineDirectionLeft:
        {
            CGRect frame = CGRectInset(self.bounds, self.intercellSize.width, self.intercellSize.height);
            self.dashImageView.frame = frame;
            self.dashImageView.hidden = NO;
            self.colorBarView.frame = CGRectMake(floorf(frame.size.width * 1 / 4) + self.intercellSize.width,
                                                 frame.origin.y,
                                                 floorf(frame.size.width * 3 / 4) + self.intercellSize.width,
                                                 frame.size.height);
            [self drawLineByImageView:self.dashImageView withFrame:frame];
        }
            break;
        case ZMJDashlineDirectionRight:
        {
            CGRect frame = CGRectInset(self.bounds, self.intercellSize.width, self.intercellSize.height);
            self.dashImageView.frame = frame;
            self.dashImageView.hidden = NO;
            self.colorBarView.frame = CGRectMake(frame.origin.x, frame.origin.y, floorf(frame.size.width * 3 / 4), frame.size.height);
            [self drawLineByImageView:self.dashImageView withFrame:frame];
        }
            break;
        default:
            break;
    }
    self.label.frame = self.colorBarView.frame;
}

- (void)setDirection:(ZMJDashlineDirection)direction {
    _direction = direction;
    [self setNeedsLayout];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.intercellSize = CGSizeMake(2, 4);
        [self.contentView addSubview:self.dashImageView];
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

// 返回虚线image的方法
- (void)drawLineByImageView:(UIImageView *)imageView withFrame:(CGRect)frame {
    [imageView.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull subLayer, NSUInteger idx, BOOL * _Nonnull stop) {
        [subLayer removeFromSuperlayer];
    }];
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = self.color.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:CGRectInset(imageView.bounds, 1, 1)].CGPath;
    border.frame = imageView.bounds;
    border.lineWidth = 2.f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@2, @5];
    [imageView.layer addSublayer:border];
    
    
    /*
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(line, 4);
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
    // 2是每个虚线的长度 5空白的长度
    CGFloat lengths[] = {2, 8};
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithWhite:0.408 alpha:1.000].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2); //画虚线
    CGContextMoveToPoint(line, 0.0, 0.0); //开始画线
    CGContextAddRect(line, CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height));
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
     */
}

@end


