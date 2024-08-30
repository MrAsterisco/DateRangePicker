//
//  SelectionManager.swift
//  
//
//  Created by Alessio Moiso on 17.04.23.
//

import Foundation
import OpenDateInterval

/// Manage an open-ended date interval by appending or replacing dates in it.
final class SelectionManager {
  private let calendar: Calendar
  
  /// Initialize a new `SelectionManager` instance.
  /// 
  /// - Parameter calendar: A calendar.
  init(calendar: Calendar) {
    self.calendar = calendar
  }
  
  /// Append or replace the given date in the given open-ended date interval.
  /// 
  /// This function will create a new open-ended interval, if none is selected; otherwise,
  /// it will attempt to use the given date to close the interval. If the passed date
  /// is before the start of the interval, the interval will be replaced with a new one
  /// that starts on the given date.
  /// 
  /// - Parameters:
  ///  - date: The date to append or replace.
  ///  - selection: The selection to append or replace the date in.
  /// - Returns: The new selection.
  func append(_ date: Date, to selection: OpenDateInterval?) -> OpenDateInterval {
    guard
      let selection
    else {
      return .init(start: date)
    }
    
    if selection.isOpenEnded {
      if date < selection.start {
        return .init(start: date)
      }
      
      return OpenDateInterval(
        start: selection.start,
        end: calendar
          .dateInterval(of: .day, for: date)?.end.addingTimeInterval(-1) ?? date
      )
    } else {
      return append(date, to: nil)
    }
  }
}
