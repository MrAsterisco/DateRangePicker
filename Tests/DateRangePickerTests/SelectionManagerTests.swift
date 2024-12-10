//
//  SelectionManagerTests.swift
//
//
//  Created by Alessio Moiso on 17.04.23.
//

import Foundation
import XCTest
@testable import DateRangePicker
import OpenDateInterval

final class SelectionManagerTests: XCTestCase {
	func testAppendFirstDate_CreatesOpenEndedInterval() {
		// GIVEN
		let newDate = Date.date(from: "1993-11-11")
		let existingSelection: OpenDateInterval? = nil
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "en-US")
		
		let selectionManager = SelectionManager(calendar: calendar)
		
		// WHEN
		let result = selectionManager.append(newDate, to: existingSelection)
		
		// THEN
		XCTAssertEqual(result.start, newDate)
		XCTAssertTrue(result.isOpenEnded)
	}
	
	func testAppendSecondDateInTheFuture_ClosesInterval() {
		// GIVEN
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "en-US")
		let existingDate = Date.date(from: "1993-11-11")
		let newDate = Date.date(from: "1993-11-15")
		let expectedEndDate = calendar.dateInterval(of: .day, for: newDate)?.end.addingTimeInterval(-1)
		let existingSelection = OpenDateInterval(start: existingDate)
		
		let selectionManager = SelectionManager(calendar: calendar)
		
		// WHEN
		let result = selectionManager.append(newDate, to: existingSelection)
		
		// THEN
		XCTAssertEqual(existingDate, result.start)
		XCTAssertEqual(expectedEndDate, result.end)
		XCTAssertFalse(result.isOpenEnded)
	}
	
	func testAppendSecondDateInThePast_ReplacesStart() {
		// GIVEN
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "en-US")
		let existingDate = Date.date(from: "1993-11-11")
		let newDate = Date.date(from: "1993-11-10")
		let existingSelection = OpenDateInterval(start: existingDate)
		
		let selectionManager = SelectionManager(calendar: calendar)
		
		// WHEN
		let result = selectionManager.append(newDate, to: existingSelection)
		
		// THEN
		XCTAssertEqual(newDate, result.start)
		XCTAssertTrue(result.isOpenEnded)
	}
}
