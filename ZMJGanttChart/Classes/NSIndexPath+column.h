//
//  NSIndexPath+column.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSIndexPath (column)
@property (nonatomic, assign) NSInteger column;

+ (instancetype)indexPathWithRow:(NSInteger)row column:(NSInteger)column;
@end
