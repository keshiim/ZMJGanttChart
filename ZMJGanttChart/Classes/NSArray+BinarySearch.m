//
//  NSArray+BinarySearch.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/19.
//

#import "NSArray+BinarySearch.h"

@implementation NSArray (BinarySearch)

- (NSInteger)insertionIndexOfObject:(id)element {
    NSInteger lower = 0;
    NSInteger upper = self.count - 1;
    while (lower <= upper) {
        NSInteger middel = (lower + upper) / 2;
        if (self[middel] < element) {
            lower = middel + 1;
        } else if (element < self[middel]) {
            upper = middel - 1;
        } else {
            return middel;
        }
    }
    return lower;
}

@end
