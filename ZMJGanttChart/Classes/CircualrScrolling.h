//
//  CircualrScrolling.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/22.
//

#import <Foundation/Foundation.h>

@protocol CircularScrollingConfigurationState;
@protocol CircularScrollingConfiguration;

@class CircularScrollingConfigurationState_None;
@class CircularScrollingConfigurationState_Horizontally;
@class CircularScrollingConfigurationState_Vertically;
@class CircularScrollingConfigurationState_Both;
@class CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated;
@class CircularScrollingConfigurationState_Both_RowHeaderNotRepeated;
@class CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn;
@class CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow;

@class Configuration;
@class Options;
@class CircualrScrolling;
@class CircularScrollingConfigurationBuilder;

typedef NS_OPTIONS(NSUInteger, ZMJDirection) {
    Direction_vertically   = 1 << 0,
    Direction_horizontally = 1 << 1,
    Direction_both         = Direction_vertically | Direction_horizontally,
} Direction;

typedef NS_OPTIONS(NSUInteger, ZMJTableStyle) {
    TableStyle_columnHeaderNotRepeated  = 1 << 0,
    TableStyle_rowHeaderNotRepeated     = 1 << 1,
};

typedef NS_ENUM(NSUInteger, ZMJHeaderStyle) {
    HeaderStyle_none,
    HeaderStyle_columnHeaderStartsFirstRow,
    HeaderStyle_rowHeaderStartsFirstColumn,
} HeaderStyle;

#pragma mark - Protocol
@protocol CircularScrollingConfigurationState
@end

@protocol CircularScrollingConfiguration
- (Options *)options;
@end


#pragma mark - CircularScrollingConfigurationState subclasses
@interface CircularScrollingConfigurationBuilder : NSObject <CircularScrollingConfigurationState, CircularScrollingConfiguration>

@end

@interface CircularScrollingConfigurationState_None : CircularScrollingConfigurationBuilder
@end

@interface CircularScrollingConfigurationState_Horizontally : CircularScrollingConfigurationBuilder
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated *ColumnHeaderNotRepeated;
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn *RowHeaderStartsFirstColumn;
@end

@interface CircularScrollingConfigurationState_Vertically : CircularScrollingConfigurationBuilder
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_RowHeaderNotRepeated    *RowHeaderNotRepeated;
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow *ColumnHeaderStartsFirstRow;
@end

@interface CircularScrollingConfigurationState_Both : CircularScrollingConfigurationBuilder
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated *ColumnHeaderNotRepeated;
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_RowHeaderNotRepeated    *RowHeaderNotRepeated;
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn *RowHeaderStartsFirstColumn;
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow *ColumnHeaderStartsFirstRow;
@end

@interface CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated : CircularScrollingConfigurationBuilder
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn *RowHeaderStartsFirstColumn;
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow *ColumnHeaderStartsFirstRow;
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_RowHeaderNotRepeated       *RowHeaderNotRepeated;
@end

@interface CircularScrollingConfigurationState_Both_RowHeaderNotRepeated : CircularScrollingConfigurationBuilder
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn *RowHeaderStartsFirstColumn;
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow *ColumnHeaderStartsFirstRow;
@end

@interface CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn : CircularScrollingConfigurationBuilder
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_RowHeaderNotRepeated    *RowHeaderNotRepeated;
@end

@interface CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow : CircularScrollingConfigurationBuilder
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated *ColumnHeaderNotRepeated;
@end

#pragma mark - Class
@interface Configuration: NSObject
@property (class, nonatomic, strong) CircularScrollingConfigurationState_None         *none;
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Horizontally *horizontally;
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Vertically   *vertically;
@property (class, nonatomic, strong) CircularScrollingConfigurationState_Both         *both;

@property (class, nonatomic, strong) Options *options;
@end

@interface Options : NSObject
@property (nonatomic, assign) ZMJDirection   direction;
@property (nonatomic, assign) ZMJHeaderStyle headerStyle;
@property (nonatomic, assign) ZMJTableStyle  tableStyle;
@end

@interface CircualrScrolling : NSObject

@property (class, nonatomic, strong) Configuration *Configuration;
@property (class, nonatomic, strong) id<CircularScrollingConfigurationState>    None;
@property (class, nonatomic, strong) id<CircularScrollingConfigurationState>    Horizontally;
@property (class, nonatomic, strong) id<CircularScrollingConfigurationState>    Vertically;
@property (class, nonatomic, strong) id<CircularScrollingConfigurationState>    Both;

@property (class, nonatomic, assign) ZMJDirection      Direction;
@property (class, nonatomic, assign) ZMJHeaderStyle    HeaderStyle;
@property (class, nonatomic, assign) ZMJTableStyle     TableStyle;
@end

