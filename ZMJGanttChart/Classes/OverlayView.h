//
//  OverlayView.h
//  DoubleConversion
//
//  Created by ms on 2019/12/2.
//

#import <UIKit/UIKit.h>


typedef void (^TouchOnHeader)(BOOL isTouchOnHeader);
@interface OverlayView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *tableHeaderView;

@property (nonatomic, assign) BOOL isTouchOnHeader;

@property (nonatomic, copy) TouchOnHeader touchOnHeader;

@property (nonatomic, assign) BOOL isEndAnimation;

@end


