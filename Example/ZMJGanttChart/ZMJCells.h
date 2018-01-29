//
//  ZMJCells.h
//  ZMJGanttChart_Example
//
//  Created by Jason on 2018/1/29.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import "UIKit/UIKit.h"
#import <ZMJGanttChart/ZMJGanttChart.h>

@interface ZMJHeaderCell : ZMJCell
@property (nonatomic, strong) UILabel *label;
@end

@interface ZMJTextCell : ZMJCell
@property (nonatomic, strong) UILabel *label;
@end

@interface ZMJTaskCell : ZMJCell
@property (nonatomic, strong) UILabel *label;
@end

@interface ZMJChatBarCell : ZMJCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView  *colorBarView;
@property (nonatomic, strong) UIColor *color;
@end
