//
//  ZMJScrollView.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/19.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

@interface ZMJScrollView : UIScrollView
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnRecords; // number -> CGFloat
@property (nonatomic, strong) NSMutableArray<NSNumber *> *rowRecords;    // number -> CGFloat

@property (nonatomic, copy) TouchHandler touchesBegan;
@property (nonatomic, copy) TouchHandler touchesEnded;
@property (nonatomic, copy) TouchHandler touchesCancelled;

@property (nonatomic, assign) LayoutAttributes layoutAttributes;
@property (nonatomic, assign) State state;
@end
