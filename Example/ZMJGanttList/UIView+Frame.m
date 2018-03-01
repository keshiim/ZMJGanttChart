//
//  UIView+Frame.m
//  Trader
//
//  Created by Mingfei Huang on 9/17/15.
//
//

#import "UIView+Frame.h"
@import YYCategories.UIView_YYAdd;
@import YYCategories.CALayer_YYAdd;

@implementation UIView (WBGFrame)

# pragma mark Normal Frame
- (void)setX: (CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY: (CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x { return self.frame.origin.x; }

- (CGFloat)y { return self.frame.origin.y; }

# pragma mark max x/y

- (CGFloat)maxX {
    return self.x + self.width;
}

- (CGFloat)maxY {
    return self.y + self.height;
}

- (void)setMaxXByShift:(CGFloat)maxX {
    self.x = maxX - self.width;
}

- (void)setMaxYByShift:(CGFloat)maxY {
    self.y = maxY - self.height;
}

- (void)setMaxXByStretch:(CGFloat)maxX {
    self.width = maxX - self.x;
}

- (void)setMaxYByStretch:(CGFloat)maxY {
    self.height = maxY - self.y;
}

- (CGPoint)boundCenter {
    return CGPointMake(self.bounds.size.width / 2,
                       self.bounds.size.height / 2);
}

@end











// ========================================================================












@implementation CALayer (WBGFrame)

# pragma mark Normal Frame
- (void)setX: (CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY: (CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x { return self.frame.origin.x; }

- (CGFloat)y { return self.frame.origin.y; }

# pragma mark max x/y

- (CGFloat)maxX {
    return self.x + self.width;
}

- (CGFloat)maxY {
    return self.y + self.height;
}

- (void)setMaxXByShift:(CGFloat)maxX {
    self.x = maxX - self.width;
}

- (void)setMaxYByShift:(CGFloat)maxY {
    self.y = maxY - self.height;
}

- (void)setMaxXByStretch:(CGFloat)maxX {
    self.width = maxX - self.x;
}

- (void)setMaxYByStretch:(CGFloat)maxY {
    self.height = maxY - self.y;
}

- (CGPoint)boundCenter {
    return CGPointMake(self.bounds.size.width / 2,
                       self.bounds.size.height / 2);
}

@end








// ==================================================





@implementation UICollectionViewLayoutAttributes (WBGFrame)

# pragma mark Normal Frame
- (void)setX: (CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY: (CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setWidth: (CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight: (CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)x { return self.frame.origin.x; }

- (CGFloat)y { return self.frame.origin.y; }

- (CGFloat)width { return self.frame.size.width; }

- (CGFloat)height { return self.frame.size.height; }

# pragma mark max x/y

- (CGFloat)maxX {
    return self.x + self.width;
}

- (CGFloat)maxY {
    return self.y + self.height;
}

- (void)setMaxXByShift:(CGFloat)maxX {
    self.x = maxX - self.width;
}

- (void)setMaxYByShift:(CGFloat)maxY {
    self.y = maxY - self.height;
}

- (void)setMaxXByStretch:(CGFloat)maxX {
    self.width = maxX - self.x;
}

- (void)setMaxYByStretch:(CGFloat)maxY {
    self.height = maxY - self.y;
}


# pragma mark Center
- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGPoint)boundCenter {
    return CGPointMake(self.bounds.size.width / 2,
                       self.bounds.size.height / 2);
}

@end

