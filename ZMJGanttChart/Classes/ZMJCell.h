//
//  ZMJCell.h
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import <UIKit/UIKit.h>
#import "Gridlines.h"
#import "Borders.h"

@interface ZMJCell : UIView

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *selectedBackgroundView;

@property (nonatomic, assign, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, assign, getter=isSelected)    BOOL selected;

@property (nonatomic, strong) Gridlines *gridlines;
@property (nonatomic, strong) Gridlines *grids;

@property (nonatomic, strong) Borders *borders;
@property (nonatomic, assign) BOOL hasBorder;

@property (nonatomic, copy  ) NSString *reuseIdentifier;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (NSComparisonResult)compare:(ZMJCell *)aValue;
- (void)preppareForReuse;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end

@interface BlankCell: ZMJCell
@end
