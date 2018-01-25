//
//  NSIndexPath+column.m
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import "NSIndexPath+column.h"

@implementation NSIndexPath (column)
@dynamic column;

- (NSInteger)column {
    return self.section;
}

+ (instancetype)indexPathWithRow:(NSInteger)row column:(NSInteger)column
{
    return [NSIndexPath indexPathForRow:row inSection:column];
}

@end
