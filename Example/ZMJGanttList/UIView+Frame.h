//
//  UIView+Frame.h
//  Trader
//
//  Created by Mingfei Huang on 9/17/15.
//
//

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#import <UIKit/UIKit.h>

@interface UIView (WBGFrame)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

@property (nonatomic, readonly) CGFloat maxX;
@property (nonatomic, readonly) CGFloat maxY;

@property (nonatomic, readonly) CGPoint boundCenter;

/// [平移]这个view, 让view.maxX = maxX
- (void)setMaxXByShift:(CGFloat)maxX;

/// [拉伸]这个view, 让view.maxX = maxX
- (void)setMaxXByStretch:(CGFloat)maxX;

/// [平移]这个view, 让view.maxY = maxY
- (void)setMaxYByShift:(CGFloat)maxY;

/// [拉伸]这个view, 让view.maxY = maxY
- (void)setMaxYByStretch:(CGFloat)maxY;

@property (nonatomic, /* setonly */ setter=setMaxXByShift:, getter=maxX) CGFloat maxXByShift;
@property (nonatomic, /* setonly */ setter=setMaxYByShift:, getter=maxY) CGFloat maxYByShift;
@property (nonatomic, /* setonly */ setter=setMaxXByStretch:, getter=maxX) CGFloat maxXByStretch;
@property (nonatomic, /* setonly */ setter=setMaxYByStretch:, getter=maxY) CGFloat maxYByStretch;

@end








// ========================================================================









@interface CALayer (WBGFrame)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

@property (nonatomic, readonly) CGFloat maxX;
@property (nonatomic, readonly) CGFloat maxY;

@property (nonatomic, readonly) CGPoint boundCenter;

- (void)setMaxXByShift:(CGFloat)maxX;
- (void)setMaxXByStretch:(CGFloat)maxX;

- (void)setMaxYByShift:(CGFloat)maxY;
- (void)setMaxYByStretch:(CGFloat)maxY;

@end





// ========================================================================









@interface UICollectionViewLayoutAttributes (WBGFrame)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;


@property (nonatomic, readonly) CGFloat maxX;
@property (nonatomic, readonly) CGFloat maxY;

@property (nonatomic, readonly) CGPoint boundCenter;

- (void)setMaxXByShift:(CGFloat)maxX;
- (void)setMaxXByStretch:(CGFloat)maxX;

- (void)setMaxYByShift:(CGFloat)maxY;
- (void)setMaxYByStretch:(CGFloat)maxY;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@end








