//
//  CircualrScrolling.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/22.
//

#import "CircualrScrolling.h"

@implementation CircualrScrolling
@end

#pragma mark - Configration
@implementation Configuration
+ (instancetype)instance {
    static Configuration *configuration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configuration = [Configuration new];
    });
    return configuration;
}

- (CircularScrollingConfigurationBuilder *)none {
    if (!_none) {
        _none = [CircularScrollingConfigurationBuilder configurationBuilderWithCircularScrollingState:ZMJCircularScrolling_none];
    }
    return _none;
}

- (CircularScrollingConfigurationBuilder *)horizontally {
    if (!_horizontally) {
        _horizontally = [CircularScrollingConfigurationBuilder configurationBuilderWithCircularScrollingState:ZMJCircularScrolling_horizontally];
    }
    return _horizontally;
}

- (CircularScrollingConfigurationBuilder *)vertically {
    if (!_vertically) {
        _vertically = [CircularScrollingConfigurationBuilder configurationBuilderWithCircularScrollingState:ZMJCircularScrolling_vertically];
    }
    return _vertically;
}

- (CircularScrollingConfigurationBuilder *)both {
    if (!_both) {
        _both = [CircularScrollingConfigurationBuilder configurationBuilderWithCircularScrollingState:ZMJCircularScrolling_both];
    }
    return _both;
}
@end

#pragma mark - CircularScrollingConfigurationBuilder
@implementation CircularScrollingConfigurationBuilder

+ (instancetype)configurationBuilderWithCircularScrollingState:(CircularScrollingConfigurationState)state {
    return [[self alloc] initWithCircularScrollingState:state];
}

- (instancetype)initWithCircularScrollingState:(CircularScrollingConfigurationState)state {
    self = [super init];
    if (self) {
        _state = state;
    }
    return self;
}

- (Options *)options {
    Options *result = nil;
    switch (self.state) {
        case ZMJCircularScrolling_none:
            result = [Options optionsWithDirection:0 headerStyle:HeaderStyle_none tableStyle:0];
            break;
        case ZMJCircularScrolling_horizontally:
            result = [Options optionsWithDirection:Direction_horizontally headerStyle:HeaderStyle_none tableStyle:0];
            break;
        case ZMJCircularScrolling_horizontally_rowHeaderStartsFirstColumn:
            result = [Options optionsWithDirection:Direction_horizontally headerStyle:HeaderStyle_rowHeaderStartsFirstColumn tableStyle:TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_horizontally_columnHeaderNotRepeated:
            result = [Options optionsWithDirection:Direction_horizontally headerStyle:HeaderStyle_none tableStyle:TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_horizontally_columnHeaderNotRepeated_rowHeaderStartsFirstColumn:
            result = [Options optionsWithDirection:Direction_horizontally headerStyle:HeaderStyle_rowHeaderStartsFirstColumn tableStyle:TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_vertically:
            result = [Options optionsWithDirection:Direction_vertically headerStyle:HeaderStyle_none tableStyle:0];
            break;
        case ZMJCircularScrolling_vertically_columnHeaderStartsFirstRow:
            result = [Options optionsWithDirection:Direction_vertically headerStyle:HeaderStyle_columnHeaderStartsFirstRow tableStyle:TableStyle_rowHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_vertically_rowHeaderNotRepeated:
            result = [Options optionsWithDirection:Direction_vertically headerStyle:HeaderStyle_none tableStyle:TableStyle_rowHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_vertically_rowHeaderNotRepeated_columnHeaderStartsFirstRow:
            result = [Options optionsWithDirection:Direction_vertically headerStyle:HeaderStyle_columnHeaderStartsFirstRow tableStyle:TableStyle_rowHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_none tableStyle:0];
            break;
        case ZMJCircularScrolling_both_rowHeaderStartsFirstColumn:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_rowHeaderStartsFirstColumn tableStyle:TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_columnHeaderStartsFirstRow:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_columnHeaderStartsFirstRow tableStyle:TableStyle_rowHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_rowHeaderStartsFirstColumn_rowHeaderNotRepeated:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_rowHeaderStartsFirstColumn tableStyle:TableStyle_rowHeaderNotRepeated | TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_columnHeaderStartsFirstRow_columnHeaderNotRepeated:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_columnHeaderStartsFirstRow tableStyle:TableStyle_rowHeaderNotRepeated | TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_columnHeaderNotRepeated:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_none tableStyle:TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_columnHeaderNotRepeated_rowHeaderStartsFirstColumn:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_rowHeaderStartsFirstColumn tableStyle:TableStyle_rowHeaderNotRepeated | TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_columnHeaderNotRepeated_columnHeaderStartsFirstRow:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_columnHeaderStartsFirstRow tableStyle:TableStyle_rowHeaderNotRepeated | TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_columnHeaderNotRepeated_rowHeaderNotRepeated:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_none tableStyle:TableStyle_rowHeaderNotRepeated | TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_columnHeaderNotRepeated_rowHeaderNotRepeated_rowHeaderStartsFirstColumn:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_rowHeaderStartsFirstColumn tableStyle:TableStyle_rowHeaderNotRepeated | TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_columnHeaderNotRepeated_rowHeaderNotRepeated_columnHeaderStartsFirstRow:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_columnHeaderStartsFirstRow tableStyle:TableStyle_rowHeaderNotRepeated | TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_rowHeaderNotRepeated:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_none tableStyle:TableStyle_rowHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_rowHeaderNotRepeated_rowHeaderStartsFirstColumn:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_rowHeaderStartsFirstColumn tableStyle:TableStyle_rowHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_rowHeaderNotRepeated_columnHeaderStartsFirstRow:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_columnHeaderStartsFirstRow tableStyle:TableStyle_rowHeaderNotRepeated | TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_rowHeaderNotRepeated_columnHeaderNotRepeated:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_none tableStyle:TableStyle_rowHeaderNotRepeated | TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_rowHeaderNotRepeated_columnHeaderNotRepeated_rowHeaderStartsFirstColumn:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_rowHeaderStartsFirstColumn tableStyle:TableStyle_rowHeaderNotRepeated | TableStyle_columnHeaderNotRepeated];
            break;
        case ZMJCircularScrolling_both_rowHeaderNotRepeated_columnHeaderNotRepeated_columnHeaderStartsFirstRow:
            result = [Options optionsWithDirection:Direction_both headerStyle:HeaderStyle_columnHeaderStartsFirstRow tableStyle:TableStyle_rowHeaderNotRepeated | TableStyle_columnHeaderNotRepeated];
            break;
        default:
            result = [Options optionsWithDirection:0 headerStyle:HeaderStyle_none tableStyle:0];
            break;
    }
    return result;
}
@end


#pragma mark - Class
@implementation Options : NSObject
+ (instancetype)optionsWithDirection:(ZMJDirection)direction headerStyle:(ZMJHeaderStyle)headerStyle tableStyle:(ZMJTableStyle)tableStyle {
    return [[self alloc] initWithDirection:direction headerStyle:headerStyle tableStyle:tableStyle];
}

- (instancetype)initWithDirection:(ZMJDirection)direction headerStyle:(ZMJHeaderStyle)headerStyle tableStyle:(ZMJTableStyle)tableStyle {
    self = [super init];
    if (self) {
        _direction = direction;
        _headerStyle = headerStyle;
        _tableStyle = tableStyle;
    }
    return self;
}
@end


