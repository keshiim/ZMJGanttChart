//
//  Gridlines.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Define.h"

@class GridStyle;
@interface Gridlines : NSObject
@property (nonatomic, strong) GridStyle *top;
@property (nonatomic, strong) GridStyle *bottom;
@property (nonatomic, strong) GridStyle *left;
@property (nonatomic, strong) GridStyle *right;

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
