//
//  Address.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject <NSCopying>
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger columnIndex;

- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex;
+ (instancetype)addressWithRow:(NSInteger)row column:(NSInteger)column rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex;
@end
