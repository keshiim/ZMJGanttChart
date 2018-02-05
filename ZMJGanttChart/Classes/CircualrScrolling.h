//
//  CircualrScrolling.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/22.
//

#import <Foundation/Foundation.h>
#import "Define.h"
@protocol CircularScrollingConfiguration;

@class Configuration;
@class Options;
@class CircualrScrolling;
@class CircularScrollingConfigurationBuilder;

#pragma mark - Protocol

@protocol CircularScrollingConfiguration
- (Options *)options;
@end

typedef NS_OPTIONS(NSUInteger, CircularScrollingConfigurationState) {
    ZMJCircularScrolling_none         = 0,
    
    ZMJCircularScrolling_horizontally = 1 << 0,
    ZMJCircularScrolling_horizontally_rowHeaderStartsFirstColumn = 1 << 1,
    ZMJCircularScrolling_horizontally_columnHeaderNotRepeated    = 1 << 2,
    ZMJCircularScrolling_horizontally_columnHeaderNotRepeated_rowHeaderStartsFirstColumn = 1 << 3,
    
    ZMJCircularScrolling_vertically = 1 << 4,
    ZMJCircularScrolling_vertically_columnHeaderStartsFirstRow = 1 << 5,
    ZMJCircularScrolling_vertically_rowHeaderNotRepeated = 1 << 6,
    ZMJCircularScrolling_vertically_rowHeaderNotRepeated_columnHeaderStartsFirstRow = 1 << 7,
    
    ZMJCircularScrolling_both = 1 << 8,
    ZMJCircularScrolling_both_rowHeaderStartsFirstColumn = 1 << 9,
    ZMJCircularScrolling_both_columnHeaderStartsFirstRow = 1 << 10,
    ZMJCircularScrolling_both_rowHeaderStartsFirstColumn_rowHeaderNotRepeated = 1 << 11,
    ZMJCircularScrolling_both_columnHeaderStartsFirstRow_columnHeaderNotRepeated = 1 << 12,
    
    ZMJCircularScrolling_both_columnHeaderNotRepeated = 1 << 13,
    ZMJCircularScrolling_both_columnHeaderNotRepeated_rowHeaderStartsFirstColumn = 1 << 14,
    ZMJCircularScrolling_both_columnHeaderNotRepeated_columnHeaderStartsFirstRow = 1 << 15,
    ZMJCircularScrolling_both_columnHeaderNotRepeated_rowHeaderNotRepeated = 1 << 16,
    ZMJCircularScrolling_both_columnHeaderNotRepeated_rowHeaderNotRepeated_rowHeaderStartsFirstColumn = 1 << 17,
    ZMJCircularScrolling_both_columnHeaderNotRepeated_rowHeaderNotRepeated_columnHeaderStartsFirstRow = 1 << 18,
    
    ZMJCircularScrolling_both_rowHeaderNotRepeated = 1 << 19,
    ZMJCircularScrolling_both_rowHeaderNotRepeated_rowHeaderStartsFirstColumn = 1 << 20,
    ZMJCircularScrolling_both_rowHeaderNotRepeated_columnHeaderStartsFirstRow = 1 << 21,
    ZMJCircularScrolling_both_rowHeaderNotRepeated_columnHeaderNotRepeated = 1 << 22,
    ZMJCircularScrolling_both_rowHeaderNotRepeated_columnHeaderNotRepeated_rowHeaderStartsFirstColumn = 1 << 23,
    ZMJCircularScrolling_both_rowHeaderNotRepeated_columnHeaderNotRepeated_columnHeaderStartsFirstRow = 1 << 24,
};

#pragma mark - Class
@interface CircularScrollingConfigurationBuilder: NSObject <CircularScrollingConfiguration>
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCircularScrollingState:(CircularScrollingConfigurationState)state;
+ (instancetype)configurationBuilderWithCircularScrollingState:(CircularScrollingConfigurationState)state;

@property (nonatomic, assign) CircularScrollingConfigurationState state;
@end

@interface Configuration: NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)instance;

@property (nonatomic, strong) CircularScrollingConfigurationBuilder         *none;
@property (nonatomic, strong) CircularScrollingConfigurationBuilder *horizontally;
@property (nonatomic, strong) CircularScrollingConfigurationBuilder   *vertically;
@property (nonatomic, strong) CircularScrollingConfigurationBuilder         *both;
@end

@interface Options : NSObject
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDirection:(ZMJDirection)direction headerStyle:(ZMJHeaderStyle)headerStyle tableStyle:(ZMJTableStyle)tableStyle;
+ (instancetype)optionsWithDirection:(ZMJDirection)direction headerStyle:(ZMJHeaderStyle)headerStyle tableStyle:(ZMJTableStyle)tableStyle;

@property (nonatomic, assign) ZMJDirection   direction;
@property (nonatomic, assign) ZMJHeaderStyle headerStyle;
@property (nonatomic, assign) ZMJTableStyle  tableStyle;
@end

@interface CircualrScrolling : NSObject
@end

