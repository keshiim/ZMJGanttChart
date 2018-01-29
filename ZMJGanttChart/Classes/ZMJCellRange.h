//
//  ZMJCellRange.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface ZMJCellRange : NSObject

@property (nonatomic, strong, readonly) Location *from;
@property (nonatomic, strong, readonly) Location *to;

@property (nonatomic, assign, readonly) NSInteger columnCount;
@property (nonatomic, assign, readonly) NSInteger rowCount;

@property (nonatomic, assign) CGSize size;

+ (instancetype)cellRangeFrom:(Location *)from to:(Location *)to;

- (instancetype)initFromRow:(NSInteger)fromRow fromColumn:(NSInteger)fromColumn toRow:(NSInteger)toRow toColumn:(NSInteger)toColumn;
- (instancetype)initFromIndex:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (BOOL)containsIndexPath:(NSIndexPath *)indexPath;
- (BOOL)containsCellRange:(ZMJCellRange *)cellRange;
@end
