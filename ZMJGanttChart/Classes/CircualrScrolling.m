//
//  CircualrScrolling.m
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/22.
//

#import "CircualrScrolling.h"
@implementation CircualrScrolling
static Configuration                          *_cs_Configuration;
static id<CircularScrollingConfigurationState> _cs_None;
static id<CircularScrollingConfigurationState> _cs_Horizontally;
static id<CircularScrollingConfigurationState> _cs_Vertically;
static id<CircularScrollingConfigurationState> _cs_Both;
static ZMJDirection      _cs_Direction;
static ZMJHeaderStyle    _cs_HeaderStyle;
static ZMJTableStyle     _cs_TableStyle;

+ (Configuration *)Configuration {
    if (_cs_Configuration == nil) {
        _cs_Configuration = [Configuration new];
    }
    return _cs_Configuration;
}
+ (void)setConfiguration:(Configuration *)Configuration {
    if (Configuration != nil) {
        _cs_Configuration = Configuration;
    }
}
+ (id<CircularScrollingConfigurationState>)None {
    if (_cs_None == nil) {
        _cs_None = [CircularScrollingConfigurationState_None new];
    }
    return _cs_None;
}
+ (void)setNone:(id<CircularScrollingConfigurationState>)None {
    if (None != nil) {
        _cs_None = None;
    }
}
+ (id<CircularScrollingConfigurationState>)Horizontally {
    if (_cs_Horizontally == nil) {
        _cs_Horizontally = [CircularScrollingConfigurationState_Horizontally new];
    }
    return _cs_Horizontally;
}
+ (void)setHorizontally:(id<CircularScrollingConfigurationState>)Horizontally {
    if (Horizontally != nil) {
        _cs_Horizontally = Horizontally;
    }
}
+ (id<CircularScrollingConfigurationState>)Vertically {
    if (_cs_Vertically == nil) {
        _cs_Vertically = [CircularScrollingConfigurationState_Vertically new];
    }
    return _cs_Vertically;
}
+ (void)setVertically:(id<CircularScrollingConfigurationState>)Vertically {
    if (Vertically != nil) {
        _cs_Vertically = Vertically;
    }
}
+ (id<CircularScrollingConfigurationState>)Both {
    if (_cs_Both == nil) {
        _cs_Both = [CircularScrollingConfigurationState_Both new];
    }
    return _cs_Both;
}
+ (void)setBoth:(id<CircularScrollingConfigurationState>)Both {
    if (Both != nil) {
        _cs_Both = Both;
    }
}
+ (ZMJDirection)Direction {
    return _cs_Direction;
}
+ (void)setDirection:(ZMJDirection)Direction {
    _cs_Direction = Direction;
}
+ (ZMJTableStyle)TableStyle {
    return _cs_TableStyle;
}
+ (void)setTableStyle:(ZMJTableStyle)TableStyle {
    _cs_TableStyle = TableStyle;
}
+ (ZMJHeaderStyle)HeaderStyle {
    return _cs_HeaderStyle;
}
+ (void)setHeaderStyle:(ZMJHeaderStyle)HeaderStyle {
    _cs_HeaderStyle = HeaderStyle;
}
@end

#pragma mark - Configration
@implementation Configuration
static CircularScrollingConfigurationState_None         *_c_none;
static CircularScrollingConfigurationState_Horizontally *_c_horizontally;
static CircularScrollingConfigurationState_Vertically   *_c_vertically;
static CircularScrollingConfigurationState_Both         *_c_both;
static Options                                          *_c_options;
+ (CircularScrollingConfigurationState_None *)none {
    if (_c_none == nil) {
        _c_none = [CircularScrollingConfigurationState_None new];
    }
    return _c_none;
}
+ (void)setNone:(CircularScrollingConfigurationState_None *)none {
    if (none != nil) {
        _c_none = none;
    }
}
+ (CircularScrollingConfigurationState_Horizontally *)horizontally {
    if (_c_horizontally == nil) {
        _c_horizontally = [CircularScrollingConfigurationState_Horizontally new];
    }
    return _c_horizontally;
}
+ (void)setHorizontally:(CircularScrollingConfigurationState_Horizontally *)horizontally {
    if (horizontally != nil) {
        _c_horizontally = horizontally;
    }
}
+ (CircularScrollingConfigurationState_Vertically *)vertically {
    if (_c_vertically == nil) {
        _c_vertically = [CircularScrollingConfigurationState_Vertically new];
    }
    return _c_vertically;
}
+ (void)setVertically:(CircularScrollingConfigurationState_Vertically *)vertically {
    if (vertically != nil) {
        _c_vertically = vertically;
    }
}
+ (CircularScrollingConfigurationState_Both *)both {
    if (_c_both == nil) {
        _c_both = [CircularScrollingConfigurationState_Both new];
    }
    return _c_both;
}
+ (void)setBoth:(CircularScrollingConfigurationState_Both *)both {
    if (both != nil) {
        _c_both = both;
    }
}
+ (Options *)options {
    if (_c_options == nil) {
        _c_options = [Options new];
    }
    return _c_options;
}
+ (void)setOptions:(Options *)options {
    if (options != nil) {
        _c_options = options;
    }
}
@end

#pragma mark - CircularScrollingConfigurationState subclasses

@implementation CircularScrollingConfigurationBuilder
- (Options *)options {
    return nil;
}
@end

@implementation CircularScrollingConfigurationState_None
@end

@implementation CircularScrollingConfigurationState_Horizontally
static CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated    *_csch_ColumnHeaderNotRepeated;
static CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn *_csch_RowHeaderStartsFirstColumn;
+ (CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated *)ColumnHeaderNotRepeated {
    if (_csch_ColumnHeaderNotRepeated == nil) {
        _csch_ColumnHeaderNotRepeated = [CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated new];
    }
    return _csch_ColumnHeaderNotRepeated;
}
+ (void)setColumnHeaderNotRepeated:(CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated *)ColumnHeaderNotRepeated {
    if (ColumnHeaderNotRepeated != nil) {
        _csch_ColumnHeaderNotRepeated = ColumnHeaderNotRepeated;
    }
}
+ (CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn *)RowHeaderStartsFirstColumn {
    if (_csch_RowHeaderStartsFirstColumn == nil) {
        _csch_RowHeaderStartsFirstColumn = [CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn new];
    }
    return _csch_RowHeaderStartsFirstColumn;
}
+ (void)setRowHeaderStartsFirstColumn:(CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn *)RowHeaderStartsFirstColumn {
    if (RowHeaderStartsFirstColumn != nil) {
        _csch_RowHeaderStartsFirstColumn = RowHeaderStartsFirstColumn;
    }
}
@end

@implementation CircularScrollingConfigurationState_Vertically
static CircularScrollingConfigurationState_Both_RowHeaderNotRepeated       *_cscv_RowHeaderNotRepeated;
static CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow *_cscv_ColumnHeaderStartsFirstRow;
+ (CircularScrollingConfigurationState_Both_RowHeaderNotRepeated *)RowHeaderNotRepeated {
    if (_cscv_RowHeaderNotRepeated == nil) {
        _cscv_RowHeaderNotRepeated = [CircularScrollingConfigurationState_Both_RowHeaderNotRepeated new];
    }
    return _cscv_RowHeaderNotRepeated;
}
+ (void)setRowHeaderNotRepeated:(CircularScrollingConfigurationState_Both_RowHeaderNotRepeated *)RowHeaderNotRepeated {
    if (RowHeaderNotRepeated != nil) {
        _cscv_RowHeaderNotRepeated = RowHeaderNotRepeated;
    }
}
+ (CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow *)ColumnHeaderStartsFirstRow {
    if (_cscv_ColumnHeaderStartsFirstRow == nil) {
        _cscv_ColumnHeaderStartsFirstRow = [CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow new];
    }
    return _cscv_ColumnHeaderStartsFirstRow;
}
+ (void)setColumnHeaderStartsFirstRow:(CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow *)ColumnHeaderStartsFirstRow {
    if (ColumnHeaderStartsFirstRow != nil) {
        _cscv_ColumnHeaderStartsFirstRow = ColumnHeaderStartsFirstRow;
    }
}
@end

@implementation CircularScrollingConfigurationState_Both
static CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated *_cscb_ColumnHeaderNotRepeated;
static CircularScrollingConfigurationState_Both_RowHeaderNotRepeated    *_cscb_RowHeaderNotRepeated;
static CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn *_cscb_RowHeaderStartsFirstColumn;
static CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow *_cscb_ColumnHeaderStartsFirstRow;

+ (CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated *)ColumnHeaderNotRepeated {
    if (_cscb_ColumnHeaderNotRepeated == nil) {
        _cscb_ColumnHeaderNotRepeated = [CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated new];
    }
    return _cscb_ColumnHeaderNotRepeated;
}
+ (void)setColumnHeaderNotRepeated:(CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated *)ColumnHeaderNotRepeated {
    if (ColumnHeaderNotRepeated != nil) {
        _cscb_ColumnHeaderNotRepeated = ColumnHeaderNotRepeated;
    }
}
+ (CircularScrollingConfigurationState_Both_RowHeaderNotRepeated *)RowHeaderNotRepeated {
    if (_cscb_RowHeaderNotRepeated == nil) {
        _cscb_RowHeaderNotRepeated = [CircularScrollingConfigurationState_Both_RowHeaderNotRepeated new];
    }
    return _cscb_RowHeaderNotRepeated;
}
+ (void)setRowHeaderNotRepeated:(CircularScrollingConfigurationState_Both_RowHeaderNotRepeated *)RowHeaderNotRepeated {
    if (RowHeaderNotRepeated != nil) {
        _cscb_RowHeaderNotRepeated = RowHeaderNotRepeated;
    }
}
+ (CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn *)RowHeaderStartsFirstColumn {
    if (_cscb_RowHeaderStartsFirstColumn == nil) {
        _cscb_RowHeaderStartsFirstColumn = [CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn new];
    }
    return _cscb_RowHeaderStartsFirstColumn;
}
+ (void)setRowHeaderStartsFirstColumn:(CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn *)RowHeaderStartsFirstColumn {
    if (RowHeaderStartsFirstColumn != nil) {
        _cscb_RowHeaderStartsFirstColumn = RowHeaderStartsFirstColumn;
    }
}
+ (CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow *)ColumnHeaderStartsFirstRow {
    if (_cscb_ColumnHeaderStartsFirstRow == nil) {
        
    }
}
@end

@implementation CircularScrollingConfigurationState_Both_ColumnHeaderNotRepeated

@end

@implementation CircularScrollingConfigurationState_Both_RowHeaderNotRepeated

@end

@implementation CircularScrollingConfigurationState_Both_RowHeaderStartsFirstColumn

@end

@implementation CircularScrollingConfigurationState_Both_ColumnHeaderStartsFirstRow

@end

#pragma mark - Class

@implementation Options : NSObject

@end

