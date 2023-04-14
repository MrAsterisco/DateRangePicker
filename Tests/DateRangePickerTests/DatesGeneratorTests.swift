//
//  File.swift
//  
//
//  Created by Alessio Moiso on 14.04.23.
//

import Foundation
import XCTest
@testable import DateRangePicker

final class DatesGeneratorTests: XCTestCase {
  func testGenerate_November1993() {
    // GIVEN
    let month = 11
    let year = 1993
    let novemberDates = [
      Date.date(from: "\(year)-\(month-1)-31"),
      Date.date(from: "\(year)-\(month)-01"),
      Date.date(from: "\(year)-\(month)-02"),
      Date.date(from: "\(year)-\(month)-03"),
      Date.date(from: "\(year)-\(month)-04"),
      Date.date(from: "\(year)-\(month)-05"),
      Date.date(from: "\(year)-\(month)-06"),
      Date.date(from: "\(year)-\(month)-07"),
      Date.date(from: "\(year)-\(month)-08"),
      Date.date(from: "\(year)-\(month)-09"),
      Date.date(from: "\(year)-\(month)-10"),
      Date.date(from: "\(year)-\(month)-11"),
      Date.date(from: "\(year)-\(month)-12"),
      Date.date(from: "\(year)-\(month)-13"),
      Date.date(from: "\(year)-\(month)-14"),
      Date.date(from: "\(year)-\(month)-15"),
      Date.date(from: "\(year)-\(month)-16"),
      Date.date(from: "\(year)-\(month)-17"),
      Date.date(from: "\(year)-\(month)-18"),
      Date.date(from: "\(year)-\(month)-19"),
      Date.date(from: "\(year)-\(month)-20"),
      Date.date(from: "\(year)-\(month)-21"),
      Date.date(from: "\(year)-\(month)-22"),
      Date.date(from: "\(year)-\(month)-23"),
      Date.date(from: "\(year)-\(month)-24"),
      Date.date(from: "\(year)-\(month)-25"),
      Date.date(from: "\(year)-\(month)-26"),
      Date.date(from: "\(year)-\(month)-27"),
      Date.date(from: "\(year)-\(month)-28"),
      Date.date(from: "\(year)-\(month)-29"),
      Date.date(from: "\(year)-\(month)-30"),
      Date.date(from: "\(year)-\(month+1)-01"),
      Date.date(from: "\(year)-\(month+1)-02"),
      Date.date(from: "\(year)-\(month+1)-03"),
      Date.date(from: "\(year)-\(month+1)-04"),
    ]
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en-US")
    
    let datesGenerator = DatesGenerator(calendar: calendar)
    
    // WHEN
    let dates = datesGenerator.dates(in: month, of: year)
    
    // THEN
    XCTAssertEqual(novemberDates, dates)
  }
  
  func testGenerate_1993() {
    // GIVEN
    let year = 1993
    let yearDates = (1...12)
      .map { Date.date(from: "\(year)-\($0)-01") }
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en-US")
    
    let datesGenerator = DatesGenerator(calendar: calendar)
    
    // WHEN
    let dates = datesGenerator.months(in: year)
    
    // THEN
    XCTAssertEqual(yearDates, dates)
  }
}

private extension Date {
  static func date(from dateString: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: dateString)!
  }
}
