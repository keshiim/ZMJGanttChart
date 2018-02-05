//
//  ViewController.m
//  ZMJClassData
//
//  Created by Jason on 2018/2/2.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import "ViewController.h"
#import <ZMJGanttChart/ZMJGanttChart.h>
#import "ZMJCells.h"

typedef NS_ENUM(NSInteger, ZMJSorting) {
    ZMJAscending = 0,
    ZMJDsescending
};

static NSString * getSymbol(ZMJSorting sorting) {
    switch (sorting) {
        case ZMJAscending:
            return @"\u25B2";
            break;
        case ZMJDsescending:
            return @"\u25BC";
            break;
        default:
            break;
    }
}

typedef struct SortedColumn {
    NSInteger column;
    ZMJSorting sorting;
} SortedColumn;

@interface ViewController () <SpreadsheetViewDelegate, SpreadsheetViewDataSource>
@property (nonatomic, strong) SpreadsheetView *spreadsheetView;
@property (nonatomic, assign) SortedColumn sortedColumn;

/// data
@property (nonatomic, strong) NSArray<NSString *> *header;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.spreadsheetView registerClass:[HeaderCell class] forCellWithReuseIdentifier:NSStringFromClass([HeaderCell class])];
    [self.spreadsheetView registerClass:[TextCell class] forCellWithReuseIdentifier:NSStringFromClass([TextCell class])];
    
    self.sortedColumn = (SortedColumn){0, ZMJAscending};
    
    NSString *content = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"data" withExtension:@"tsv"]
                                                 encoding:NSUTF8StringEncoding
                                                    error:NULL];
    NSMutableArray<NSArray<NSString *> *> * data = [[content componentsSeparatedByString:@"\r\n"] wbg_map:^NSArray<NSString *> * _Nullable(NSString * _Nonnull stuff) {
        return [stuff componentsSeparatedByString:@"\t"];
    }].mutableCopy;
    self.header = data[0];
    [data removeObjectAtIndex:0];
    self.data   = data.copy;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.spreadsheetView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: DataSource
- (NSInteger)numberOfColumns:(SpreadsheetView *)spreadsheetView {
    return self.header.count;
}

- (NSInteger)numberOfRows:(SpreadsheetView *)spreadsheetView {
    return self.data.count + 1;
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView widthForColumn:(NSInteger)column {
    return 140;
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView heightForRow:(NSInteger)row {
    return row == 0 ? 60 : 40;
}

- (NSInteger)frozenRows:(SpreadsheetView *)spreadsheetView {
    return 1;
}

- (ZMJCell *)spreadsheetView:(SpreadsheetView *)spreadsheetView cellForItemAt:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HeaderCell *cell = (HeaderCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HeaderCell class])
                                                                                    forIndexPath:indexPath];
        cell.label.text = self.header[indexPath.column];
        
        if (indexPath.column == self.sortedColumn.column) {
            cell.sortArrow.text = getSymbol(self.sortedColumn.sorting);
        } else {
            cell.sortArrow.text = @"";
        }
        return cell;
    } else {
        TextCell *cell = (TextCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TextCell class])
                                                                                forIndexPath:indexPath];
        cell.label.text = self.data[indexPath.row - 1][indexPath.column];
        return cell;
    }
}

- (void)viewWillLayoutSubviews {
    if (@available(iOS 11.0, *)) {
        self.spreadsheetView.frame = self.view.safeAreaLayoutGuide.layoutFrame;
    } else {
        // Fallback on earlier versions
        self.spreadsheetView.frame = self.view.bounds;
    }
}

// MARK: Delegate
- (void)spreadsheetView:(SpreadsheetView *)spreadsheetView didSelectItemAt:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.sortedColumn.column == indexPath.column) {
            SortedColumn sc = self.sortedColumn;
            sc.sorting = self.sortedColumn.sorting == ZMJAscending ? ZMJDsescending : ZMJAscending;
            self.sortedColumn = sc;
        } else {
            self.sortedColumn = (SortedColumn){indexPath.column, ZMJAscending};
        }
        __weak typeof(self)weak_self = self;
        self.data = [self.data sortedArrayUsingComparator:^NSComparisonResult(NSArray<NSString *>*  _Nonnull obj1, NSArray<NSString *>*  _Nonnull obj2) {
            NSComparisonResult ascending = [obj1[weak_self.sortedColumn.column] compare:obj2[weak_self.sortedColumn.column]];
            return weak_self.sortedColumn.sorting == ZMJAscending ?
            (ascending == NSOrderedAscending ? ascending : NSOrderedDescending) :
            (ascending == NSOrderedAscending ? NSOrderedDescending : ascending);
        }];
        [self.spreadsheetView reloadData];
    }
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
