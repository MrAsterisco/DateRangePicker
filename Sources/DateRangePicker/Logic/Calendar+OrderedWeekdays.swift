//
//  Calendar+OrderedWeekdays.swift
//  
//
//  Created by Alessio Moiso on 17.04.23.
//

import Foundation

extension Calendar {
  /// Get short weekdays symbols ordered based on the calendar's locale.
  ///
  /// - note: By default, calendars (except for `current`) don't have a locale set. Make sure to set
  /// the `locale` before invoking this method, or you'll get the result for `en-US`.
  var orderedShortWeekdaySymbols: [String] {
    (Array(firstWeekday...7) + Array(1..<firstWeekday))
      .map {
        shortWeekdaySymbols[$0-1]
      }
  }
}
