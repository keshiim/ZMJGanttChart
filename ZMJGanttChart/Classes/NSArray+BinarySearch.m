//
//  NSArray+BinarySearch.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/19.
//

#import "NSArray+BinarySearch.h"

@implementation NSArray (BinarySearch)

- (NSInteger)insertionIndexOfObject:(id)element {
    if (![element respondsToSelector:@selector(compare:)]) {
        [NSException exceptionWithName:@"Warning....." reason:@"The element should be support SEL:[compare:]" userInfo:nil];
    }
    NSInteger lower = 0;
    NSInteger upper = self.count - 1;
    while (lower <= upper) {
        NSInteger middel = (lower + upper) / 2;
        NSComparisonResult result = [self[middel] compare:element];
        if (result == NSOrderedAscending) {
            lower = middel + 1;
        } else if (result == NSOrderedDescending) {
            upper = middel - 1;
        } else {
            return middel;
        }
    }
    return lower;
}

@end
