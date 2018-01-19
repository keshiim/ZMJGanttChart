//
//  Borders.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, BorderStyle_Enum) {
    BorderStyle_None,
    BorderStyle_solid,
};

@class BorderStyle;

@interface Borders : NSObject
@property (nonatomic, assign) BorderStyle *top;
@property (nonatomic, assign) BorderStyle *bottom;
@property (nonatomic, assign) BorderStyle *left;
@property (nonatomic, assign) BorderStyle *right;

- (instancetype)initWithTop:(BorderStyle *)top bottom:(BorderStyle *)bottom left:(BorderStyle *)left right:(BorderStyle *)right;
+ (instancetype)all:(BorderStyle *)style;
@end

@interface BorderStyle : NSObject
@property (nonatomic, assign) CGFloat  width;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BorderStyle_Enum border_enum;

+ (instancetype)borderStyleNone;
@end

@interface Border: UIView
@end
