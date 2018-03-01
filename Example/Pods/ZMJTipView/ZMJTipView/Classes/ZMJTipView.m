//
//  ZMJTipView.m
//  ZMJTipView
//
//  Created by Jason on 2018/2/8.
//

#import "ZMJTipView.h"


__unused static ZMJArrowPosition ZMJArrowPositionAllValues[4] = {
    ZMJArrowPosition_top,
    ZMJArrowPosition_bottom,
    ZMJArrowPosition_right,
    ZMJArrowPosition_left,
};

@implementation ZMJAnimating
- (instancetype)init
{
    self = [super init];
    if (self) {
        _dismissTransform     = CGAffineTransformMakeScale(.1, .1);
        _showInitialTransform = CGAffineTransformMakeScale(0, 0);
        _showFinalTransform   = CGAffineTransformIdentity;
        
        _springDamping  = 0.7;
        _springVelocity = 0.7;
        _showInitialAlpha = 0.f;
        _dismissFinalAlpha= 0.f;
        
        _showDuration    = 0.7;
        _dismissDuration = 0.5;
        _dismissOnTap    = YES;
    }
    return self;
}
@end

@implementation ZMJPositioning
- (instancetype)init
{
    self = [super init];
    if (self) {
        _bubbleHInset = 10.f;
        _bubbleVInset = 10.f;
        _textHInset = 10.f;
        _textVInset = 10.f;
        _maxWidth   = 200.f;
    }
    return self;
}
@end

@implementation ZMJDrawing
- (instancetype)init
{
    self = [super init];
    if (self) {
        _cornerRadius = 5.f;
        _arrowHeight  = 5.f;
        _arrowWidth   = 10.f;
        
        _foregroundColor = [UIColor whiteColor];
        _backgroundColor = [UIColor redColor];
        _arrowPosition   = ZMJArrowPosition_any;
        _textAlignment   = NSTextAlignmentCenter;
        _borderWidth = 0.f;
        _borderColor = [UIColor clearColor];
        _font        = [UIFont systemFontOfSize:15.f];
    }
    return self;
}
@end

@implementation ZMJPreferences
- (instancetype)init
{
    self = [super init];
    if (self) {
        _drawing     = [ZMJDrawing new];
        _positioning = [ZMJPositioning new];
        _animating   = [ZMJAnimating new];
        _shouldSelectDismiss = YES;
    }
    return self;
}

- (BOOL)hasBorder {
    return self.drawing.borderWidth > 0 && [self.drawing.borderColor isEqual:[UIColor clearColor]];
}
@end

@interface ZMJTipView () <UIGestureRecognizerDelegate>
@property (nonatomic, weak  ) UIView                *presentingView;
@property (nonatomic, weak  ) NSObject<ZMJTipViewDelegate> *delegate;
@property (nonatomic, assign) CGPoint                arrowTip;
@property (nonatomic, strong) ZMJPreferences        *preferences;
@property (nonatomic, assign) CGSize textSize;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation ZMJTipView
@dynamic globalPreferences;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text preferences:(ZMJPreferences *)preferences delegate:(id<ZMJTipViewDelegate>)delegate {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _text = text;
        preferences = preferences?: ZMJTipView.globalPreferences;
        _preferences = preferences;
        _delegate = delegate;
        
        [self addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil];
        
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"backgroundColor"];
}

- (void)setup {
    _arrowTip = CGPointZero;
}

- (void)handleRotation {
    if (self.superview == nil || self.presentingView == nil) {
        return;
    }
    __weak typeof(self) weak_self = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weak_self arrangeWithinSuperview:self.superview];
        [weak_self setNeedsDisplay];
    }];
}

// MARK: Private method
- (CGRect)computeFrameWithArrowPosition:(ZMJArrowPosition)postion refViewFrame:(CGRect)refViewFrame superviewFrame:(CGRect)superviewFrame {
    CGFloat xOrigin = 0;
    CGFloat yOrigin = 0;
    switch (postion) {
        case ZMJArrowPosition_top:
        case ZMJArrowPosition_any:
            xOrigin = CGRectGetMaxX(refViewFrame) - refViewFrame.size.width / 2 - self.contentSize.width / 2;
            yOrigin = CGRectGetMaxY(refViewFrame);
            break;
        case ZMJArrowPosition_bottom:
            xOrigin = CGRectGetMaxX(refViewFrame) - refViewFrame.size.width / 2 - self.contentSize.width / 2;
            yOrigin = CGRectGetMinY(refViewFrame) - self.contentSize.height;
            break;
        case ZMJArrowPosition_right:
            xOrigin = CGRectGetMinX(refViewFrame) - self.contentSize.width;
            yOrigin = CGRectGetMaxY(refViewFrame) - refViewFrame.size.height / 2 - self.contentSize.height / 2;
            break;
        case ZMJArrowPosition_left:
            xOrigin = CGRectGetMaxY(refViewFrame);
            yOrigin = CGRectGetMinY(refViewFrame) - self.contentSize.height / 2;
            break;
        default:
            break;
    }
    CGRect frame = CGRectMake(xOrigin, yOrigin, self.contentSize.width, self.contentSize.height);
    [self adjustFrame:&frame forSuperViewFrame:superviewFrame];
    return frame;
}

- (void)adjustFrame:(CGRect *)frame forSuperViewFrame:(CGRect)superviewFrame {
    // adjust horizontally
    if (frame->origin.x < 0) {
        frame->origin.x = 0;
    } else if (CGRectGetMaxX(*frame) > superviewFrame.size.width) {
        frame->origin.x = superviewFrame.size.width - frame->size.width;
    }
    
    // adjust vertically
    if (frame->origin.y < 0) {
        frame->origin.y = 0;
    } else if (CGRectGetMaxY(*frame) > superviewFrame.size.height) {
        frame->origin.y = superviewFrame.size.height - frame->size.height;
    }
}

- (BOOL)isFrameValid:(CGRect)frame forRefViewFrame:(CGRect)refViewFrame withinSuperviewFrame:(CGRect)superviewFrame {
    return !CGRectIntersectsRect(frame, refViewFrame);
}

- (void)arrangeWithinSuperview:(UIView *)superview {
    ZMJArrowPosition position = self.preferences.drawing.arrowPosition;
    
    CGRect refViewFrame = [self.presentingView convertRect:self.presentingView.bounds toView:superview];
    
    CGRect superviewFrame;
    if ([superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)superview;
        superviewFrame = CGRectMake(scrollView.frame.origin.x,
                                    scrollView.frame.origin.y,
                                    scrollView.contentSize.width,
                                    scrollView.contentSize.height);
    } else {
        superviewFrame = superview.frame;
    }
    
    CGRect frame = [self computeFrameWithArrowPosition:position refViewFrame:refViewFrame superviewFrame:superviewFrame];
    if (![self isFrameValid:frame forRefViewFrame:refViewFrame withinSuperviewFrame:superviewFrame]) {
        for (int idx = 0; idx < 4; idx++) {
            ZMJArrowPosition value = ZMJArrowPositionAllValues[idx];
            if (value == position) {
                continue;
            }
            CGRect newFrame = [self computeFrameWithArrowPosition:value refViewFrame:refViewFrame superviewFrame:superviewFrame];
            if ([self isFrameValid:newFrame forRefViewFrame:refViewFrame withinSuperviewFrame:superviewFrame]) {
                if (position != ZMJArrowPosition_any) {
                    NSLog(@"[ZMJTipView - Info] The arrow position you chose <%ld> could not be applied. Instead, position <%ld> has been applied! Please specify position <%ld> if you want ZMJTipView to choose a position for you.", (long)position, (long)value, (long)ZMJArrowPosition_any);
                }
                frame = newFrame;
                position = value;
                self.preferences.drawing.arrowPosition = value;
                break;
            }
        }
    }
    
    CGFloat arrowTipXOrigin = 0.f;
    switch (position) {
        case ZMJArrowPosition_bottom:
        case ZMJArrowPosition_top:
        case ZMJArrowPosition_any:
            if (frame.size.width < refViewFrame.size.width) {
                arrowTipXOrigin = self.contentSize.width / 2;
            } else {
                arrowTipXOrigin = fabs(frame.origin.x - refViewFrame.origin.x) + refViewFrame.size.width / 2;
            }
            self.arrowTip = CGPointMake(arrowTipXOrigin, position == ZMJArrowPosition_bottom ? self.contentSize.height - self.preferences.positioning.bubbleVInset : self.preferences.positioning.bubbleVInset);
            break;
        case ZMJArrowPosition_right:
        case ZMJArrowPosition_left:
            if (frame.size.height < refViewFrame.size.height) {
                arrowTipXOrigin = self.contentSize.height / 2;
            } else {
                arrowTipXOrigin = fabs(frame.origin.y - refViewFrame.origin.y) + refViewFrame.size.height / 2;
            }
            self.arrowTip = CGPointMake(self.preferences.drawing.arrowPosition == ZMJArrowPosition_left ? self.preferences.positioning.bubbleVInset : self.contentSize.width - self.preferences.positioning.bubbleVInset, arrowTipXOrigin);
            break;
        default:
            break;
    }
    self.frame = frame;
}

- (void)handleTap {
    ![self.delegate respondsToSelector:@selector(tipViewDidSelected:)] ?: [self.delegate tipViewDidSelected:self];
    if (self.preferences.shouldSelectDismiss) {
        [self dismissWithCompletion:nil];
    }
}

// MARK: Drawing
- (void)drawBubble:(CGRect)bubbleFrame arrowPosition:(ZMJArrowPosition)arrowPosition context:(CGContextRef)context {
    CGFloat arrowWidth = self.preferences.drawing.arrowWidth;
    CGFloat arrowHeight = self.preferences.drawing.arrowHeight;
    CGFloat cornerRadius = self.preferences.drawing.cornerRadius;
    
    CGMutablePathRef contourPath = CGPathCreateMutable();
    CGPathMoveToPoint(contourPath, NULL, self.arrowTip.x, self.arrowTip.y);
    switch (arrowPosition) {
        case ZMJArrowPosition_bottom:
        case ZMJArrowPosition_top:
        case ZMJArrowPosition_any:
            CGPathAddLineToPoint(contourPath, NULL, self.arrowTip.x - arrowWidth / 2, self.arrowTip.y + (arrowPosition == ZMJArrowPosition_bottom ? -1 : 1) * arrowHeight);
            if (arrowPosition == ZMJArrowPosition_bottom) {
                [self drawBubbleBottomShape:bubbleFrame cornerRadius:cornerRadius path:contourPath];
            } else {
                [self drawBubbleTopShape:bubbleFrame cornerRadius:cornerRadius path:contourPath];
            }
            CGPathAddLineToPoint(contourPath, NULL, self.arrowTip.x + arrowWidth / 2, self.arrowTip.y + (arrowPosition == ZMJArrowPosition_bottom ? -1 : 1) * arrowHeight);
            break;
        case ZMJArrowPosition_left:
        case ZMJArrowPosition_right:
            CGPathAddLineToPoint(contourPath, NULL, self.arrowTip.x + (arrowPosition == ZMJArrowPosition_right ? -1 : 1) * arrowHeight, self.arrowTip.y - arrowWidth / 2);
            if (arrowPosition == ZMJArrowPosition_right) {
                [self drawBubbleRightShape:bubbleFrame cornerRadius:cornerRadius path:contourPath];
            } else {
                [self drawBubbleLeftShape:bubbleFrame cornerRadius:cornerRadius path:contourPath];
            }
            CGPathAddLineToPoint(contourPath, NULL, self.arrowTip.x + (arrowPosition == ZMJArrowPosition_right ? -1 : 1) * arrowHeight, self.arrowTip.y + arrowWidth / 2);
            break;
        default:
            break;
    }
    CGPathCloseSubpath(contourPath);
    CGContextSetShadowWithColor(context, CGSizeZero, 10, [[UIColor blackColor] colorWithAlphaComponent:.6].CGColor);
    CGContextAddPath(context, contourPath);
    CGContextClosePath(context);
    
    [self paintBubble:context];
    if (self.preferences.hasBorder) {
        [self drawBorder:contourPath context:context];
    }
}

- (void)drawBubbleBottomShape:(CGRect)frame cornerRadius:(CGFloat)cornerRadius path:(CGMutablePathRef)path {
    CGPathAddArcToPoint(path, NULL, frame.origin.x, CGRectGetMaxY(frame), frame.origin.x, frame.origin.y, cornerRadius);
    CGPathAddArcToPoint(path, NULL, frame.origin.x, frame.origin.y, CGRectGetMaxX(frame), frame.origin.y, cornerRadius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(frame), frame.origin.y, CGRectGetMaxX(frame), CGRectGetMaxY(frame), cornerRadius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(frame), CGRectGetMaxY(frame), frame.origin.x, CGRectGetMaxY(frame), cornerRadius);
}

- (void)drawBubbleTopShape:(CGRect)frame cornerRadius:(CGFloat)cornerRadius path:(CGMutablePathRef)path {
    CGPathAddArcToPoint(path, NULL, frame.origin.x, frame.origin.y, frame.origin.x, CGRectGetMaxY(frame), cornerRadius);
    CGPathAddArcToPoint(path, NULL, frame.origin.x, CGRectGetMaxY(frame), CGRectGetMaxX(frame), CGRectGetMaxY(frame), cornerRadius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(frame), CGRectGetMaxY(frame), CGRectGetMaxX(frame), frame.origin.y, cornerRadius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(frame), frame.origin.y, frame.origin.x, frame.origin.y, cornerRadius);
}

- (void)drawBubbleRightShape:(CGRect)frame cornerRadius:(CGFloat)cornerRadius path:(CGMutablePathRef)path {
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(frame), frame.origin.y, frame.origin.x, frame.origin.y, cornerRadius);
    CGPathAddArcToPoint(path, NULL, frame.origin.x, frame.origin.y, frame.origin.x, CGRectGetMaxY(frame), cornerRadius);
    CGPathAddArcToPoint(path, NULL, frame.origin.x, CGRectGetMaxY(frame), CGRectGetMaxX(frame), CGRectGetMaxY(frame), cornerRadius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(frame), CGRectGetMaxY(frame), CGRectGetMaxX(frame), frame.size.height, cornerRadius);
}

- (void)drawBubbleLeftShape:(CGRect)frame cornerRadius:(CGFloat)cornerRadius path:(CGMutablePathRef)path {
    CGPathAddArcToPoint(path, NULL, frame.origin.x, frame.origin.y, CGRectGetMaxX(frame), frame.origin.y, cornerRadius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(frame), frame.origin.y, CGRectGetMaxX(frame), CGRectGetMaxY(frame), cornerRadius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(frame), CGRectGetMaxY(frame), frame.origin.x, CGRectGetMaxY(frame), cornerRadius);
    CGPathAddArcToPoint(path, NULL, frame.origin.x, CGRectGetMaxY(frame), frame.origin.x, frame.origin.y, cornerRadius);
}

- (void)paintBubble:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, self.preferences.drawing.backgroundColor.CGColor);
    CGContextFillPath(context);
}

- (void)drawBorder:(CGPathRef)path context:(CGContextRef)context {
    CGContextAddPath(context, path);
    CGContextSetStrokeColorWithColor(context, self.preferences.drawing.borderColor.CGColor);
    CGContextSetLineWidth(context, self.preferences.drawing.borderWidth);
    CGContextStrokePath(context);
}

- (void)drawText:(CGRect)bubbleFrame context:(CGContextRef)context {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = self.preferences.drawing.textAlignment;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect textRect = CGRectMake(bubbleFrame.origin.x + (bubbleFrame.size.width - self.textSize.width) / 2,
                                 bubbleFrame.origin.y + (bubbleFrame.size.height - self.textSize.height) / 2,
                                 self.textSize.width,
                                 self.textSize.height);
    [self.text drawInRect:textRect withAttributes:@{NSFontAttributeName: self.preferences.drawing.font,
                                                    NSForegroundColorAttributeName: self.preferences.drawing.foregroundColor,
                                                    NSParagraphStyleAttributeName: paragraphStyle}];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.fakeView) {
        CGRect bubbleFrame = [self _computeBubbleFrameAccordingPosition];
        self.fakeView.frame = bubbleFrame;
        //config fakeView
        self.fakeView.layer.cornerRadius = self.preferences.drawing.cornerRadius;
        self.fakeView.layer.masksToBounds = YES;
    }
}

- (void)drawRect:(CGRect)rect {
    CGRect bubbleFrame = [self _computeBubbleFrameAccordingPosition];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self drawBubble:bubbleFrame arrowPosition:self.preferences.drawing.arrowPosition context:context];
    CGContextRestoreGState(context);
    
    if (!self.fakeView) {
        CGContextSaveGState(context);
        [self drawText:bubbleFrame context:context];
        CGContextRestoreGState(context);
    }
}

- (CGRect)_computeBubbleFrameAccordingPosition {
    ZMJArrowPosition arrowPosition = self.preferences.drawing.arrowPosition;
    CGFloat bubbleWidth = 0.f;
    CGFloat bubbleHeight = 0.f;
    CGFloat bubbleXOrigin = 0.f;
    CGFloat bubbleYOrigin = 0.f;
    
    switch (arrowPosition) {
        case ZMJArrowPosition_bottom:
        case ZMJArrowPosition_top:
        case ZMJArrowPosition_any:
            bubbleWidth = self.contentSize.width - 2 * self.preferences.positioning.bubbleHInset;
            bubbleHeight= self.contentSize.height - 2 * self.preferences.positioning.bubbleVInset - self.preferences.drawing.arrowHeight;
            
            bubbleXOrigin = self.preferences.positioning.bubbleHInset;
            bubbleYOrigin = arrowPosition == ZMJArrowPosition_bottom ? self.preferences.positioning.bubbleVInset : self.preferences.positioning.bubbleVInset + self.preferences.drawing.arrowHeight;
            break;
        case ZMJArrowPosition_left:
        case ZMJArrowPosition_right:
            bubbleWidth = self.contentSize.width - 2 * self.preferences.positioning.bubbleHInset - self.preferences.drawing.arrowHeight;
            bubbleHeight = self.contentSize.height - 2 * self.preferences.positioning.bubbleVInset;
            
            bubbleXOrigin = arrowPosition == ZMJArrowPosition_right ? self.preferences.positioning.bubbleHInset : self.preferences.positioning.bubbleHInset + self.preferences.drawing.arrowHeight;
            bubbleYOrigin = self.preferences.positioning.bubbleVInset;
            break;
        default:
            break;
    }
    CGRect bubbleFrame = CGRectMake(bubbleXOrigin, bubbleYOrigin, bubbleWidth, bubbleHeight);
    return bubbleFrame;
}

// MARK: Variables
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UIColor *backgroundColor = (UIColor *)[change objectForKey:NSKeyValueChangeNewKey];
    if ([backgroundColor isEqual:[UIColor clearColor]]) {
        return;
    }
    self.preferences.drawing.backgroundColor = backgroundColor;
    [self removeObserver:self forKeyPath:@"backgroundColor"];
    [self setValue:[UIColor clearColor] forKey:keyPath];
    [self addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil];
}

- (NSString *)description {
    return [self debugDescription];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<<%@ with text: '%@'>>", NSStringFromClass([self class]), self.text];
}

static ZMJPreferences *_globalPreferences;
+ (ZMJPreferences *)globalPreferences {
    if (_globalPreferences == nil) {
        _globalPreferences = [ZMJPreferences new];
    }
    return _globalPreferences;
}

+ (void)setGlobalPreferences:(ZMJPreferences *)globalPreferences {
    if (globalPreferences) {
        _globalPreferences = globalPreferences;
    }
}

- (void)setFakeView:(UIView *)fakeView {
    _fakeView = fakeView;
    [self addSubview:fakeView];
}

// MARK: Lazy variables
- (CGSize)textSize {
    NSDictionary *attributes = @{NSFontAttributeName: self.preferences.drawing.font};
    
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.preferences.positioning.maxWidth, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil].size;
    textSize.width = ceilf(textSize.width);
    textSize.height = ceilf(textSize.height);
    
    if (textSize.width < self.preferences.drawing.arrowWidth) {
        textSize.width = self.preferences.drawing.arrowWidth;
    }
    return textSize;
}

- (CGSize)contentSize {
    if (self.fakeView) {
        return CGSizeMake([self.fakeView intrinsicContentSize].width + self.preferences.positioning.bubbleHInset * 2,
                          [self.fakeView intrinsicContentSize].height + self.preferences.positioning.bubbleVInset * 2 + self.preferences.drawing.arrowHeight);
    }
    
    CGSize contentSize = CGSizeMake(self.textSize.width + self.preferences.positioning.textHInset * 2 + self.preferences.positioning.bubbleHInset * 2,
                                    self.textSize.height + self.preferences.positioning.textVInset * 2 + self.preferences.positioning.bubbleVInset * 2 + self.preferences.drawing.arrowHeight);
    return contentSize;
}

// MARK: - UIGestureRecognizerDelegate implementation
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.preferences.animating.dismissOnTap;
}
@end

@implementation ZMJTipView (publicStuff)
+ (void)showAnimated:(BOOL)animated
             forItem:(UIBarItem *)item
     withinSuperview:(UIView *)superview
                text:(NSString *)text
         preferences:(ZMJPreferences *)preferences
            delegate:(id<ZMJTipViewDelegate>)delegate
{
    if (item.view) {
        preferences = preferences ?: ZMJTipView.globalPreferences;
        [self showAnimated:animated forView:item.view withinSuperview:superview text:text preferences:preferences delegate:delegate];
    }
}

+ (void)showAnimated:(BOOL)animated
             forView:(UIView *)view
     withinSuperview:(UIView *)superview
                text:(NSString *)text
         preferences:(ZMJPreferences *)preferences
            delegate:(id<ZMJTipViewDelegate>)delegate
{
    preferences = preferences ?: ZMJTipView.globalPreferences;
    ZMJTipView *tipview = [[ZMJTipView alloc] initWithText:text preferences:preferences delegate:delegate];
    [tipview showAnimated:animated forView:view withinSuperview:superview];
}

- (void)showAnimated:(BOOL)animated
             forItem:(UIBarItem *)item
     withinSuperview:(UIView *)superview
{
    if (item.view) {
        [self showAnimated:animated forView:item.view withinSuperview:superview];
    }
}

- (void)showAnimated:(BOOL)animated
             forView:(UIView *)view
     withinSuperview:(UIView *)superview
{
    NSAssert2(superview == nil || [view hashSuperview:superview], @"The supplied superview <\%@)> is not a direct nor an indirect superview of the supplied reference view <%@)>. The superview passed to this method should be a direct or an indirect superview of the reference view. To display the tooltip within the main window, ignore the superview parameter.", superview, view);
    
    if (!superview) {
        superview = [UIApplication sharedApplication].windows.firstObject;
    }
    
    CGAffineTransform initialTransform = self.preferences.animating.showInitialTransform;
    CGAffineTransform finalTransform = self.preferences.animating.showFinalTransform;
    CGFloat initialAlpha = self.preferences.animating.showInitialAlpha;
    CGFloat damping = self.preferences.animating.springDamping;
    CGFloat velocity = self.preferences.animating.springVelocity;
    
    self.presentingView = view;
    [self arrangeWithinSuperview:superview];
    
    self.transform = initialTransform;
    self.alpha = initialAlpha;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    [superview addSubview:self];
    
    __weak typeof(self) weak_self = self;
    void(^animations)(void) = ^(void) {
        weak_self.transform = finalTransform;
        weak_self.alpha = 1;
        self->_showing = YES;
    };
    
    if (animated) {
        [UIView animateWithDuration:self.preferences.animating.showDuration
                              delay:0
             usingSpringWithDamping:damping
              initialSpringVelocity:velocity
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:animations
                         completion:nil];
    } else {
        animations();
    }
}

- (void)dismissWithCompletion:(void(^)(void))completion {
    CGFloat damping = self.preferences.animating.springDamping;
    CGFloat velocity = self.preferences.animating.springVelocity;
    
    __weak typeof(self) weak_self = self;
    [UIView animateWithDuration:self.preferences.animating.dismissDuration
                          delay:0
         usingSpringWithDamping:damping
          initialSpringVelocity:velocity
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            weak_self.transform = self.preferences.animating.dismissTransform;
                            weak_self.alpha = self.preferences.animating.dismissFinalAlpha;
                        } completion:^(BOOL finished) {
                            [weak_self.delegate tipViewDidDimiss:weak_self];
                            [weak_self removeFromSuperview];
                            weak_self.transform = CGAffineTransformIdentity;
                            self->_showing = NO;
                            if (completion) completion();
                        }];
}
@end

// MARK: UIBarItem extension
@implementation UIBarItem (zmj_extension)
- (UIView *)view {
    if ([self isKindOfClass:[UIBarButtonItem class]] && [(UIBarButtonItem *)self customView]) {
        return [(UIBarButtonItem *)self customView];
    }
    return [[self valueForKey:@"view"] isKindOfClass:[UIView class]] ? [self valueForKey:@"view"] : nil;
}
@end

// MARK: UIView extension
@implementation UIView (zmj_extension)
- (BOOL)hashSuperview:(UIView *)superview {
    return [self viewHasSupperview:self superview:superview];
}

- (BOOL)viewHasSupperview:(UIView *)view superview:(UIView *)superview {
    if (view.superview) {
        if (view.superview == superview) {
            return YES;
        } else {
            return [self viewHasSupperview:view.superview superview:superview];
        }
    } else {
        return NO;
    }
}
@end
