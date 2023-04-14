//
//  DatesGenerator.swift
//  
//
//  Created by Alessio Moiso on 14.04.23.
//

import Foundation

public final class DatesGenerator {
  private let calendar: Calendar
  
  public init(calendar: Calendar) {
    self.calendar = calendar
  }
  
  func years() -> [Date] {
    let firstYear = DateComponents(year: 1800)
    guard
      let firstYearDate = calendar.date(from: firstYear),
      let lastYearDate = calendar.date(byAdding: .init(year: 100), to: Date())
    else { return [] }
    
    return calendar.dates(
      in: .init(start: firstYearDate, end: lastYearDate),
      byMatching: .init(month: 1)
    )
  }
  
  func months(in year: Int) -> [Date] {
    let dateComponents = DateComponents(year: year)
    guard
      let date = calendar.date(from: dateComponents),
      let yearInterval = calendar.dateInterval(of: .year, for: date)
    else { return [] }
    
    return calendar.dates(
      in: yearInterval,
      byMatching: DateComponents(day: 1)
    )
  }
  
  func dateIntervalEnforcingFullWeeks(month: Int, year: Int) -> DateInterval? {
    let dateComponents = DateComponents(year: year, month: month)
    guard
      let date = calendar.date(from: dateComponents),
      let monthInterval = calendar.dateInterval(of: .month, for: date),
      let firstWeekInterval = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
      let lastWeekInterval = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end)
    else { return nil }
    
    return DateInterval(
      start: min(monthInterval.start, firstWeekInterval.start),
      end: max(monthInterval.end, lastWeekInterval.end)
    )
  }
  
  public func dates(in month: Int, of year: Int) -> [Date] {
    guard
      let interval = dateIntervalEnforcingFullWeeks(month: month, year: year)
    else { return [] }
    
    return calendar.dates(
      in: interval,
      byMatching: DateComponents(hour: 0)
    )
  }
}

private extension Calendar {
  func dates(in interval: DateInterval, byMatching dateComponents: DateComponents) -> [Date] {
    var dates: [Date] = []
    
    dates.append(interval.start)
    
    enumerateDates(startingAfter: interval.start, matching: dateComponents, matchingPolicy: .nextTime) { date, _, stop in
      if let date = date {
        if date < interval.end {
          dates.append(date)
        } else {
          stop = true
        }
      }
    }
    return dates
  }
}
