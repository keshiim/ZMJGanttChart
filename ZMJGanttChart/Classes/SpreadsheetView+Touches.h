//
//  SpreadsheetView+Touches.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import "SpreadsheetView.h"

@interface SpreadsheetView (Touches)
- (void)touchesBegan:(NSSet<UITouch *> *)touches event:(UIEvent *)event;
- (void)touchesEnded:(NSSet<UITouch *> *)touches event:(UIEvent *)event;
- (void)touchesCancelled:(NSSet<UITouch *> *)touches event:(UIEvent *)event;

- (void)restorePreviousSelection;
- (void)clearCurrentTouch;


@end
