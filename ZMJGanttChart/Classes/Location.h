//
//  Location.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject <NSCopying>
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;

- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column;
+ (instancetype)locationWithRow:(NSInteger)row column:(NSInteger)column;
+ (instancetype)indexPath:(NSIndexPath *)indexPath;

@end
