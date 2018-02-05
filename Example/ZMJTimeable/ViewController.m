//
//  ViewController.m
//  ZMJTimeable
//
//  Created by Jason on 2018/2/5.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import "ViewController.h"
#import <ZMJGanttChart/ZMJGanttChart.h>
#import "ZMJCells.h"

@interface ViewController () <SpreadsheetViewDelegate, SpreadsheetViewDataSource>
@property (nonatomic, strong) SpreadsheetView *spreadsheetView;
@property (nonatomic, strong) NSArray<NSString *> * channels;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSArray<NSNumber *> *> *slotInfo;
@property (nonatomic, strong) NSDateFormatter *hourFormatter;
@property (nonatomic, strong) NSDateFormatter *twelveHourFormatter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.channels = @[
                     @"ABC", @"NNN", @"BBC", @"J-Sports", @"OK News", @"SSS", @"Apple", @"CUK", @"KKR", @"APAR",
                     @"SU", @"CCC", @"Game", @"Anime", @"Tokyo NX", @"NYC", @"SAN", @"Drama", @"Hobby", @"Music"];
    self.numberOfRows = 24 * 60  + 1;
    self.slotInfo = [NSMutableDictionary dictionary];
    
    self.hourFormatter       = [NSDateFormatter new];
    self.twelveHourFormatter = [NSDateFormatter new];
    
    self.hourFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.hourFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    self.hourFormatter.dateFormat = @"h\na";
    
    self.twelveHourFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.twelveHourFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    self.twelveHourFormatter.dateFormat = @"H";
    
    [self.spreadsheetView registerClass:[HourCell class] forCellWithReuseIdentifier:NSStringFromClass([HourCell class])];
    [self.spreadsheetView registerClass:[ChannelCell class] forCellWithReuseIdentifier:NSStringFromClass([ChannelCell class])];
    [self.spreadsheetView registerNib:[UINib nibWithNibName:NSStringFromClass([SlotCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SlotCell class])];
    [self.spreadsheetView registerClass:[MyBlankCell class] forCellWithReuseIdentifier:NSStringFromClass([MyBlankCell class])];
    
    self.spreadsheetView.backgroundColor = [[UIColor lightTextColor] colorWithAlphaComponent:.7];
    
    CGFloat hairline = 1 / [UIScreen mainScreen].scale;
    self.spreadsheetView.intercellSpacing = CGSizeMake(hairline, hairline);
    self.spreadsheetView.gridStyle = [GridStyle style:GridStyle_solid width:hairline color:[UIColor lightGrayColor]];
    self.spreadsheetView.circularScrolling = [CircularScrollingConfigurationBuilder configurationBuilderWithCircularScrollingState:ZMJCircularScrolling_horizontally_rowHeaderStartsFirstColumn];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.spreadsheetView flashScrollIndicators];
}

///Override
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

// MARK: DataSource
- (NSInteger)numberOfColumns:(SpreadsheetView *)spreadsheetView {
    return self.channels.count + 1;
}

- (NSInteger)numberOfRows:(SpreadsheetView *)spreadsheetView {
    return self.numberOfRows;
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView widthForColumn:(NSInteger)column {
    return column == 0 ? 30 : 130;
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView heightForRow:(NSInteger)row {
    return row == 0 ? 44 : 2;
}

- (NSInteger)frozenColumns:(SpreadsheetView *)spreadsheetView {
    return 1;
}

- (NSInteger)frozenRows:(SpreadsheetView *)spreadsheetView {
    return 1;
}

- (NSArray<ZMJCellRange *> *)mergedCells:(SpreadsheetView *)spreadsheetView {
    __block NSMutableArray<ZMJCellRange *> *mergedCells = [NSMutableArray array];
    
    for (int row = 0; row < 24; row++) {
        [mergedCells addObject:[ZMJCellRange cellRangeFrom:[Location locationWithRow:60 * row + 1 column:0]
                                                        to:[Location locationWithRow:60 * (row + 1) column:0]]];
    }
    NSArray<NSNumber *> *seeds = @[@5, @10, @20, @20, @30, @30, @30, @30, @40, @40, @50, @50, @60, @60, @60, @60, @90, @90, @90, @90, @120, @120, @120];
    __weak typeof(self) weak_self = self;
    [self.channels enumerateObjectsUsingBlock:^(NSString * _Nonnull channel, NSUInteger index, BOOL * _Nonnull stop) {
        NSInteger minutes = 0;
        while (minutes < 24 * 60) {
            NSInteger duration = seeds[arc4random_uniform((uint32_t)seeds.count)].integerValue;
            if (minutes + duration + 1 >= weak_self.numberOfRows) {
                [mergedCells addObject:[ZMJCellRange cellRangeFrom:[Location locationWithRow:minutes + 1 column:index + 1]
                                                                to:[Location locationWithRow:weak_self.numberOfRows - 1 column:index + 1]]];
                break;
            }
            ZMJCellRange *cellRange = [ZMJCellRange cellRangeFrom:[Location locationWithRow:minutes + 1 column:index + 1]
                                                               to:[Location locationWithRow:minutes + duration + 1 column:index + 1]];
            [mergedCells addObject:cellRange];
            [weak_self.slotInfo setObject:@[@(minutes), @(duration)] forKey:[NSIndexPath indexPathWithRow:cellRange.from.row column:cellRange.from.column]];
            minutes += duration + 1;
        }
    }];
    return mergedCells;
}

- (ZMJCell *)spreadsheetView:(SpreadsheetView *)spreadsheetView cellForItemAt:(NSIndexPath *)indexPath {
    if (indexPath.column == 0 && indexPath.row == 0) {
        return nil;
    }
    
    if (indexPath.column == 0 && indexPath.row > 0) {
        HourCell *cell = (HourCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HourCell class]) forIndexPath:indexPath];
        cell.label.text = [self.hourFormatter stringFromDate:[self.twelveHourFormatter dateFromString:[NSString stringWithFormat:@"%ld", (long)(indexPath.row / 60 % 24)]]];
        cell.gridlines.top = [GridStyle style:GridStyle_solid width:1 color:[UIColor whiteColor]];
        cell.gridlines.bottom = [GridStyle style:GridStyle_solid width:1 color:[UIColor whiteColor]];
        return cell;
    }
    
    if (indexPath.column > 0 && indexPath.row == 0) {
        ChannelCell *cell = (ChannelCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ChannelCell class]) forIndexPath:indexPath];
        cell.label.text = self.channels[indexPath.column - 1];
        cell.gridlines.top = [GridStyle style:GridStyle_solid width:1 color:[UIColor blackColor]];
        cell.gridlines.bottom = [GridStyle style:GridStyle_solid width:1 color:[UIColor whiteColor]];
        cell.gridlines.left = [GridStyle style:GridStyle_solid width:1/[UIScreen mainScreen].scale color:[UIColor colorWithWhite:.3 alpha:1]];
        cell.gridlines.right = cell.gridlines.left;
        return cell;
    }
    
    NSArray<NSNumber *> *minutesDuration = self.slotInfo[indexPath];
    if (minutesDuration) {
        NSInteger minutes = minutesDuration[0].integerValue;
        NSInteger duration = minutesDuration[1].integerValue;
        SlotCell *cell = (SlotCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SlotCell class]) forIndexPath:indexPath];
        cell.minutes = minutes % 60;
        cell.title = @"Dummy Text";
        cell.tableHighlight = duration > 20 ? @"Lorem ipsum dolor sit amet, consectetur adipiscing elit" : @"";
        return cell;
    }
    return [spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyBlankCell class]) forIndexPath:indexPath];
}

// MARK: Delegate
- (void)spreadsheetView:(SpreadsheetView *)spreadsheetView didSelectItemAt:(NSIndexPath *)indexPath {
    NSLog(@"Selected: (row: (%ld), column: (%ld)", indexPath.row, indexPath.column);
}

#pragma mark - getters
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


@end
