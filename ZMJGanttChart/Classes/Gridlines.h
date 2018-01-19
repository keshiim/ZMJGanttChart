//
//  Gridlines.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GridStyle_Enum) {
    GridStyle_default = 0,
    GridStyle_none,
    GridStyle_solid,
};

@class GridStyle;

@interface Gridlines : NSObject
@property (nonatomic, assign) GridStyle *top;
@property (nonatomic, assign) GridStyle *bottom;
@property (nonatomic, assign) GridStyle *left;
@property (nonatomic, assign) GridStyle *right;

- (instancetype)initWithTop:(GridStyle *)top bottom:(GridStyle *)bottom left:(GridStyle *)left right:(GridStyle *)right;
+ (instancetype)all:(GridStyle *)style;
@end

@interface GridStyle : NSObject
/**
 style : default, none, solid
 */
@property (nonatomic, assign) GridStyle_Enum styleEnum;

/**
 when style = GridStyle_solid, width & color needed
 */
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithStyle:(GridStyle_Enum)style_enum width:(CGFloat)widith color:(UIColor *)color;
+ (instancetype)borderStyleNone;
@end


@interface Gridline : CALayer

@end
