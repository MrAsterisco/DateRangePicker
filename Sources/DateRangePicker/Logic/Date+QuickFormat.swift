//
//  Date+QuickFormat.swift
//  
//
//  Created by Alessio Moiso on 15.04.23.
//

import Foundation

extension Date {
  var formattedMonth: String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    return formatter.string(from: self)
  }
  
  var formattedYear: String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY"
    return formatter.string(from: self)
  }
}

// MARK: - Convenience Methods
extension Date {
  static func date(from dateString: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: dateString)!
  }
}
