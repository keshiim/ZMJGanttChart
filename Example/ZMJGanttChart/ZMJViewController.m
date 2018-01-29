//
//  ZMJViewController.m
//  ZMJGanttChart
//
//  Created by keshiim on 01/19/2018.
//  Copyright (c) 2018 keshiim. All rights reserved.
//

#import "ZMJViewController.h"
#import <ZMJGanttChart/ZMJGanttChart.h>
#import "ZMJCells.h"

@interface ZMJViewController () <SpreadsheetViewDelegate, SpreadsheetViewDataSource>
@property (nonatomic, strong) NSArray<NSString *>            *weaks;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *tasks;
@property (nonatomic, strong) NSArray<UIColor  *>            *colors;

@property (nonatomic, strong) SpreadsheetView *spreadsheetView;
@end

@implementation ZMJViewController

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
    self.weaks = @[@"Week #14", @"Week #15", @"Week #16", @"Week #17", @"Week #18", @"Week #19", @"Week #20"];
    self.tasks = @[@[@"Office itinerancy", @"2", @"17", @"0"],
                   @[@"Office facing", @"2", @"8", @"0"],
                   @[@"Interior office", @"2", @"7", @"1"],
                   @[@"Air condition check", @"3", @"7", @"1"],
                   @[@"Furniture installation", @"11", @"8", @"1"],
                   @[@"Workplaces preparation", @"11", @"8", @"2"],
                   @[@"The emproyee relocation", @"14", @"5", @"2"],
                   @[@"Preparing workspace", @"14", @"5", @"1"],
                   @[@"Workspaces importation", @"14", @"4", @"1"],
                   @[@"Workspaces exportation", @"14", @"3", @"0"],
                   @[@"Product launch", @"2", @"13", @"0"],
                   @[@"Perforn Initial testing", @"3", @"5", @"0"],
                   @[@"Development", @"3", @"11", @"1"],
                   @[@"Develop System", @"3", @"2", @"1"],
                   @[@"Beta Realese", @"6", @"2", @"1"],
                   @[@"Integrate System", @"8", @"2", @"1"],
                   @[@"Test", @"10", @"4", @"2"],
                   @[@"Promotion", @"22", @"8", @"2"],
                   @[@"Service", @"18", @"12", @"2"],
                   @[@"Marketing", @"10", @"4", @"1"],
                   @[@"The emproyee relocation", @"14", @"5", @"1"],
                   @[@"Land Survey", @"4", @"8", @"1"],
                   @[@"Plan Design", @"6", @"2", @"1"],
                   @[@"Test", @"10", @"4", @"0"],
                   @[@"Determine Cost", @"18", @"4", @"0"],
                   @[@"Review Hardware", @"20", @"6", @"0"],
                   @[@"Engineering", @"6", @"8", @"1"],
                   @[@"Define Concept", @"9", @"10", @"1"],
                   @[@"Compile Report", @"14", @"10", @"1"],
                   @[@"Air condition check", @"3", @"7", @"1"],
                   @[@"Review Data", @"16", @"20", @"2"],
                   @[@"Integrate System", @"8", @"2", @"2"],
                   @[@"Test", @"10", @"4", @"2"],
                   @[@"Determine Cost", @"18", @"4", @"0"],
                   @[@"Review Hardware", @"20", @"6", @"0"],
                   @[@"User Interview", @"14", @"5", @"1"],
                   @[@"Network", @"16", @"6", @"1"],
                   @[@"Software", @"8", @"8", @"1"],
                   @[@"Preparing workspace", @"14", @"5", @"0"],
                   @[@"Workspaces importation", @"14", @"4", @"0"],
                   @[@"Procedure", @"10", @"4", @"0"],
                   @[@"Perforn Initial testing", @"3", @"5", @"0"],
                   @[@"Development", @"3", @"11", @"2"],
                   @[@"Develop System", @"3", @"2", @"2"],
                   @[@"Interior office", @"2", @"7", @"2"],
                   @[@"Air condition check", @"3", @"7", @"1"],
                   @[@"Furniture installation", @"11", @"8", @"1"],
                   @[@"Beta Realese", @"6", @"2", @"0"],
                   @[@"Marketing", @"10", @"4", @"0"],
                   @[@"The emproyee relocation", @"14", @"5", @"0"],
                   @[@"Land Survey", @"4", @"8", @"0"],
                   @[@"Forms", @"12", @"3", @"1"],
                   @[@"Workspaces importation", @"14", @"4", @"1"],
                   @[@"Procedure", @"10", @"4", @"2"],
                   @[@"Perforn Initial testing", @"3", @"5", @"2"],
                   @[@"Development", @"3", @"11", @"2"],
                   @[@"Website", @"14", @"6", @"2"],
                   @[@"Assemble", @"3", @"4", @"0"],
                   @[@"Air condition check", @"3", @"7", @"0"],
                   @[@"Furniture installation", @"11", @"8", @"0"],
                   @[@"Workplaces preparation", @"11", @"8", @"1"],
                   @[@"Sales", @"5", @"6", @"1"],
                   @[@"Unit Test", @"7", @"8", @"2"],
                   @[@"Integration Test", @"20", @"10", @"2"],
                   @[@"Service", @"18", @"12", @"2"],
                   @[@"Promotion", @"22", @"8", @"1"],
                   @[@"Air condition check", @"3", @"7", @"1"],
                   @[@"Furniture installation", @"11", @"8", @"1"]
                   ];
    self.colors = @[[UIColor colorWithRed:0.314 green:0.698 blue:0.337 alpha:1],
                    [UIColor colorWithRed:1.000 green:0.718 blue:0.298 alpha:1],
                    [UIColor colorWithRed:0.180 green:0.671 blue:0.796 alpha:1],
                    ];
    self.spreadsheetView = ({
        SpreadsheetView *ssv = [SpreadsheetView new];
        if (@available(iOS 11.0, *)) {
            ssv.frame = self.view.safeAreaLayoutGuide.layoutFrame;
        } else {
            ssv.frame = self.view.bounds;
        }
        ssv.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:ssv];
        ssv;
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.spreadsheetView.dataSource = self;
    self.spreadsheetView.delegate = self;
    
    CGFloat hairline = 1 / [UIScreen mainScreen].scale;
    self.spreadsheetView.intercellSpacing = CGSizeMake(hairline, hairline);
    self.spreadsheetView.gridStyle = [[GridStyle alloc] initWithStyle:GridStyle_solid width:hairline color:[UIColor grayColor]];
    
    [self.spreadsheetView registerClass:[ZMJHeaderCell class] forCellWithReuseIdentifier:[ZMJHeaderCell description]];
    [self.spreadsheetView registerClass:[ZMJTextCell class] forCellWithReuseIdentifier:[ZMJTextCell description]];
    [self.spreadsheetView registerClass:[ZMJTaskCell class] forCellWithReuseIdentifier:[ZMJTaskCell description]];
    [self.spreadsheetView registerClass:[ZMJChatBarCell class] forCellWithReuseIdentifier:[ZMJChatBarCell description]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.spreadsheetView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: DataSource
- (NSInteger)numberOfColumns:(SpreadsheetView *)spreadsheetView {
    return 3 + 7 * self.weaks.count;
}

- (NSInteger)numberOfRows:(SpreadsheetView *)spreadsheetView {
    return 2 + self.tasks.count;
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView widthForColumn:(NSInteger)column {
    if (column == 0) {
        return 90.f;
    } else if (column >= 1 && column <= 2) {
        return 50.f;
    } else {
     return 50;
    }
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView heightForRow:(NSInteger)row {
    if (row <= 0 && row >= 1) {
        return 28.f;
    } else {
        return 34.f;
    }
}

- (NSInteger)frozenColumns:(SpreadsheetView *)spreadsheetView {
    return 3;
}

- (NSInteger)frozenRows:(SpreadsheetView *)spreadsheetView {
    return 2;
}

- (NSArray<ZMJCellRange *> *)mergedCells:(SpreadsheetView *)spreadsheetView {
    NSMutableArray<ZMJCellRange *> *result = [NSMutableArray array];
    NSArray<ZMJCellRange *> *titleHeader = @[[ZMJCellRange cellRangeFrom:[Location locationWithRow:0 column:0]
                                                                      to:[Location locationWithRow:1 column:0]],
                                             [ZMJCellRange cellRangeFrom:[Location locationWithRow:0 column:1]
                                                                      to:[Location locationWithRow:1 column:1]],
                                             [ZMJCellRange cellRangeFrom:[Location locationWithRow:0 column:2]
                                                                      to:[Location locationWithRow:1 column:2]],
                                             ];
    NSArray<ZMJCellRange *> *weekHeader = [self.weaks wbg_mapWithIndex:^ZMJCellRange* _Nullable(NSString * _Nonnull stuff, NSUInteger index) {
        return [ZMJCellRange cellRangeFrom:[Location locationWithRow:0 column:index * 7 + 3]
                                        to:[Location locationWithRow:0 column:index * 7 + 9]];
    }];
    NSArray<ZMJCellRange *> *charts = [self.tasks wbg_mapWithIndex:^ZMJCellRange* _Nullable(NSArray<NSString *> * _Nonnull task, NSUInteger index) {
        NSInteger start = [task[1] integerValue];
        NSInteger end   = [task[2] integerValue];
        return [ZMJCellRange cellRangeFrom:[Location locationWithRow:index + 2 column:start + 2]
                                        to:[Location locationWithRow:index + 2 column:start + end + 2]];
    }];
    [result addObjectsFromArray:titleHeader];
    [result addObjectsFromArray:weekHeader];
    [result addObjectsFromArray:charts];
    return result.copy;
}

- (ZMJCell *)spreadsheetView:(SpreadsheetView *)spreadsheetView cellForItemAt:(NSIndexPath *)indexPath {
    NSInteger column = indexPath.column;
    NSInteger row    = indexPath.row;
    if (column == 0 && row == 0) {
        ZMJHeaderCell *cell = (ZMJHeaderCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:[ZMJHeaderCell description] forIndexPath:indexPath];
        cell.label.text = @"Task";
        cell.gridlines.left = [GridStyle grid];
        cell.gridlines.right = [GridStyle borderStyleNone];
        return cell;
    }
    
}

/// Delegate
- (void)spreadsheetView:(SpreadsheetView *)spreadsheetView didSelectItemAt:(NSIndexPath *)indexPath {
    NSLog(@"Selected: (row: %ld, column: %ld", (long)indexPath.row, (long)indexPath.column);
}

@end


























