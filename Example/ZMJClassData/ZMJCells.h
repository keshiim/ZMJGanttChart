//
//  ZMJCells.h
//  ZMJClassData
//
//  Created by Jason on 2018/2/5.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZMJGanttChart/ZMJGanttChart.h>

@interface HeaderCell : ZMJCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *sortArrow;
@end

@interface TextCell : ZMJCell
@property (nonatomic, strong) UILabel *label;
@end
