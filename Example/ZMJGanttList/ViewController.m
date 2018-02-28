//
//  ViewController.m
//  ZMJGanttList
//
//  Created by Jason on 2018/2/26.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import "ViewController.h"
#import <ZMJGanttChart/ZMJGanttChart.h>
#import "ZMJCells.h"
#import "ZMJTask.h"

typedef NS_ENUM(NSInteger, ZMJTimeUnit) {
    ZMJTimeUnit_week,
    ZMJTimeUnit_month,
    ZMJTimeUnit_year,
};

typedef NS_ENUM(NSInteger, ZMJDisplayMode) {
    ZMJDisplayMode_daily,
    ZMJDisplayMode_weekly,
    ZMJDisplayMode_monthly,
};

@interface ViewController () <SpreadsheetViewDelegate, SpreadsheetViewDataSource>
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong, readonly) NSArray<NSDate *> *years;
@property (nonatomic, strong, readonly) NSArray<NSDate *> *weeks;
@property (nonatomic, strong, readonly) NSArray<NSDate *> *months;
@property (nonatomic, strong, readonly) NSArray<NSDate *> *days;
@property (nonatomic, strong) NSArray<ZMJTask *>          *tasks;
@property (nonatomic, strong) NSArray<UIColor *>          *colors;

@property (nonatomic, strong) SpreadsheetView *spreadsheetView;
@property (nonatomic, assign) ZMJDisplayMode   displayMode;
@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupMembers];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupMembers];
    }
    return self;
}


- (void)setupMembers {
    self.tasks = @[[ZMJTask taskWithName:@"Office itinerancy" startDate:dateFromString(@"2017-12-7") endDate:dateFromString(@"2017-12-15")],
                   [ZMJTask taskWithName:@"Office facingy" startDate:dateFromString(@"2017-12-8") endDate:dateFromString(@"2017-12-12")],
                   [ZMJTask taskWithName:@"Office itinerancy" startDate:dateFromString(@"2017-12-10") endDate:dateFromString(@"2017-12-12")],
                   [ZMJTask taskWithName:@"Interior office" startDate:dateFromString(@"2018-1-1") endDate:dateFromString(@"2018-1-3")],
                   [ZMJTask taskWithName:@"Air condition check" startDate:dateFromString(@"2017-12-7") endDate:dateFromString(@"2017-12-19")],
                   [ZMJTask taskWithName:@"Office itinerancy" startDate:dateFromString(@"2017-12-24") endDate:dateFromString(@"2017-12-30")],
                   [ZMJTask taskWithName:@"Office facingy" startDate:dateFromString(@"2017-12-18") endDate:dateFromString(@"2018-1-2")],
                   [ZMJTask taskWithName:@"Office facingy" startDate:nil endDate:dateFromString(@"2017-12-8")],
                   [ZMJTask taskWithName:@"Office facingy" startDate:dateFromString(@"2017-12-9") endDate:nil],
                   ];
    self.colors = @[[UIColor colorWithRed:72/255.f  green:194/255.f blue:169/255.f  alpha:1],
                    [UIColor colorWithRed:255/255.f green:121/255.f blue:121/255.f alpha:1],
                    [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1],
                    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat hairline = 1 / [UIScreen mainScreen].scale;
    self.spreadsheetView.intercellSpacing = CGSizeMake(hairline, hairline);
    self.spreadsheetView.gridStyle = [[GridStyle alloc] initWithStyle:GridStyle_solid width:hairline color:[UIColor grayColor]];
    
    [self.spreadsheetView registerClass:[ZMJHeaderCell class]   forCellWithReuseIdentifier:[ZMJHeaderCell description]];
    [self.spreadsheetView registerClass:[ZMJTaskCell class]     forCellWithReuseIdentifier:[ZMJTaskCell description]];
    [self.spreadsheetView registerClass:[ZMJChartBarCell class] forCellWithReuseIdentifier:[ZMJChartBarCell description]];
    
    self.displayMode = ZMJDisplayMode_monthly;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.spreadsheetView flashScrollIndicators];
}

- (void)viewWillLayoutSubviews {
    if (@available(iOS 11.0, *)) {
        self.spreadsheetView.frame = self.view.safeAreaLayoutGuide.layoutFrame;
    } else {
        // Fallback on earlier versions
        self.spreadsheetView.frame = self.view.bounds;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: properties
- (void)setDisplayMode:(ZMJDisplayMode)displayMode {
    _displayMode = displayMode;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//       [self.spreadsheetView reloadDataIfNeeded];
    });
}

- (SpreadsheetView *)spreadsheetView {
    if (!_spreadsheetView) {
        _spreadsheetView = ({
            SpreadsheetView *ssv = [SpreadsheetView new];
            ssv.dataSource = self;
            ssv.delegate   = self;
            ssv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:ssv];
            ssv;
        });
    }
    return _spreadsheetView;
}

- (NSDate *)startDate {
    if (!_startDate) {
        static NSDateFormatter *formatter = nil;
        if (!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
        }
        _startDate = [formatter dateFromString:@"2017-12-07"];
    }
    return _startDate;
}

- (NSDate *)endDate {
    if (!_endDate) {
        static NSDateFormatter *formatter = nil;
        if (!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
        }
        _endDate = [formatter dateFromString:@"2018-01-07"];
    }
    return _endDate;
}

- (NSArray<NSDate *> *)days {
    if (self.startDate && self.endDate) {
        return [self getDayArrayLeftDate:self.startDate rightDate:self.endDate];
    }
    return nil;
}

- (NSArray<NSDate *> *)years {
    return [self fetchDateAccordingTimeUnit:ZMJTimeUnit_year];
}

- (NSArray<NSDate *> *)months {
    return [self fetchDateAccordingTimeUnit:ZMJTimeUnit_month];
}

- (NSArray<NSDate *> *)weeks {
    return [self fetchDateAccordingTimeUnit:ZMJTimeUnit_week];
}

- (NSArray<NSDate *> *)fetchDateAccordingTimeUnit:(ZMJTimeUnit)timeUnit {
    NSCalendarUnit calendarUnit =   NSCalendarUnitYear |
                                    NSCalendarUnitMonth |
                                    NSCalendarUnitDay |
                                    NSCalendarUnitHour |
                                    NSCalendarUnitMinute |
                                    NSCalendarUnitSecond |
                                    NSCalendarUnitWeekOfMonth |
                                    NSCalendarUnitWeekday |
                                    NSCalendarUnitWeekdayOrdinal |
                                    NSCalendarUnitWeekOfMonth |
                                    NSCalendarUnitWeekOfYear;
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger  previousDate = -1;
    NSMutableArray<NSDate *> *_months = [NSMutableArray array];
    for (NSDate *date in self.days) {
        NSDateComponents *dateComponents = [greCalendar components:calendarUnit
                                                          fromDate:date];
        long long dateComponentTimeUnitValue = NSIntegerMin;
        switch (timeUnit) {
            case ZMJTimeUnit_week:
                dateComponentTimeUnitValue = dateComponents.weekdayOrdinal;
                break;
            case ZMJTimeUnit_month:
                dateComponentTimeUnitValue = dateComponents.month;
                break;
            case ZMJTimeUnit_year:
                dateComponentTimeUnitValue = dateComponents.year;
                break;
        }
        if ([date isEqualToDate:self.days.firstObject] || (previousDate != dateComponentTimeUnitValue)) {
            [_months addObject:date];
            previousDate = dateComponentTimeUnitValue;
        }
    }
    return _months.copy;
}

//MARK: Generate ZMJCellRanges
- (NSArray<ZMJCellRange *> *)yearCellRangesWithRow:(NSInteger)row {
    static NSMutableArray<ZMJCellRange *> *_yearCellRanges = nil;
    if (_yearCellRanges == nil) {
        _yearCellRanges = [NSMutableArray array];
    }
    if (_yearCellRanges.count != 0) {
        return _yearCellRanges.copy;
    }
    Location *fromLocation = nil;
    Location *toLocation   = nil;
    for (NSDate *fristDayOfYear in self.years) {
        for (NSDate *date in self.days) {
            if ([date isEqualToDate:fristDayOfYear] ||
                ([date isEqualToDate:self.days.lastObject] && [fristDayOfYear isEqualToDate:self.years.lastObject])) {
                if ([self.days indexOfObject:date] > 0) {
                    toLocation = [Location locationWithRow:row column:[self.days indexOfObject:date] - 1];
                }
                BOOL addFlag = NO;
                if (fromLocation && toLocation) {
                    [_yearCellRanges addObject:[ZMJCellRange cellRangeFrom:fromLocation
                                                                        to:toLocation]];
                    toLocation = nil;
                    addFlag    = YES;
                }
                fromLocation = [Location locationWithRow:row column:[self.days indexOfObject:date]];
                if (addFlag && ![fristDayOfYear isEqualToDate:self.years.lastObject]) {
                    break;
                }
            }
        }
    }
    
    return _yearCellRanges.copy;
}

- (NSArray<ZMJCellRange *> *)monthCellRanges {
    return [self monthCellRangesWithRow:0];
}

- (NSArray<ZMJCellRange *> *)monthCellRangesWithRow:(NSInteger)row {
    NSMutableArray<ZMJCellRange *> *_monthCellRanges = [NSMutableArray array];
    Location *fromLocation = nil;
    Location *toLocation   = nil;
    for (NSDate *fristDayOfmonth in self.months) {
        for (NSDate *date in self.days) {
            if ([date isEqualToDate:fristDayOfmonth] ||
                ([date isEqualToDate:self.days.lastObject] && [fristDayOfmonth isEqualToDate:self.months.lastObject])) {
                if ([self.days indexOfObject:date] > 0) {
                    toLocation = [Location locationWithRow:row column:[self.days indexOfObject:date] - 1];
                }
                if (fromLocation && toLocation) {
                    [_monthCellRanges addObject:[ZMJCellRange cellRangeFrom:fromLocation
                                                                         to:toLocation]];
                    toLocation   = nil;
                }
                fromLocation = [Location locationWithRow:row column:[self.days indexOfObject:date]];
            }
        }
    }
    
    return _monthCellRanges.copy;
}

- (NSArray<ZMJCellRange *> *)weekCellRangesWithRow:(NSInteger)row {
    static NSMutableArray<ZMJCellRange *> *_weekCellRanges = nil;
    if (_weekCellRanges == nil) {
        _weekCellRanges = [NSMutableArray array];
    }
    if (_weekCellRanges.count != 0) {
        return _weekCellRanges.copy;
    }
    Location *fromLocation = nil;
    Location *toLocation   = nil;
    for (NSDate *fristDayOfWeek in self.weeks) {
        for (NSDate *date in self.days) {
            if ([date isEqualToDate:fristDayOfWeek] ||
                ([date isEqualToDate:self.days.lastObject] && [fristDayOfWeek isEqualToDate:self.weeks.lastObject])) {
                if ([self.days indexOfObject:date] > 0) {
                    toLocation = [Location locationWithRow:row column:[self.days indexOfObject:date] - 1];
                }
                BOOL addFlag = NO;
                if (fromLocation && toLocation) {
                    [_weekCellRanges addObject:[ZMJCellRange cellRangeFrom:fromLocation
                                                                         to:toLocation]];
                    toLocation = nil;
                    addFlag    = YES;
                }
                fromLocation = [Location locationWithRow:row column:[self.days indexOfObject:date]];
                if (addFlag && ![fristDayOfWeek isEqualToDate:self.weeks.lastObject]) {
                    break;
                }
            }
        }
    }
    
    return _weekCellRanges.copy;
}

//MARK: DataSource
- (NSInteger)numberOfColumns:(SpreadsheetView *)spreadsheetView {
    return self.days.count - 1;
}

- (NSInteger)numberOfRows:(SpreadsheetView *)spreadsheetView {
    return 2 + self.tasks.count;
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView widthForColumn:(NSInteger)column {
    switch (self.displayMode) {
        case ZMJDisplayMode_daily:
            return 50.f;
            break;
        case ZMJDisplayMode_weekly:
            return 50.f/3;
            break;
        case ZMJDisplayMode_monthly:
            return 50.f/6;
            break;
    }
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView heightForRow:(NSInteger)row {
    if (row >= 0 && row <= 1) {
        return 30.f;
    } else {
        return 34.f;
    }
}

- (NSInteger)frozenColumns:(SpreadsheetView *)spreadsheetView {
    return 0;
}

- (NSInteger)frozenRows:(SpreadsheetView *)spreadsheetView {
    return 2;
}

- (NSArray<ZMJCellRange *> *)mergedCells:(SpreadsheetView *)spreadsheetView {
    NSMutableArray<ZMJCellRange *> *result = [NSMutableArray array];
    switch (self.displayMode) {
        case ZMJDisplayMode_daily:
        {
            NSArray<ZMJCellRange *> *titleHeader = [self monthCellRangesWithRow:0];
            __weak typeof(self) weak_self = self;
            NSArray<ZMJCellRange *> *charts = [self.tasks wbg_mapWithIndex:^id _Nullable(ZMJTask * _Nonnull task, NSUInteger index) {
                ZMJCellRange *cellRange = nil;
                if (task.startDate && task.dueDate) {
                    cellRange = [ZMJCellRange cellRangeFrom:[Location locationWithRow:index + 2
                                                                               column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.startDate]]
                                                         to:[Location locationWithRow:index + 2
                                                                               column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.dueDate]]];
                } else {
                    cellRange = [ZMJCellRange cellRangeFrom:[Location locationWithRow:index + 2
                                                                               column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.startDate ?: task.dueDate]]
                                                         to:[Location locationWithRow:index + 2
                                                                               column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.startDate ?: task.dueDate]]];
                }
                return cellRange;
            }];
            [result addObjectsFromArray:titleHeader];
            [result addObjectsFromArray:charts];
        }
            break;
        case ZMJDisplayMode_weekly:
        {
            NSArray<ZMJCellRange *> *titleHeader     = [self monthCellRangesWithRow:0];
            NSArray<ZMJCellRange *> *weekTitleHeader = [self weekCellRangesWithRow:1];
            __weak typeof(self) weak_self = self;
            NSArray<ZMJCellRange *> *charts = [self.tasks wbg_mapWithIndex:^id _Nullable(ZMJTask * _Nonnull task, NSUInteger index) {
                ZMJCellRange *cellRange = nil;
                if (task.startDate && task.dueDate) {
                    cellRange = [ZMJCellRange cellRangeFrom:[Location locationWithRow:index + 2
                                                                               column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.startDate]]
                                                         to:[Location locationWithRow:index + 2
                                                                               column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.dueDate]]];
                } else {
                    if (task.startDate) { //startDate not nil
                        cellRange = [ZMJCellRange cellRangeFrom:[Location locationWithRow:index + 2
                                                                                   column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.startDate]]
                                                             to:[Location locationWithRow:index + 2
                                                                                   column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.startDate] + 2]];
                    } else { //dueDate not nil
                        NSInteger start = getMinIndex([weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.dueDate], 2);
                        cellRange = [ZMJCellRange cellRangeFrom:[Location locationWithRow:index + 2
                                                                                   column:start]
                                                             to:[Location locationWithRow:index + 2
                                                                                   column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.dueDate]]];
                    }
                }
                return cellRange;
            }];
            [result addObjectsFromArray:titleHeader];
            [result addObjectsFromArray:weekTitleHeader];
            [result addObjectsFromArray:charts];
        }
            break;
        case ZMJDisplayMode_monthly:
        {
            NSArray<ZMJCellRange *> *titleHeader      = [self yearCellRangesWithRow:0];
            NSArray<ZMJCellRange *> *monthTitleHeader = [self monthCellRangesWithRow:1];
            
            __weak typeof(self) weak_self = self;
            NSArray<ZMJCellRange *> *charts = [self.tasks wbg_mapWithIndex:^id _Nullable(ZMJTask * _Nonnull task, NSUInteger index) {
                ZMJCellRange *cellRange = nil;
                if (task.startDate && task.dueDate) {
                    cellRange = [ZMJCellRange cellRangeFrom:[Location locationWithRow:index + 2
                                                                               column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.startDate]]
                                                         to:[Location locationWithRow:index + 2
                                                                               column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.dueDate]]];
                } else {
                    if (task.startDate) { //startDate not nil
                        cellRange = [ZMJCellRange cellRangeFrom:[Location locationWithRow:index + 2
                                                                                   column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.startDate]]
                                                             to:[Location locationWithRow:index + 2
                                                                                   column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.startDate] + 5]];
                    } else { //dueDate not nil
                        NSInteger start = getMinIndex([weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.dueDate], 5);
                        cellRange = [ZMJCellRange cellRangeFrom:[Location locationWithRow:index + 2
                                                                                   column:start]
                                                             to:[Location locationWithRow:index + 2
                                                                                   column:[weak_self getDistanceLeftDate:weak_self.startDate rightDate:task.dueDate]]];
                    }
                }
                return cellRange;
            }];
            [result addObjectsFromArray:titleHeader];
            [result addObjectsFromArray:monthTitleHeader];
            [result addObjectsFromArray:charts];
        }
            break;
    }
    
    return result.copy;
}

- (ZMJCell *)spreadsheetView:(SpreadsheetView *)spreadsheetView cellForItemAt:(NSIndexPath *)indexPath {
    NSInteger column = indexPath.column;
    NSInteger row    = indexPath.row;
    if (row < 2) {
        ZMJHeaderCell *cell = (ZMJHeaderCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:[ZMJHeaderCell description] forIndexPath:indexPath];
        __weak typeof(self)weak_self = self;
        if (row == 0) {
            switch (self.displayMode) {
                case ZMJDisplayMode_daily:
                case ZMJDisplayMode_weekly:
                {
                    NSDate *(^getVilabelDateBlock)(NSInteger r, NSInteger c) = ^NSDate *(NSInteger r, NSInteger c) {
                        for (ZMJCellRange *range in [weak_self monthCellRangesWithRow:r]) {
                            if (range.from.row == r && range.from.column == c) {
                                return weak_self.months[[[weak_self monthCellRangesWithRow:r] indexOfObject:range]];
                            }
                        }
                        return nil;
                    };
                    
                    cell.label.text = [self formateMonthLimmited:getVilabelDateBlock(row, column)];
                }
                    break;
                case ZMJDisplayMode_monthly:
                {
                    NSDate *(^getVilabelDateBlock)(NSInteger r, NSInteger c) = ^NSDate *(NSInteger r, NSInteger c) {
                        for (ZMJCellRange *range in [weak_self yearCellRangesWithRow:r]) {
                            if (range.from.row == r && range.from.column == c) {
                                return weak_self.years[[[weak_self yearCellRangesWithRow:r] indexOfObject:range]];
                            }
                        }
                        return nil;
                    };
                    
                    cell.label.text = [self formateYearLimmited:getVilabelDateBlock(row, column)];
                }
                    break;
            }
        } else {
            switch (self.displayMode) {
                case ZMJDisplayMode_daily:
                    cell.label.text = [self dailyAppendWeaklyForDate:self.days[column]];
                    break;
                case ZMJDisplayMode_weekly:
                {
                    NSInteger(^getVilabelIdxBlock)(NSInteger r, NSInteger c) = ^NSInteger(NSInteger r, NSInteger c) {
                        for (NSInteger idx = 0; idx < [weak_self weekCellRangesWithRow:r].count; idx++) {
                            ZMJCellRange *range = [weak_self weekCellRangesWithRow:r][idx];
                            if (range.from.row == r && range.from.column == c) {
                                return idx;
                            }
                        }
                        return 0;
                    };
                    
                    cell.label.text = [NSString stringWithFormat:@"第%@周", [self translationArabicNum:[self getweekdayOrdinalWithDate:self.weeks[getVilabelIdxBlock(row, column)]]]];
                }
                    break;
                case ZMJDisplayMode_monthly:
                {
                    NSInteger(^getVilabelIdxBlock)(NSInteger r, NSInteger c) = ^NSInteger(NSInteger r, NSInteger c) {
                        for (NSInteger idx = 0; idx < [weak_self monthCellRangesWithRow:r].count; idx++) {
                            ZMJCellRange *range = [weak_self monthCellRangesWithRow:r][idx];
                            if (range.from.row == r && range.from.column == c) {
                                return idx;
                            }
                        }
                        return 0;
                    };
                    cell.label.text = [NSString stringWithFormat:@"第%@月", [self translationArabicNum:[self getmonthOrdinalWithDate:self.years[getVilabelIdxBlock(row, column)]]]];
                }
                    break;
            }
        }
        cell.gridlines.left  = [GridStyle style:GridStyle_default width:0 color:nil];
        cell.gridlines.right = [GridStyle style:GridStyle_default width:0 color:nil];
        return cell;
    } else {
        ZMJChartBarCell *cell = (ZMJChartBarCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:[ZMJChartBarCell description] forIndexPath:indexPath];
        ZMJTask *task = self.tasks[row - 2];
        
        NSInteger start = [self getDistanceLeftDate:self.startDate rightDate:task.startDate ?: task.dueDate];
        if (task.startDate == nil) {
            switch (self.displayMode) {
                case ZMJDisplayMode_daily:
                    break;
                case ZMJDisplayMode_weekly:
                {
                    start = getMinIndex([self getDistanceLeftDate:self.startDate rightDate:task.dueDate], 2);
                }
                    break;
                case ZMJDisplayMode_monthly:
                {
                    start = getMinIndex([self getDistanceLeftDate:self.startDate rightDate:task.dueDate], 5);
                }
                    break;
            }
        }
        if (start == column) {
            cell.label.text = self.tasks[row - 2].taskName;
            NSInteger colorIndex = arc4random() % 3;
            cell.color = self.colors[colorIndex];
            
            if (task.startDate == nil) {
                cell.direction = ZMJDashlineDirectionLeft;
            } else if (task.dueDate == nil) {
                cell.direction = ZMJDashlineDirectionRight;
            } else {
                cell.direction = ZMJDashlineDirectionNone;
            }
            
            if (self.displayMode != ZMJDisplayMode_daily) {
                cell.gridlines.right   = [GridStyle borderStyleNone];
            }
        } else {
            cell.label.text = @"";
            cell.color = [UIColor clearColor];
            cell.gridlines.right   = [GridStyle style:GridStyle_default width:0 color:nil];
        }
        cell.gridlines.bottom  = [GridStyle borderStyleNone];
        cell.gridlines.top     = [GridStyle borderStyleNone];
        
        __weak typeof(self)weak_self = self;
        switch (self.displayMode) {
            case ZMJDisplayMode_daily:
                break;
            case ZMJDisplayMode_weekly:
            {
                BOOL(^enableLeftGridlineBlock)(NSInteger r, NSInteger c) = ^BOOL(NSInteger r, NSInteger c) {
                    for (ZMJCellRange *range in [weak_self weekCellRangesWithRow:1]) {
                        if (range.from.column == c) {
                            return YES;
                        }
                    }
                    return NO;
                };
                cell.gridlines.left = enableLeftGridlineBlock(row, column) ? [GridStyle style:GridStyle_default width:0 color:nil] : [GridStyle borderStyleNone];
            }
                break;
            case ZMJDisplayMode_monthly:
            {
                BOOL(^enableLeftGridlineBlock)(NSInteger r, NSInteger c) = ^BOOL(NSInteger r, NSInteger c) {
                    for (ZMJCellRange *range in [weak_self monthCellRangesWithRow:1]) {
                        if (range.from.column == c) {
                            return YES;
                        }
                    }
                    return NO;
                };
                cell.gridlines.left = enableLeftGridlineBlock(row, column) ? [GridStyle style:GridStyle_default width:0 color:nil] : [GridStyle borderStyleNone];
            }
                break;
        }
        return cell;
    }
    return nil;
}

/// Delegate
- (void)spreadsheetView:(SpreadsheetView *)spreadsheetView didSelectItemAt:(NSIndexPath *)indexPath {
    NSLog(@"Selected: (row: %ld, column: %ld)", (long)indexPath.row, (long)indexPath.column);
}


//MARK: Utils
// 获取当月的天数
- (NSInteger)getNumberOfDaysInMonth:(NSDate *)theDay {
    NSAssert(theDay != nil, @"theDay is null.");

    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSGregorianCalendar - ios 8
    NSDate * currentDate = [NSDate date];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay  //NSDayCalendarUnit - ios 8
                                   inUnit: NSCalendarUnitMonth //NSMonthCalendarUnit - ios 8
                                  forDate:currentDate];
    return range.length;
}

/**
 *  获取当月中所有天数是周几
 */
- (NSArray<NSString *> *)getAllDaysWithCalender:(NSDate *)theDay {
    NSAssert(theDay != nil, @"theDay is null.");
    
    NSUInteger dayCount = [self getNumberOfDaysInMonth:theDay]; //一个月的总天数
    
    static NSDateFormatter * formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat:@"yyyy-MM"];
    NSString * str = [formatter stringFromDate:theDay];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableArray * allDaysArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i <= dayCount; i++) {
        NSString * sr = [NSString stringWithFormat:@"%@-%ld",str,i];
        NSDate *suDate = [formatter dateFromString:sr];
        [allDaysArray addObject:[NSString stringWithFormat:@"%02ld %@", i, [self getweekDayWithDate:suDate]]];
    }
    NSLog(@"allDaysArray %@",allDaysArray);
    return allDaysArray.copy;
}

/**
 *  获得某天的数据
 *  获取指定的日期是星期几
 */
- (NSString *)getweekDayWithDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    // 1 是周日，2是周一 3.以此类推
    return [self translationArabicNum:[comps weekday]];
}

/**
 *  获取指定的日期当前月的第几周
 */
- (NSInteger)getweekdayOrdinalWithDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:date];
    
    return [comps weekdayOrdinal];
}

/**
 *  获取指定的日期当年的第几月
 */
- (NSInteger)getmonthOrdinalWithDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth fromDate:date];
    
    return [comps month];
}

/**
 *  将阿拉伯数字转换为中文数字
 */
- (NSString *)translationArabicNum:(NSInteger)arabicNum {
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

/**
 *  yyyy-MM
 */
- (NSString *)formateMonthLimmited:(NSDate *)theDay {
    NSAssert(theDay != nil, @"theDay is null.");
    
    static NSDateFormatter * formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM"];
    }
    return [formatter stringFromDate:theDay];
}

/**
 *  yyyy
 */
- (NSString *)formateYearLimmited:(NSDate *)theDay {
    NSAssert(theDay != nil, @"theDay is null.");
    
    static NSDateFormatter * formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
    }
    return [formatter stringFromDate:theDay];
}


//获取两个日期之间的所有日期，精确到天
- (NSArray<NSDate *> *)getDayArrayLeftDate:(NSDate *)aLeftDate rightDate:(NSDate *)aRightDate {
    NSAssert(aLeftDate < aRightDate, @"aLeftDate must less equal aRightDate!");
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
    }
    
    NSMutableArray<NSDate *> *results  = [NSMutableArray arrayWithCapacity:0];
    NSCalendar *gregorian        = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate          = aLeftDate;
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                fromDate:currentDate];
    while (currentDate <= aRightDate) {
        NSDate *tDate = [gregorian dateFromComponents:components];
        currentDate = tDate;
        [results addObject:tDate];
        [components setDay:([components day] + 1)];
    }
    return results.copy;
}

//获取两个日期之间的距离
- (NSInteger)getDistanceLeftDate:(NSDate *)aLeftDate rightDate:(NSDate *)aRightDate {
    NSAssert(aLeftDate <= aRightDate, @"aLeftDate must less equal aRightDate!");
    
    if (aLeftDate == aRightDate) {
        return  0;
    }

    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
    }
    
    NSCalendar *gregorian        = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate          = aLeftDate;
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                fromDate:currentDate];
    NSInteger result = 0;
    while (currentDate < aRightDate) {
        result += 1;
        [components setDay:([components day] + 1)]; //自增
        currentDate = [gregorian dateFromComponents:components];
    }
    return result;
}

///日和星期几拼接
- (NSString *)dailyAppendWeaklyForDate:(NSDate *)date {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd";
    }
    return [NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:date], [self getweekDayWithDate:date]];
}

NSDate *dateFromString(NSString *dateStr) {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [formatter dateFromString:dateStr];
}

NSInteger getMinIndex(NSInteger begin, NSInteger offset) {
    for (NSInteger i = offset; i >= 0; i--) {
        if (begin - offset >= 0) {
            return begin - offset;
        }
    }
    return 0;
}
@end
