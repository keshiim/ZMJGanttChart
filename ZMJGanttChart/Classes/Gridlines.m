//
//  Gridlines.m
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import "Gridlines.h"

@implementation Gridlines
- (instancetype)initWithTop:(GridStyle *)top bottom:(GridStyle *)bottom left:(GridStyle *)left right:(GridStyle *)right {
    self = [super init];
    if (self) {
        _top = top;
        _bottom = bottom;
        _left = left;
        _right = right;
    }
    return self;
}

+ (instancetype)all:(GridStyle *)style {
    return [[self alloc] initWithTop:style bottom:style left:style right:style];
}
@end

@implementation GridStyle
- (instancetype)initWithStyle:(GridStyle_Enum)style_enum width:(CGFloat)widith color:(UIColor *)color {
    self = [super init];
    if (self) {
        _styleEnum = style_enum;
        if (style_enum != GridStyle_none) {
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
    return [[self alloc] initWithStyle:GridStyle_none width:0 color:nil];
}

- (BOOL)isEqual:(GridStyle *)object {
    return self.styleEnum == object.styleEnum && self.width == object.width && [self.color isEqual:object.color];
}
@end

@interface Gridline ()
@property (nonatomic, strong) UIColor *color;
@end

@implementation Gridline

- (instancetype)init
{
    self = [super init];
    if (self) {
        _color = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithLayer:(id)layer {
    return [super initWithLayer:layer];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (nullable id<CAAction>)actionForKey:(NSString *)event {
    return nil;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.backgroundColor = color.CGColor;
}

@end
