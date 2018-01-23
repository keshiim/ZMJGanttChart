//
//  ZMJScrollView.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/19.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMJLayoutEngine.h"

typedef void(^TouchHandler)(NSSet<UITouch *> *touches, UIEvent *event);

struct ZMJState {
    CGRect frame;
    CGSize contentSize;
    CGSize contentOffset;
};
typedef struct ZMJState State;

typedef NS_OPTIONS(NSUInteger, ZMJScrollPosition) {
    // The vertical positions are mutually exclusive to each other, but are bitwise or-able with the horizontal scroll positions.
    // Combining positions from the same grouping (horizontal or vertical) will result in an NSInvalidArgumentException.
    ScrollPosition_top                 = 1 << 0,
    ScrollPosition_centeredVertiically = 1 << 1,
    ScrollPosition_bottom              = 1 << 2,
    
    // Likewise, the horizontal positions are mutually exclusive to each other.
    ScrollPosition_left                = 1 << 3,
    ScrollPosition_centeredHorizontally= 1 << 4,
    ScrollPosition_right               = 1 << 5,
} ScrollPosition;

@interface ZMJScrollView : UIScrollView
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnRecords; // number -> CGFloat
@property (nonatomic, strong) NSMutableArray<NSNumber *> *rowRecords;    // number -> CGFloat

@property (nonatomic, copy) TouchHandler touchesBegan;
@property (nonatomic, copy) TouchHandler touchesEnded;
@property (nonatomic, copy) TouchHandler touchesCancelled;

@property (nonatomic, assign) LayoutAttributes layoutAttributes;
@property (nonatomic, assign) State state;
@end
