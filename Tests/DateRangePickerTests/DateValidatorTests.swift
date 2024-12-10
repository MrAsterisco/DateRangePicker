//
//  DateValidatorTests.swift
//  
//
//  Created by Alessio Moiso on 17.04.23.
//

import Foundation
import XCTest
@testable import DateRangePicker

final class DateValidatorTests: XCTestCase {
	func testDateInMonthNoRange_IsValid() {
		// GIVEN
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "en-US")
		let date = Date.date(from: "1993-11-11")
		let month = Date.date(from: "1993-11-01")
		
		let dateValidator = DateValidator(
			calendar: calendar,
			minimumDate: nil,
			maximumDate: nil
		)
		
		// WHEN
		let result = dateValidator.validate(date: date, in: month)
		
		// THEN
		XCTAssertEqual(.available, result)
	}
	
	func testDateInMonthInRange_IsValid() {
		// GIVEN
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "en-US")
		let date = Date.date(from: "1993-11-11")
		let month = Date.date(from: "1993-11-01")
		let minDate = Date.date(from: "1993-11-07")
		let maxDate = Date.date(from: "1993-11-13")
		
		let dateValidator = DateValidator(
			calendar: calendar,
			minimumDate: minDate,
			maximumDate: maxDate
		)
		
		// WHEN
		let result = dateValidator.validate(date: date, in: month)
		
		// THEN
		XCTAssertEqual(.available, result)
	}
	
	func testDateOutsideMonthInRange_IsHidden() {
		// GIVEN
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "en-US")
		let date = Date.date(from: "1993-10-07")
		let month = Date.date(from: "1993-11-01")
		let minDate = Date.date(from: "1993-10-01")
		let maxDate = Date.date(from: "1993-11-13")
		
		let dateValidator = DateValidator(
			calendar: calendar,
			minimumDate: minDate,
			maximumDate: maxDate
		)
		
		// WHEN
		let result = dateValidator.validate(date: date, in: month)
		
		// THEN
		XCTAssertEqual(.hidden, result)
	}
	
	func testDateInMonthOutsideRangeUpperBound_IsUnavailable() {
		// GIVEN
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "en-US")
		let date = Date.date(from: "1993-11-14")
		let month = Date.date(from: "1993-11-01")
		let minDate = Date.date(from: "1993-11-07")
		let maxDate = Date.date(from: "1993-11-13")
		
		let dateValidator = DateValidator(
			calendar: calendar,
			minimumDate: minDate,
			maximumDate: maxDate
		)
		
		// WHEN
		let result = dateValidator.validate(date: date, in: month)
		
		// THEN
		XCTAssertEqual(.unavailable, result)
	}
}
