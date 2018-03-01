//
//  ZMJTipView.h
//  ZMJTipView
//
//  Created by Jason on 2018/2/8.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZMJArrowPosition) {
    ZMJArrowPosition_any = 0,
    ZMJArrowPosition_top,
    ZMJArrowPosition_bottom,
    ZMJArrowPosition_right,
    ZMJArrowPosition_left,
};

@class ZMJTipView, ZMJPreferences, ZMJDrawing, ZMJPositioning, ZMJAnimating;
@protocol ZMJTipViewDelegate;

@protocol ZMJTipViewDelegate <NSObject>
- (void)tipViewDidSelected:(ZMJTipView *)tipView;
- (void)tipViewDidDimiss:(ZMJTipView *)tipView;
@end

/**
 ZMJTipCustomView needs implement - intrinsicContentSize
 */
@protocol ZMJTipCustomViewProtocol
- (CGSize)intrinsicContentSize;
@end

@interface ZMJAnimating : NSObject
@property (nonatomic, assign) CGAffineTransform dismissTransform;
@property (nonatomic, assign) CGAffineTransform showInitialTransform;
@property (nonatomic, assign) CGAffineTransform showFinalTransform;
@property (nonatomic, assign) CGFloat springDamping; //阻尼率
@property (nonatomic, assign) CGFloat springVelocity;//加速率
@property (nonatomic, assign) CGFloat showInitialAlpha;
@property (nonatomic, assign) CGFloat dismissFinalAlpha;
@property (nonatomic, assign) CGFloat showDuration;
@property (nonatomic, assign) CGFloat dismissDuration;
@property (nonatomic, assign) BOOL dismissOnTap;
@end

@interface ZMJPositioning : NSObject
@property (nonatomic, assign) CGFloat bubbleHInset;
@property (nonatomic, assign) CGFloat bubbleVInset;
@property (nonatomic, assign) CGFloat textHInset;
@property (nonatomic, assign) CGFloat textVInset;
@property (nonatomic, assign) CGFloat maxWidth;
@end

@interface ZMJDrawing : NSObject
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat arrowHeight;
@property (nonatomic, assign) CGFloat arrowWidth;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) ZMJArrowPosition arrowPosition;
@property (nonatomic, assign) NSTextAlignment  textAlignment;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIFont  *font;
@end

@interface ZMJPreferences : NSObject
@property (nonatomic, strong) ZMJDrawing     *drawing;
@property (nonatomic, strong) ZMJPositioning *positioning;
@property (nonatomic, strong) ZMJAnimating   *animating;
@property (nonatomic, assign) BOOL hasBorder;
@property (nonatomic, assign) BOOL shouldSelectDismiss; //default is 'YES'
@end

@interface ZMJTipView : UIView
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithText:(NSString *)text preferences:(ZMJPreferences *)preferences delegate:(id<ZMJTipViewDelegate>)delegate;

@property (nonatomic, strong) NSString *text;
@property (class, nonatomic, strong) ZMJPreferences *globalPreferences;
@property (nonatomic, strong, readonly) ZMJPreferences *preferences;
@property (nonatomic, strong) UIView *fakeView;
@property (nonatomic, assign, getter=isShowing, readonly) BOOL showing;
@end

@interface ZMJTipView (publicStuff)

/**
 Presents an ZMJTipView pointing to a particular UIBarItem instance within the specified superview

 @param animated  Pass true to animate the presentation.
 @param item      The UIBarButtonItem or UITabBarItem instance which the EasyTipView will be pointing to.
 @param superview A view which is part of the UIBarButtonItem instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
 @param text      The text to be displayed.
 @param preferences The preferences which will configure the EasyTipView.
 @param delegate    The delegate.
 */
+ (void)showAnimated:(BOOL)animated forItem:(UIBarItem *)item withinSuperview:(UIView *)superview text:(NSString *)text preferences:(ZMJPreferences *)preferences delegate:(id<ZMJTipViewDelegate>)delegate;

/**
 Presents an ZMJTipView pointing to a particular UIView instance within the specified superview

 @param animated  Pass true to animate the presentation.
 @param view      The UIView instance which the EasyTipView will be pointing to.
 @param superview A view which is part of the UIBarButtonItem instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
 @param text      The text to be displayed.
 @param preferences The preferences which will configure the EasyTipView.
 @param delegate    The delegate.
 */
+ (void)showAnimated:(BOOL)animated forView:(UIView *)view withinSuperview:(UIView *)superview text:(NSString *)text preferences:(ZMJPreferences *)preferences delegate:(id<ZMJTipViewDelegate>)delegate;

/**
 Presents an ZMJTipView pointing to a particular UIBarItem instance within the specified superview

 @param animated  Pass true to animate the presentation.
 @param item      The UIBarButtonItem or UITabBarItem instance which the EasyTipView will be pointing to.
 @param superview A view which is part of the UIBarButtonItem instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
 */
- (void)showAnimated:(BOOL)animated forItem:(UIBarItem *)item withinSuperview:(UIView *)superview;

/**
 Presents an ZMJTipView pointing to a particular UIView instance within the specified superview

 @param animated  Pass true to animate the presentation.
 @param view      The UIView instance which the EasyTipView will be pointing to.
 @param superview A view which is part of the UIBarButtonItem instances superview hierarchy. Ignore this parameter in order to display the EasyTipView within the main window.
 */
- (void)showAnimated:(BOOL)animated forView:(UIView *)view withinSuperview:(UIView *)superview;

/**
 Dismisses the ZMJTipView

 @param completion Completion block to be executed after the EasyTipView is dismissed.
 */
- (void)dismissWithCompletion:(void(^)(void))completion;
@end

// MARK: UIBarItem extension
@interface UIBarItem (zmj_extension)
@property (nonatomic, strong, readonly) UIView *view;
@end

// MARK: UIView extension
@interface UIView (zmj_extension)
- (BOOL)hashSuperview:(UIView *)superview;
@end
