//
//  Borders.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <Foundation/Foundation.h>
#import "Define.h"

@class BorderStyle;
@interface Borders : NSObject
@property (nonatomic, strong) BorderStyle *top;
@property (nonatomic, strong) BorderStyle *bottom;
@property (nonatomic, strong) BorderStyle *left;
@property (nonatomic, strong) BorderStyle *right;

- (instancetype)initWithTop:(BorderStyle *)top bottom:(BorderStyle *)bottom left:(BorderStyle *)left right:(BorderStyle *)right;
+ (instancetype)all:(BorderStyle *)style;
@end

@interface BorderStyle : NSObject
@property (nonatomic, assign) CGFloat  width;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BorderStyle_Enum border_enum;

- (instancetype)initWithStyle:(BorderStyle_Enum)style_enum width:(CGFloat)widith color:(UIColor *)color;
+ (instancetype)borderStyleNone;
@end

@interface Borders ()
@property (nonatomic, assign) BOOL hasBorders;
@end

@interface Border: UIView
@property (nonatomic, strong) Borders *borders;
@end
