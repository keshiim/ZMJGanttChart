//
//  SpreadsheetViewDelegate.h
//  ZMJGanttChart
//
//  Created by Jason on 2018/1/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SpreadsheetView;

/// The `SpreadsheetViewDelegate` protocol defines methods that allow you to manage the selection and
/// highlighting of cells in a spreadsheet view and to perform actions on those cells.
/// The methods of this protocol are all optional.
@protocol SpreadsheetViewDelegate <NSObject>
@optional
/// Asks the delegate if the cell should be highlighted during tracking.
/// - Note: As touch events arrive, the spreadsheet view highlights cells in anticipation of the user selecting them.
///   As it processes those touch events, the collection view calls this method to ask your delegate if a given cell should be highlighted.
///   It calls this method only in response to user interactions and does not call it if you programmatically set the highlighting on a cell.
///
///   If you do not implement this method, the default return value is `true`.
///
/// - Parameters:
///   - spreadsheetView: The spreadsheet view object that is asking about the highlight change.
///   - indexPath: The index path of the cell to be highlighted.
/// - Returns: `true` if the item should be highlighted or `false` if it should not.
- (BOOL)spreadsheetView:(SpreadsheetView *)spreadsheetView shouldHighlightItemAt:(NSIndexPath *)indexPath;

/// Tells the delegate that the cell at the specified index path was highlighted.
/// - Note: The spreadsheet view calls this method only in response to user interactions and does not call it
///   if you programmatically set the highlighting on a cell.
///
/// - Parameters:
///   - spreadsheetView: The spreadsheet view object that is notifying you of the highlight change.
///   - indexPath: The index path of the cell that was highlighted.
- (void)spreadsheetView:(SpreadsheetView *)spreadsheetView didHighlightItemAt:(NSIndexPath *)indexPath;

/// Tells the delegate that the highlight was removed from the cell at the specified index path.
/// - Note: The spreadsheet view calls this method only in response to user interactions and does not call it
///   if you programmatically change the highlighting on a cell.
///
/// - Parameters:
///   - spreadsheetView: The spreadsheet view object that is notifying you of the highlight change.
///   - indexPath: The index path of the cell that had its highlight removed.
- (void)spreadsheetView:(SpreadsheetView *)spreadsheetView didUnhighlightItemAt:(NSIndexPath *)indexPath;

/// Asks the delegate if the specified cell should be selected.
/// - Note: The spreadsheet view calls this method when the user tries to select an item in the collection view.
///   It does not call this method when you programmatically set the selection.
///
///   If you do not implement this method, the default return value is `true`.
///
/// - Parameters:
///   - spreadsheetView: The spreadsheet view object that is asking whether the selection should change.
///   - indexPath: The index path of the cell to be selected.
/// - Returns: `true` if the item should be selected or `false` if it should not.
- (BOOL)spreadsheetView:(SpreadsheetView *)spreadsheetView shouldSelectItemAt:(NSIndexPath *)indexPath;

/// Asks the delegate if the specified item should be deselected.
/// - Note: The spreadsheet view calls this method when the user tries to deselect a cell in the spreadsheet view.
///   It does not call this method when you programmatically deselect items.
///
///   If you do not implement this method, the default return value is `true`.
///
///   This method is called when the user taps on an already-selected item in multi-select mode
///
/// - Parameters:
///   - spreadsheetView: The spreadsheet view object that is asking whether the selection should change.
///   - indexPath: The index path of the cell to be deselected.
/// - Returns: `true` if the cell should be deselected or `false` if it should not.
- (BOOL)spreadsheetView:(SpreadsheetView *)spreadsheetView shouldDeselectItemAt:(NSIndexPath *)indexPath;

/// Tells the delegate that the cell at the specified index path was selected.
/// - Note: The spreadsheet view calls this method when the user successfully selects a cell in the spreadsheet view.
///   It does not call this method when you programmatically set the selection.
///
/// - Parameters:
///   - spreadsheetView: The spreadsheet view object that is notifying you of the selection change.
///   - indexPath: The index path of the cell that was selected.
- (void)spreadsheetView:(SpreadsheetView *)spreadsheetView didSelectItemAt:(NSIndexPath *)indexPath;

/// Tells the delegate that the cell at the specified path was deselected.
/// - Note: The spreadsheet view calls this method when the user successfully deselects an item in the spreadsheet view.
///   It does not call this method when you programmatically deselect items.
///
/// - Parameters:
///   - spreadsheetView: The spreadsheet view object that is notifying you of the selection change.
///   - indexPath: The index path of the cell that was deselected.
- (void)spreadsheetView:(SpreadsheetView *)spreadsheetView didDeselectItemAt:(NSIndexPath *)indexPath;
@end
