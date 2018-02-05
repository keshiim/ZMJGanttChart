//
//  SpreadsheetViewDataSource.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZMJCell;
@class ZMJCellRange;
@class SpreadsheetView;

/// Implement this protocol to provide data to an `SpreadsheetView`.
@protocol SpreadsheetViewDataSource  <NSObject>
@required
/// Asks your data source object for the number of columns in the spreadsheet view.
///
/// - Parameter spreadsheetView: The spreadsheet view requesting this information.
/// - Returns: The number of columns in `spreadsheetView`.
- (NSInteger)numberOfColumns:(SpreadsheetView *)spreadsheetView;

/// Asks the number of rows in spreadsheet view.
///
/// - Parameter spreadsheetView: The spreadsheet view requesting this information.
/// - Returns: The number of rows in `spreadsheetView`.
- (NSInteger)numberOfRows:(SpreadsheetView *)spreadsheetView;

/// Asks the data source for the width to use for a row in a specified location.
///
/// - Parameters:
///   - spreadsheetView: The spreadsheet view requesting this information.
///   - column: The index of the column.
/// - Returns: A nonnegative floating-point value that specifies the width (in points) that column should be.
- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView widthForColumn:(NSInteger)column;

/// Asks the data source for the height to use for a row in a specified location.
///
/// - Parameters:
///   - spreadsheetView: The spreadsheet view requesting this information.
///   - row: The index of the row.
/// - Returns: A nonnegative floating-point value that specifies the height (in points) that row should be.
- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView heightForRow:(NSInteger)row;

/// Asks your data source object for the view that corresponds to the specified cell in the spreadsheetView.
/// The cell that is returned must be retrieved from a call to `dequeueReusableCell(withReuseIdentifier:for:)`
///
/// - Parameters:
///   - spreadsheetView: The spreadsheet view requesting this information.
///   - indexPath: The location of the cell
/// - Returns: A cell object to be displayed at the location.
///   If you return nil from this method, the blank cell will be displayed by default.
- (ZMJCell *)spreadsheetView:(SpreadsheetView *)spreadsheetView cellForItemAt:(NSIndexPath *)indexPath;

@optional
/// Asks your data source object for the array of cell ranges that indicate the range of merged cells in the spreadsheetView.
///
/// - Parameter spreadsheetView: The spreadsheet view requesting this information.
/// - Returns: An array of the cell ranges indicating the range of merged cells.
- (NSArray<ZMJCellRange *> *)mergedCells:(SpreadsheetView *)spreadsheetView;

/// Asks your data source object for the number of columns to be frozen as a fixed column header in the spreadsheetView.
///
/// - Parameter spreadsheetView: The spreadsheet view requesting this information.
/// - Returns: The number of columns to be frozen
- (NSInteger)frozenColumns:(SpreadsheetView *)spreadsheetView;

/// Asks your data source object for the number of rows to be frozen as a fixed row header in the spreadsheetView.
///
/// - Parameter spreadsheetView: The spreadsheet view requesting this information.
/// - Returns: The number of rows to be frozen
- (NSInteger)frozenRows:(SpreadsheetView *)spreadsheetView;
@end
