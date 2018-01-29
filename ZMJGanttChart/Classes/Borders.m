//
//  Borders.m
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import "Borders.h"

@interface Borders ();
@end

@implementation Borders

+ (instancetype)all:(BorderStyle *)style {
    return [[self alloc] initWithTop:style bottom:style left:style right:style];
}

- (instancetype)initWithTop:(BorderStyle *)top bottom:(BorderStyle *)bottom left:(BorderStyle *)left right:(BorderStyle *)right {
    self = [super init];
    if (self) {
        _top = top;
        _bottom = bottom;
        _left = left;
        _right = right;
    }
    return self;
}

@end

@implementation BorderStyle

- (instancetype)initWithStyle:(BorderStyle_Enum)style_enum width:(CGFloat)widith color:(UIColor *)color {
    self = [super init];
    if (self) {
        _border_enum = style_enum;
        if (style_enum == BorderStyle_solid) {
            _width       = widith;
            _color       = color;
        } else {
            widith = 0.f;
            _color = nil;
        }
    }
    return self;
}

+ (instancetype)borderStyleNone {
    return [[self alloc] initWithStyle:BorderStyle_None width:0 color:nil];
}

- (BOOL)isEqual:(BorderStyle *)object {
    return self.border_enum == object.border_enum && self.width == object.width && [self.color isEqual:object.color];
}
@end

@interface Border ()
@end

@implementation Border

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.layer.zPosition = 1000;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (void)internalInit {
    _borders = [Borders all:[BorderStyle borderStyleNone]];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return;
    }
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    if (self.borders.left.border_enum == BorderStyle_solid) {
        CGFloat width  = self.borders.left.width;
        UIColor *color = self.borders.left.color;
        CGContextMoveToPoint(context, width * 0.5f, 0);
        CGContextAddLineToPoint(context, width * 0.5f, self.bounds.size.height);
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextStrokePath(context);
    }
    if (self.borders.right.border_enum == BorderStyle_solid) {
        CGFloat width  = self.borders.right.width;
        UIColor *color = self.borders.right.color;
        CGContextMoveToPoint(context, self.bounds.size.width - width * 0.5f, 0);
        CGContextAddLineToPoint(context, self.bounds.size.width - width * 0.5f, self.bounds.size.height);
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextStrokePath(context);
    }
    if (self.borders.top.border_enum == BorderStyle_solid) {
        CGFloat width  = self.borders.top.width;
        UIColor *color = self.borders.top.color;
        CGContextMoveToPoint(context, 0, width * 0.5f);
        CGContextAddLineToPoint(context, self.bounds.size.width, width * 0.5f);
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextStrokePath(context);
    }
    if (self.borders.bottom.border_enum == BorderStyle_solid) {
        CGFloat width  = self.borders.bottom.width;
        UIColor *color = self.borders.bottom.color;
        CGContextMoveToPoint(context, 0, self.bounds.size.height - width * 0.5f);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - width * 0.5f);
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextStrokePath(context);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __unused CGFloat width = 0.f;
    CGRect frame = self.frame;
    if (self.borders.left.border_enum == BorderStyle_solid) {
        width  = self.borders.left.width;
        frame.origin.x -= width * 0.5f;
        frame.size.width += width * 0.5f;
    }
    if (self.borders.right.border_enum == BorderStyle_solid) {
        width  = self.borders.right.width;
        frame.size.width += width * 0.5f;
    }
    if (self.borders.top.border_enum == BorderStyle_solid) {
        width  = self.borders.top.width;
        frame.origin.y -= width * 0.5f;
        frame.size.height += width * 0.5f;
    }
    if (self.borders.bottom.border_enum == BorderStyle_solid) {
        width  = self.borders.bottom.width;
        frame.size.height += width * 0.5f;
    }
    self.frame = frame;
}
@end
