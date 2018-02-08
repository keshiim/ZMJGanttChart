# ZMJGanttChart

[![CI Status](http://img.shields.io/travis/keshiim/ZMJGanttChart.svg?style=flat)](https://travis-ci.org/keshiim/ZMJGanttChart)
[![Version](https://img.shields.io/cocoapods/v/ZMJGanttChart.svg?style=flat)](http://cocoapods.org/pods/ZMJGanttChart)
[![License](https://img.shields.io/cocoapods/l/ZMJGanttChart.svg?style=flat)](http://cocoapods.org/pods/ZMJGanttChart)
[![Platform](https://img.shields.io/cocoapods/p/ZMJGanttChart.svg?style=flat)](http://cocoapods.org/pods/ZMJGanttChart)

## Introduce
Full configurable sheet view user interfaces for iOS applications. With this framework,
you can easily create complex layouts like schedule, gantt chart or timetable as if you are using Excel.

<img src="Resource/DailySchedule_portrait.png" style="width: 300px; height: 534px;" width="300" height="534"></img>&nbsp;&nbsp;<img src="Resource/DailySchedule_landscape.png" style="width: 534px; height: 300px;" width="534" height="300"></img><br>
<img src="Resource/Timetable.png" style="width: 300px; height: 534px;" width="300" height="534"></img>&nbsp;&nbsp;
<img src="Resource/GanttChart.png" style="width: 534px; height: 300px;" width="534" height="300"></img>

## Features
- [x] Fixed column and row headers
- [x] Merge cells
- [x] Circular infinite scrolling automatically
- [x] Customize gridlines and borders for each cell
- [x] Customize inter cell spacing vertically and horizontally
- [x] Fast scrolling, memory efficient
- [x] `UICollectionView` like API
- [ ] Well unit tested

#### Find the above displayed 4 examples in the [`Examples`](https://github.com/keshiim/ZMJGanttChart/tree/master/Example) folder.
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
SpreadsheetView is written in Objective-c 2.0 Compatible with iOS 8.0+
## Installation

ZMJGanttChart is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZMJGanttChart'
```
## Getting Started
The minimum requirement is connecting a data source to return the number of columns/rows, and each column width/row height.
```objc
#import <UIKit/UIKit.h>
#import <ZMJGanttChart/ZMJGanttChart.h>

@interface ViewController () <SpreadsheetViewDelegate, SpreadsheetViewDataSource>
@property (nonatomic, strong) SpreadsheetView *spreadsheetView;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.spreadsheetView.delegate = self;
    self.spreadsheetView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.spreadsheetView flashScrollIndicators];
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

#pragma mark - getters
- (SpreadsheetView *)spreadsheetView {
    if (!_spreadsheetView) {
        _spreadsheetView = ({
        SpreadsheetView *ssv = [SpreadsheetView new];
        ssv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:ssv];
        ssv;
        });
    }
    return _spreadsheetView;
}

// MARK: DataSource
- (NSInteger)numberOfColumns:(SpreadsheetView *)spreadsheetView {
    return 10;
}

- (NSInteger)numberOfRows:(SpreadsheetView *)spreadsheetView {
    return 20;
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView widthForColumn:(NSInteger)column {
    return 120.f;
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView heightForRow:(NSInteger)row {
    return 40;
}

@end
```
## Usage
### Freeze column and row headers
Freezing a column or row behaves as a fixed column/row header.

#### Column Header
```objc
- (NSInteger)frozenColumns:(SpreadsheetView *)spreadsheetView {
    return 2;
}
```
<img src="Resource/ColumnHeader.gif" style="width: 200px;" width="200"></img>

#### Row Header
```objc
- (NSInteger)frozenRows:(SpreadsheetView *)spreadsheetView {
    return 2;
}
```
<img src="Resource/RowHeader.gif" style="width: 200px;" width="200"></img>

#### both
```objc
- (NSInteger)frozenColumns:(SpreadsheetView *)spreadsheetView {
    return 2;
}

- (NSInteger)frozenRows:(SpreadsheetView *)spreadsheetView {
    return 2;
}
```

<img src="Resource/BothHeaders.gif" style="width: 200px;" width="200"></img>

### Merge cells
Multiple cells can be merged and then they are treated as one cell. It is used for grouping cells.
```objc
- (NSArray<ZMJCellRange *> *)mergedCells:(SpreadsheetView *)spreadsheetView {
    return @[
    [ZMJCellRange cellRangeFrom:[Location locationWithRow:1 column:1] to:[Location locationWithRow:3 column:2]]],
    [ZMJCellRange cellRangeFrom:[Location locationWithRow:3 column:3] to:[Location locationWithRow:8 column:3]]],
    [ZMJCellRange cellRangeFrom:[Location locationWithRow:4 column:0] to:[Location locationWithRow:7 column:2]]],
    [ZMJCellRange cellRangeFrom:[Location locationWithRow:2 column:4] to:[Location locationWithRow:5 column:8]]],
    [ZMJCellRange cellRangeFrom:[Location locationWithRow:9 column:0] to:[Location locationWithRow:10 column:5]]],
    [ZMJCellRange cellRangeFrom:[Location locationWithRow:11 column:2] to:[Location locationWithRow:12 column:4]]],
    ];
}
```
<img src="Resource/MergedCells.png" style="width: 200px;" width="200"></img>

### Circular Scrolling
Your table acquires infinite scroll just set `circularScrolling` property.

#### Enable horizontal circular scrolling
```objc
spreadsheetView.circularScrolling = [Configuration instance].horizontally;
```

#### Enable vertical circular scrolling
```objc
spreadsheetView.circularScrolling = [Configuration instance].vertically;
```

#### Both
```objc
spreadsheetView.circularScrolling = [Configuration instance].both
```

<img src="Resource/CircularScrolling.gif" style="width: 200px;" width="200"></img>

If circular scrolling is enabled, you can set additional parameters that the option not to repeat column/row header and to extend column/row header to the left/top edges. `CircularScrolling.Configuration` is a builder pattern,  can easily select the appropriate combination by chaining properties.

__e.g.__
```objc
spreadsheetView.circularScrolling = [CircularScrollingConfigurationBuilder configurationBuilderWithCircularScrollingState:ZMJCircularScrolling_horizontally_columnHeaderNotRepeated];
```

```objc
spreadsheetView.circularScrolling = [CircularScrollingConfigurationBuilder configurationBuilderWithCircularScrollingState:ZMJCircularScrolling_both_columnHeaderStartsFirstRow;
```

### Customize gridlines, borders and cell spacing
You can customize the appearance of grid lines and borders of the cell. You can specify whether a cell has a grid line or border. Grid lines and borders can be displayed on the left, right, top, or bottom, or around all four sides of the cell.

The difference between gridlines and borders is that the gridlines are drawn at the center of the inter-cell spacing, but the borders are drawn to fit around the cell.

#### Cell spacing

<img src="Resource/IntercellSpacing.png" style="width: 200px;" width="200"></img>

```objc
spreadsheetView.intercellSpacing = CGSizeMake(1, 1);
```

#### Gridlines

<img src="Resource/Grid.png" style="width: 200px;" width="200"></img>

`SpreadsheetView`'s `gridStyle` property is applied to the entire table.
```objc
spreadsheetView.gridStyle = [GridStyle style:GridStyle_solid width:1 color:[UIColor lightGray]];
```

You can set different `gridStyle` for each cell and each side of the cell. If you set cell's `gridStyle` property to` default`, `SpreadsheetView`'s` gridStyle` property will be applied. Specify `none` means the grid will not be drawn.
```objc
cell.gridlines.top   = [GridStyle style:GridStyle_solid width:1 color:[UIColor blue]];
cell.gridlines.left  = [GridStyle style:GridStyle_solid width:1 color:[UIColor blue]];
cell.gridlines.bottom= [GridStyle borderStyleNone];
cell.gridlines.right = [GridStyle borderStyleNone];
```
#### Border

<img src="Resource/Border.png" style="width: 200px;" width="200"></img>

You can set different `borderStyle` for each cell as well.

```objc
cell.borders.top   = [GridStyle style:GridStyle_solid width:1 color:[UIColor red]];
cell.borders.left  = [GridStyle style:GridStyle_solid width:1 color:[UIColor red]];
cell.borders.bottom= [GridStyle style:GridStyle_solid width:1 color:[UIColor red]];
cell.borders.right = [GridStyle style:GridStyle_solid width:1 color:[UIColor red]];
```

## Author

keshiim, keshiim@163.com

## License

ZMJGanttChart is available under the MIT license. See the LICENSE file for more info.
