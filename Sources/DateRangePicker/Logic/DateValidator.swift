//
//  DateValidator.swift
//  
//
//  Created by Alessio Moiso on 17.04.23.
//

import Foundation

/// A class to validate the availability of a date in a given month.
final class DateValidator {
  private let calendar: Calendar
  private let minimumDate: Date?
  private let maximumDate: Date?
  
  /// Initializes a new `DateValidator` instance.
  /// 
  /// - Parameters:
  ///  - calendar: A calendar.
  ///  - minimumDate: The minimum date to consider. Ignored, if none is specified.
  ///  - maximumDate: The maximum date to consider. Ignored, if none is specified.
  init(calendar: Calendar, minimumDate: Date?, maximumDate: Date?) {
    self.calendar = calendar
    self.minimumDate = minimumDate
    self.maximumDate = maximumDate
  }
  
  /// Validate the availability of a date in a given month.
  /// 
  /// A date is valid when it is in the given month, it is not before the minimum date (if any),
  /// and it is not after the maximum date (if any).
  /// 
  /// - Parameters:
  ///  - date: The date to validate.
  ///  - month: The month to validate the date in.
  /// - Returns: The availability of the date in the given month.
  func validate(date: Date, in month: Date) -> DateValidity {
    if
      !calendar.isDate(date, equalTo: month, toGranularity: .month)
    {
      return .hidden
    }
    
    if
      let minimumDate, date < minimumDate
    {
      return .unavailable
    }
    
    if
      let maximumDate, date > maximumDate
    {
      return .unavailable
    }
    
    return .available
  }
}
