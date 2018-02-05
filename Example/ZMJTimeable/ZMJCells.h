//
//  ZMJCells.h
//  ZMJTimeable
//
//  Created by Jason on 2018/2/5.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZMJGanttChart/ZMJGanttChart.h>

@interface HourCell : ZMJCell
@property (nonatomic, strong) UILabel *label;
@end

@interface ChannelCell: ZMJCell
@property (nonatomic, strong) UILabel  *label;
@property (nonatomic, strong) NSString *channel;
@end

@interface SlotCell: ZMJCell
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tableHighlightLabel;

@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *tableHighlight;

@end

@interface MyBlankCell: BlankCell

@end
