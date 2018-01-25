//
//  ZMJScrollView.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/19.
//  Copyright © 2018年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "Borders.h"
#import "ZMJCell.h"
#import "Gridlines.h"
#import "ReuseQueue.h"

@interface ZMJScrollView : UIScrollView
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnRecords; // number -> CGFloat
@property (nonatomic, strong) NSMutableArray<NSNumber *> *rowRecords;    // number -> CGFloat

@property (nonatomic, copy) TouchHandler touchesBegan;
@property (nonatomic, copy) TouchHandler touchesEnded;
@property (nonatomic, copy) TouchHandler touchesCancelled;

@property (nonatomic, assign) LayoutAttributes layoutAttributes;
@property (nonatomic, assign, readwrite) State state;

@property (nonatomic, strong) ReusableCollection<ZMJCell *>  *visibleCells;
@property (nonatomic, strong) ReusableCollection<Gridline *> *visibleVerticalGridlines;
@property (nonatomic, strong) ReusableCollection<Gridline *> *visibleHorizontalGridlines;
@property (nonatomic, strong) ReusableCollection<Border *>   *visibleBorders;

@property (nonatomic, assign) BOOL hasDisplayedContent;

- (void)resetReusableObjects;
@end
