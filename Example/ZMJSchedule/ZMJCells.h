//
//  ZMJCells.h
//  ZMJSchedule
//
//  Created by Jason on 2018/2/6.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZMJGanttChart/ZMJGanttChart.h>

@interface DateCell : ZMJCell
@property (nonatomic, strong) UILabel *label;
@end

@interface DayTitleCell : ZMJCell

@end

@interface TimeTitleCell : ZMJCell

@end

@interface TimeCell : ZMJCell

@end

@interface ScheduleCell : ZMJCell

@end
