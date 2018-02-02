//
//  ViewController.m
//  ZMJClassData
//
//  Created by Jason on 2018/2/2.
//  Copyright © 2018年 keshiim. All rights reserved.
//

#import "ViewController.h"
#import <ZMJGanttChart/ZMJGanttChart.h>

typedef NS_ENUM(NSInteger, ZMJSorting) {
    ascending = 0,
    descending
};

static inline NSString * getSymbol(ZMJSorting sorting) {
    switch (sorting) {
        case ascending:
            return @"\u{25B2}";
            break;
        case descending:
            return @"\u{25BC}";
            break;
        default:
            break;
    }
}

@interface ViewController () <SpreadsheetViewDelegate, SpreadsheetViewDataSource>
@property (nonatomic, strong) SpreadsheetView *spreadsheetView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)viewWillLayoutSubviews {
    if (@available(iOS 11.0, *)) {
        self.spreadsheetView.frame = self.view.safeAreaLayoutGuide.layoutFrame;
    } else {
        // Fallback on earlier versions
        self.spreadsheetView.frame = self.view.bounds;
    }
}


@end
