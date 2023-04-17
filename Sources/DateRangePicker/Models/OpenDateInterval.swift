//
//  File.swift
//  
//
//  Created by Alessio Moiso on 17.04.23.
//

import Foundation

/// An open-ended date interval.
/// 
/// This struct represents an open-ended date interval. It can be used to represent a date range that
/// has a start date, but no end date, or a date range that has both a start and end date.
/// 
/// # DateInterval interoperability
/// This struct shares a few methods with `DateInterval`, although it does not offer the same
/// set of features, mainly because an open-ended interval may not have a duration.
/// 
/// # Open-ended Intervals
/// An interval without an end date is considered an open-ended interval. You can check if
/// an interval is open-ended by invoking `isOpenEnded`.
public struct OpenDateInterval {
  public let start: Date
  public let end: Date?
  
  /// Initialize a new `OpenDateInterval` instance.
  ///
  /// - Parameters:
  ///   - start: The start date of the interval.
  ///   - end: The end date of the interval (if any).
  public init(start: Date, end: Date? = nil) {
    self.start = start
    self.end = end
  }
  
  /// Check whether the given date is contained in the interval.
  /// 
  /// - Parameter date: The date to check.
  /// - Returns: `true` if the date is contained in the interval, `false` otherwise.
  public func contains(_ date: Date) -> Bool {
    guard let end else {
      return date == start
    }
    
    return (start...end).contains(date)
  }
  
  /// Get the duration of the interval.
  /// 
  /// - note: An open-ended interval will always have a duration of `0`.
  public var duration: TimeInterval {
    guard
      let end
    else { return 0 }
    
    return end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
  }
  
  /// Get if this interval has an end date or not.
  public var isOpenEnded: Bool {
    end == nil
  }
}

extension OpenDateInterval: CustomDebugStringConvertible {
  public var debugDescription: String {
    var debugString = "[\(start)"
    if let end {
      debugString += "\(end)]"
    } else {
      debugString += "...)"
    }
    
    return debugString
  }
}
