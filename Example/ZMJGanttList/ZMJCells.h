//
//  ZMJCells.h
//  ZMJGanttList
//
//  Created by Jason on 2018/2/26.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import <ZMJGanttChart/ZMJGanttChart.h>

@interface ZMJHeaderCell : ZMJCell
@property (nonatomic, strong) UILabel *label;
@end

@interface ZMJTaskCell : ZMJCell
@property (nonatomic, strong) UILabel *label;
@end

@interface ZMJChartBarCell : ZMJCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView  *colorBarView;
@property (nonatomic, strong) UIColor *color;
@end
