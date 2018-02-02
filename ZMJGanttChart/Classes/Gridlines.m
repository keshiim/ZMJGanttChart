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

+ (instancetype)style:(GridStyle_Enum)style_enum width:(CGFloat)widith color:(UIColor *)color {
    return [[self alloc] initWithStyle:style_enum width:widith color:color];
}

- (BOOL)isEqual:(GridStyle *)object {
    return self.styleEnum == object.styleEnum && self.width == object.width && [self.color isEqual:object.color];
}
@end

@implementation ZMJGridLayout

- (instancetype)initWithGridWidth:(CGFloat)gridWidth gridColor:(UIColor *)gridColor origin:(CGPoint)origin length:(CGFloat)length edge:(RectEdge)edge priority:(CGFloat)priority {
    self = [super init];
    if (self) {
        _gridWidth = gridWidth;
        _gridColor = gridColor;
        _origin    = origin;
        _length    = length;
        _edge      = edge;
        _priority  = priority;
    }
    return self;
}

+ (instancetype)gridLayoutWithGridWidth:(CGFloat)gridWidth gridColor:(UIColor *)gridColor origin:(CGPoint)origin length:(CGFloat)length edge:(RectEdge)edge priority:(CGFloat)priority {
    return [[ZMJGridLayout alloc] initWithGridWidth:gridWidth
                                          gridColor:gridColor
                                             origin:origin
                                             length:length
                                               edge:edge
                                           priority:priority];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    ZMJGridLayout *copy = [[ZMJGridLayout allocWithZone:zone] init];
    if (copy) {
        copy.gridWidth = self.gridWidth;
        copy.gridColor = [self.gridColor copyWithZone:zone];
        copy.origin    = self.origin;
        copy.length    = self.length;
        copy.edge      = self.edge;
        copy.priority  = self.priority;
    }
    return copy;
}

- (NSUInteger)hash {
    return 32768 * _gridWidth + _length;
}

- (BOOL)isEqual:(ZMJGridLayout *)object {
    return
    [object isKindOfClass:self.class]               &&
    self.gridWidth == object.gridWidth              &&
    self.gridColor.hash == object.gridColor.hash    &&
    CGPointEqualToPoint(self.origin, object.origin) &&
    self.length == object.length                    &&
    RectEdgeEqualToRectEdge(self.edge, object.edge) &&
    self.priority == object.priority;
}

- (NSString *)description {
    return [self debugDescription];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"gridWidth=%ld\ngridColor=%@\nlength=%ld\nedge=%@\npriority=%ld",
            (long)self.gridWidth,
            self.gridColor,
            (long)self.length,
            RectEdgeDescription(self.edge),
            (long)self.priority];
}

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
