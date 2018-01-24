//
//  Define.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/23.
//

#ifndef Define_h
#define Define_h

typedef void(^TouchHandler)(NSSet<UITouch *> *touches, UIEvent *event);

typedef struct ZMJState {
    CGRect  frame;
    CGSize  contentSize;
    CGPoint contentOffset;
} State;

typedef NS_OPTIONS(NSUInteger, ZMJScrollPosition) {
    // The vertical positions are mutually exclusive to each other, but are bitwise or-able with the horizontal scroll positions.
    // Combining positions from the same grouping (horizontal or vertical) will result in an NSInvalidArgumentException.
    ScrollPosition_top                 = 1 << 0,
    ScrollPosition_centeredVertiically = 1 << 1,
    ScrollPosition_bottom              = 1 << 2,
    
    // Likewise, the horizontal positions are mutually exclusive to each other.
    ScrollPosition_left                = 1 << 3,
    ScrollPosition_centeredHorizontally= 1 << 4,
    ScrollPosition_right               = 1 << 5,
};


typedef NS_ENUM(NSInteger, GridStyle_Enum) {
    GridStyle_default = 0,
    GridStyle_none,
    GridStyle_solid,
};

typedef NS_ENUM(NSInteger, BorderStyle_Enum) {
    BorderStyle_None,
    BorderStyle_solid,
};

#pragma mark - Defines
typedef struct ZMJDirect {
    CGFloat left;
    CGFloat right;
    CGFloat top;
    CGFloat bottom;
} Direct;

typedef struct ZMJRectEdge {
    //top || bottom
    Direct top;
    Direct bottom;
    
    //left || right
    Direct left;
    Direct right;
} RectEdge;

typedef struct ZMJLayoutAttributes {
    NSInteger startColumn;
    NSInteger startRow;
    NSInteger numberOfColumns;
    NSInteger numberOfRows;
    NSInteger columnCount;
    NSInteger rowCount;
    CGPoint insets;
} LayoutAttributes;

typedef struct ZMJGridLayout {
    CGFloat gridWidth;
    __unsafe_unretained UIColor* gridColor;
    CGPoint origin;
    CGFloat length;
    RectEdge edge;
    CGFloat priority;
} GridLayout;


typedef NS_OPTIONS(NSUInteger, ZMJDirection) {
    Direction_vertically   = 1 << 0,
    Direction_horizontally = 1 << 1,
    Direction_both         = Direction_vertically | Direction_horizontally,
};

typedef NS_OPTIONS(NSUInteger, ZMJTableStyle) {
    TableStyle_columnHeaderNotRepeated  = 1 << 0,
    TableStyle_rowHeaderNotRepeated     = 1 << 1,
};

typedef NS_ENUM(NSUInteger, ZMJHeaderStyle) {
    HeaderStyle_none,
    HeaderStyle_columnHeaderStartsFirstRow,
    HeaderStyle_rowHeaderStartsFirstColumn,
};


#endif /* Define_h */
