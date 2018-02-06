//
//  ViewController.m
//  ZMJSchedule
//
//  Created by Jason on 2018/2/6.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import "ViewController.h"
#import "ZMJCells.h"

@interface ViewController () <SpreadsheetViewDelegate, SpreadsheetViewDataSource>
@property (nonatomic, strong) SpreadsheetView *spreadsheetView;

@property (nonatomic, strong) NSArray<NSString *> *dates;
@property (nonatomic, strong) NSArray<NSString *> *days;
@property (nonatomic, strong) NSArray<UIColor *>  *dayColors;
@property (nonatomic, strong) NSArray<NSString *> *hours;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *data;

@property (nonatomic, strong) UIColor *evenRowColor; //偶数
@property (nonatomic, strong) UIColor *oddRowColor;  //奇数
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupMembers];
    [self setupviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.spreadsheetView flashScrollIndicators];
}

- (void)setupMembers {
    
    self.dates = @[@"7/10/2017", @"7/11/2017", @"7/12/2017", @"7/13/2017", @"7/14/2017", @"7/15/2017", @"7/16/2017"];
    self.days  = @[@"MONDAY", @"TUESDAY", @"WEDNSDAY", @"THURSDAY", @"FRIDAY", @"SATURDAY", @"SUNDAY"];
    self.dayColors = @[ [UIColor colorWithRed:0.918 green:0.224 blue:0.153 alpha:1],
                        [UIColor colorWithRed:0.106 green:0.541 blue:0.827 alpha:1],
                        [UIColor colorWithRed:0.200 green:0.620 blue:0.565 alpha:1],
                        [UIColor colorWithRed:0.953 green:0.498 blue:0.098 alpha:1],
                        [UIColor colorWithRed:0.400 green:0.584 blue:0.141 alpha:1],
                        [UIColor colorWithRed:0.835 green:0.655 blue:0.051 alpha:1],
                        [UIColor colorWithRed:0.153 green:0.569 blue:0.835 alpha:1]];
    self.hours = @[@"6:00 AM", @"7:00 AM", @"8:00 AM", @"9:00 AM", @"10:00 AM", @"11:00 AM", @"12:00 AM", @"1:00 PM", @"2:00 PM",
                   @"3:00 PM", @"4:00 PM", @"5:00 PM", @"6:00 PM", @"7:00 PM", @"8:00 PM", @"9:00 PM", @"10:00 PM", @"11:00 PM"];
    self.evenRowColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1];
    self.oddRowColor  = [UIColor whiteColor];
    self.data = @[
                  @[@"", @"", @"Take medicine", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"Movie with family", @"", @"", @"", @"", @"", @""],
                  @[@"Leave for cabin", @"", @"", @"", @"", @"Lunch with Tim", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @""],
                  @[@"", @"", @"", @"", @"Downtown parade", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @""],
                  @[@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"Fireworks show", @"", @"", @""],
                  @[@"", @"", @"", @"", @"", @"Family BBQ", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @""],
                  @[@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @""],
                  @[@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"Return home", @"", @"", @"", @"", @"", @""]
                  ];
}

- (void)setupviews {
    
    self.spreadsheetView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    
    self.spreadsheetView.intercellSpacing = CGSizeMake(4, 1);
    self.spreadsheetView.gridStyle = GridStyle_none;
    
    [self.spreadsheetView registerClass:[DateCell class]     forCellWithReuseIdentifier:NSStringFromClass([DateCell class])];
    [self.spreadsheetView registerClass:[TimeTitleCell class]forCellWithReuseIdentifier:NSStringFromClass([TimeTitleCell class])];
    [self.spreadsheetView registerClass:[TimeCell class]     forCellWithReuseIdentifier:NSStringFromClass([TimeCell class])];
    [self.spreadsheetView registerClass:[DayTitleCell class] forCellWithReuseIdentifier:NSStringFromClass([DayTitleCell class])];
    [self.spreadsheetView registerClass:[ScheduleCell class] forCellWithReuseIdentifier:NSStringFromClass([ScheduleCell class])];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        self.spreadsheetView.frame = self.view.safeAreaLayoutGuide.layoutFrame;
    } else {
        //Fallback on earlier version
        self.spreadsheetView.frame = self.view.bounds;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: DataSource
- (NSInteger)numberOfColumns:(SpreadsheetView *)spreadsheetView {
    return 1 + self.days.count;
}

- (NSInteger)numberOfRows:(SpreadsheetView *)spreadsheetView {
    return 2 + self.hours.count;
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView widthForColumn:(NSInteger)column {
    if (0 == column) {
        return 70.f;
    } else {
        return 120.f;
    }
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView heightForRow:(NSInteger)row {
    if (0 == row) {
        return 24;
    } else if (1 == row) {
        return 32;
    } else {
        return 40;
    }
}

- (NSInteger)frozenColumns:(SpreadsheetView *)spreadsheetView {
    return 1;
}

- (NSInteger)frozenRows:(SpreadsheetView *)spreadsheetView {
    return 2;
}

- (ZMJCell *)spreadsheetView:(SpreadsheetView *)spreadsheetView cellForItemAt:(NSIndexPath *)indexPath {
    if ((indexPath.column >= 1 && indexPath <= self.dates.count + 1) &&
        (indexPath.row    == 0))
    {
        DateCell *cell  = (DateCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DateCell class])
                                                                                 forIndexPath:indexPath];
        cell.label.text = self.dates[indexPath.column - 1];
        return cell;
    } else if ((indexPath.column >= 1 && indexPath.column <= self.days.count + 1) &&
               (indexPath.row    == 1))
    {
        DayTitleCell *cell = (DayTitleCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DayTitleCell class])
                                                                                        forIndexPath:indexPath];
        cell.label.text      = self.days[indexPath.column - 1];
        cell.label.textColor = self.dayColors[indexPath.column - 1];
        return cell;
    } else if ((indexPath.column == 0) &&
               (indexPath.row    == 1))
    {
        TimeTitleCell *cell = (TimeTitleCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TimeTitleCell class])
                                                                                          forIndexPath:indexPath];
        cell.label.text     = @"TIME";
        return cell;
    } else if ((indexPath.column == 0) &&
               (indexPath.row    >= 2 && indexPath.row <= self.hours.count + 2))
    {
        TimeCell *cell = (TimeCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TimeCell class])
                                                                                forIndexPath:indexPath];
        cell.label.text      = self.hours[indexPath.row - 2];
        cell.backgroundColor = indexPath.row % 2 == 0 ? self.evenRowColor : self.oddRowColor;
        return cell;
    } else if ((indexPath.column >= 1 && indexPath.column <= self.days.count + 1) &&
               (indexPath.row    >= 2 && indexPath.row <= self.hours.count + 2))
    {
        ScheduleCell *cell = (ScheduleCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ScheduleCell class])
                                                                                        forIndexPath:indexPath];
        NSString *text = self.data[indexPath.column - 1][indexPath.row - 2];
        if (text && text.length != 0) {
            cell.label.text = text;
            UIColor *color  = self.dayColors[indexPath.column - 1];
            cell.label.textColor = color;
            cell.color           = [color colorWithAlphaComponent:.2];
            cell.borders.top     = [[BorderStyle alloc] initWithStyle:BorderStyle_solid width:2 color:color];
            cell.borders.bottom  = [[BorderStyle alloc] initWithStyle:BorderStyle_solid width:2 color:color];
        } else {
            cell.label.text     = nil;
            cell.color          = indexPath.row % 2 == 0 ? self.evenRowColor : self.oddRowColor;
            cell.borders.top    = [BorderStyle borderStyleNone];
            cell.borders.bottom = [BorderStyle borderStyleNone];
        }
        return cell;
    }
}

// MARK: Delegate
- (void)spreadsheetView:(SpreadsheetView *)spreadsheetView didSelectItemAt:(NSIndexPath *)indexPath {
    NSLog(@"Selected: (Row: %ld, Column: %ld", (long)indexPath.row, (long)indexPath.column);
}

#pragma mark - lazy
- (SpreadsheetView *)spreadsheetView {
    if (!_spreadsheetView) {
        _spreadsheetView = [SpreadsheetView new];
        _spreadsheetView.delegate   = self;
        _spreadsheetView.dataSource = self;
        _spreadsheetView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_spreadsheetView];
    }
    return _spreadsheetView
}

@end
