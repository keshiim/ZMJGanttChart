//
//  ZMJCell.m
//  Pods
//
//  Created by Jason on 2018/1/19.
//

#import "ZMJCell.h"

@interface ZMJCell () {
    Borders *_borders;
}

@property (nonatomic, strong) UIView *contentView;
@end

@implementation ZMJCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:self.contentView atIndex:0];
}

- (void)prepareForReuse {}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    [_backgroundView removeFromSuperview];
    if (backgroundView) {
        _backgroundView = backgroundView;
        backgroundView.frame = self.bounds;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:backgroundView atIndex:0];
    }
}

- (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView {
    [_selectedBackgroundView removeFromSuperview];
    if (selectedBackgroundView) {
        _selectedBackgroundView = selectedBackgroundView;
        selectedBackgroundView.frame = self.bounds;
        selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        selectedBackgroundView.alpha = 0.f;
        if (self.backgroundView) {
            [self insertSubview:selectedBackgroundView aboveSubview:self.backgroundView];
        } else {
            [self insertSubview:selectedBackgroundView atIndex:0];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    self.selectedBackgroundView.alpha = highlighted || self.isSelected ? 1 : 0;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.selectedBackgroundView.alpha =  selected ? 1 : 0;
}

- (Gridlines *)gridlines {
    if (!_gridlines) {
        _gridlines = [[Gridlines alloc] initWithTop:[[GridStyle alloc] initWithStyle:GridStyle_default width:0 color:nil]
                                             bottom:[[GridStyle alloc] initWithStyle:GridStyle_default width:0 color:nil]
                                               left:[[GridStyle alloc] initWithStyle:GridStyle_default width:0 color:nil]
                                              right:[[GridStyle alloc] initWithStyle:GridStyle_default width:0 color:nil]];
    }
    return _gridlines;
}

- (void)setGrids:(Gridlines *)grids {
    self.gridlines = grids;
}
- (Gridlines *)grids {
    return self.gridlines;
}

- (Borders *)borders {
    if (!_borders) {
        _borders = [[Borders alloc] initWithTop:[[BorderStyle alloc] initWithStyle:BorderStyle_None width:0 color:nil]
                                         bottom:[[BorderStyle alloc] initWithStyle:BorderStyle_None width:0 color:nil]
                                           left:[[BorderStyle alloc] initWithStyle:BorderStyle_None width:0 color:nil]
                                          right:[[BorderStyle alloc] initWithStyle:BorderStyle_None width:0 color:nil]];
    }
    return _borders;
}

- (void)setBorders:(Borders *)borders {
    _borders = borders;
    self.hasBorder = borders.top.border_enum != BorderStyle_None || borders.bottom.border_enum != BorderStyle_None || borders.left.border_enum != BorderStyle_None ||borders.right.border_enum != BorderStyle_None;
}

- (BOOL)hasBorder {
    _hasBorder =
    self.borders.top.border_enum    != BorderStyle_None ||
    self.borders.bottom.border_enum != BorderStyle_None ||
    self.borders.left.border_enum   != BorderStyle_None ||
    self.borders.right.border_enum  != BorderStyle_None;
    return _hasBorder;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:[CATransaction animationDuration] animations:^{
            self.selected = selected;
        }];
    } else {
        self.selected = selected;
    }
    
}

- (NSComparisonResult)compare:(ZMJCell *)aValue {
    return [self.indexPath compare:aValue.indexPath];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation BlankCell
@end
